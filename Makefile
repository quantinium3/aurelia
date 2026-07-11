SHELL := /usr/bin/env bash

AWS_REGION    ?= ap-south-1
CLUSTER_NAME  ?= aurelia-dev

BOOTSTRAP_DIR := terraform/bootstrap
SHARED_DIR    := terraform/environments/shared
DEV_DIR       := terraform/environments/dev

ECR_REGISTRY   = $(shell aws sts get-caller-identity --query Account --output text).dkr.ecr.$(AWS_REGION).amazonaws.com
GIT_SHA        = $(shell git rev-parse HEAD)

.DEFAULT_GOAL := help

# ------------------------------------------------------------------------------
# First-time / from-scratch setup order:
#   1. bootstrap-apply          (once ever - creates the Terraform state bucket)
#   2. shared-apply             (ECR repos + GitHub Actions OIDC role)
#   3. generate-deploy-key      (once - Image Updater git write-back SSH key)
#   4. generate-vpn-certs       (once - Client VPN mutual-auth certs)
#   5. dev-apply                (VPC, EKS, RDS, ElastiCache, ArgoCD, ALB
#                                 controller, external-dns, external-secrets,
#                                 image-updater, CloudWatch, VPN, ACM - all of
#                                 it, one terraform apply)
#   6. kubeconfig                (point kubectl at the new cluster)
#   7. image-updater-secrets    (apply the SecretStore/ExternalSecret/ImageUpdater CRs)
#   8. argocd-apps              (apply the per-service Application manifests)
# Everything after that is day-to-day: status, check-*, argocd-password, etc.
# ------------------------------------------------------------------------------

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2}'

## --- Bootstrap (Terraform state bucket, run once ever) ---

.PHONY: bootstrap-init
bootstrap-init: ## terraform init the bootstrap stack
	cd $(BOOTSTRAP_DIR) && terraform init

.PHONY: bootstrap-apply
bootstrap-apply: ## terraform apply the bootstrap stack (creates the S3 state bucket)
	cd $(BOOTSTRAP_DIR) && terraform apply

## --- Shared environment (ECR repos + GitHub Actions OIDC role) ---

.PHONY: shared-init
shared-init: ## terraform init the shared environment
	cd $(SHARED_DIR) && terraform init

.PHONY: shared-plan
shared-plan: ## terraform plan the shared environment
	cd $(SHARED_DIR) && terraform plan

.PHONY: shared-apply
shared-apply: ## terraform apply the shared environment
	cd $(SHARED_DIR) && terraform apply

.PHONY: tf-actions-var
tf-actions-var: ## Set the TF_AWS_ROLE_ARN Actions variable from shared output (run once after shared-apply)
	gh variable set TF_AWS_ROLE_ARN --body "$$(cd $(SHARED_DIR) && terraform output -raw terraform_role_arn)"

## --- Dev environment (VPC, EKS, RDS, ElastiCache, addons, VPN, ACM) ---

.PHONY: dev-init
dev-init: ## terraform init the dev environment
	cd $(DEV_DIR) && terraform init

.PHONY: dev-plan
dev-plan: ## terraform plan the dev environment
	cd $(DEV_DIR) && terraform plan

.PHONY: dev-import
dev-import: ## terraform import a resource into the dev state (make dev-import ADDR=aws_x.y ID=abc)
	$(if $(ADDR),,$(error ADDR is required, e.g. ADDR=aws_route53_record.frontend_public))
	$(if $(ID),,$(error ID is required))
	cd $(DEV_DIR) && terraform import $(ADDR) $(ID)

.PHONY: dev-apply
dev-apply: ## terraform apply the dev environment
	cd $(DEV_DIR) && terraform apply

.PHONY: dev-destroy
dev-destroy: ## terraform destroy the dev environment - DESTRUCTIVE, tears down the whole EKS stack
	cd $(DEV_DIR) && terraform destroy

.PHONY: dev-output
dev-output: ## Show all terraform outputs for the dev environment
	cd $(DEV_DIR) && terraform output

.PHONY: dev-unlock
dev-unlock: ## Force-unlock a stuck dev state lock (make dev-unlock LOCK_ID=<id>)
	cd $(DEV_DIR) && terraform force-unlock $(LOCK_ID)

.PHONY: fmt
fmt: ## Format every Terraform root/module in the repo
	terraform fmt -recursive terraform/

## --- Cluster access ---

.PHONY: kubeconfig
kubeconfig: ## Point kubectl at the EKS cluster
	aws eks update-kubeconfig --name $(CLUSTER_NAME) --region $(AWS_REGION)

## --- One-time secrets/certs (must exist before the first dev-apply) ---

.PHONY: generate-deploy-key
generate-deploy-key: ## One-time: generate the SSH deploy key for Image Updater's git write-back
	bash terraform/scripts/generate-deploy-key.sh

.PHONY: generate-vpn-certs
generate-vpn-certs: ## One-time: generate CA/server/client certs for Client VPN and upload to ACM
	bash terraform/scripts/generate-certs.sh

## --- ArgoCD ---

.PHONY: argocd-password
argocd-password: ## Print the initial ArgoCD admin password
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

.PHONY: argocd-forward
argocd-forward: ## Port-forward the ArgoCD UI to https://localhost:8080
	kubectl -n argocd port-forward svc/argocd-server 8080:443

.PHONY: argocd-apps
argocd-apps: ## Apply all ArgoCD Application manifests (one per microservice)
	kubectl apply -f argocd/applications/

.PHONY: image-updater-secrets
image-updater-secrets: ## Apply the Image Updater's SecretStore/ExternalSecret/ImageUpdater CRs
	kubectl apply -f argocd/image-updater/secretstore.yaml
	kubectl apply -f argocd/image-updater/externalsecret.yaml
	kubectl apply -f argocd/image-updater/imageupdater.yaml

.PHONY: check-argocd-apps
check-argocd-apps: ## Show sync/health status of all ArgoCD Applications
	kubectl get applications -n argocd

.PHONY: argocd-refresh
argocd-refresh: ## Force a hard refresh + resync of one ArgoCD Application (make argocd-refresh APP=frontend)
	$(if $(APP),,$(error APP is required, e.g. make argocd-refresh APP=frontend))
	kubectl -n argocd patch application $(APP) --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'

.PHONY: argocd-app-status
argocd-app-status: ## Show one ArgoCD Application's sync revision/status/conditions (make argocd-app-status APP=frontend)
	$(if $(APP),,$(error APP is required, e.g. make argocd-app-status APP=frontend))
	kubectl -n argocd get application $(APP) -o jsonpath='{.status.sync}{"\n"}{.status.conditions}{"\n"}'

## --- VPN (private access to the cluster API / RDS / ElastiCache) ---

.PHONY: vpn-client-config
vpn-client-config: ## Export the Client VPN config file (make vpn-client-config ENDPOINT_ID=<id>)
	aws ec2 export-client-vpn-client-configuration \
		--client-vpn-endpoint-id $(ENDPOINT_ID) \
		--region $(AWS_REGION) \
		--output text > client-config.ovpn
	@echo "Wrote client-config.ovpn - append certs/aurelia-client-1.crt and certs/aurelia-client-1.key before connecting."

## --- Verification ---

.PHONY: status
status: ## Show pods across every namespace
	kubectl get pods -A

.PHONY: check-ingress
check-ingress: ## Show the frontend Ingress and its ALB address
	kubectl get ingress -A

.PHONY: check-alarms
check-alarms: ## Show state of every CloudWatch alarm
	aws cloudwatch describe-alarms --region $(AWS_REGION) --query "MetricAlarms[].{Name:AlarmName,State:StateValue}" --output table

.PHONY: check-observability
check-observability: ## Show Container Insights (cloudwatch-agent/fluent-bit) pod status
	kubectl get pods -n amazon-cloudwatch

## --- Manual image build/push (CI does this automatically on push to master) ---

.PHONY: ecr-login
ecr-login: ## Authenticate Docker to ECR
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)

.PHONY: build-push
build-push: ecr-login ## Manually build+push a service image (make build-push SERVICE=frontend)
	$(if $(SERVICE),,$(error SERVICE is required, e.g. make build-push SERVICE=frontend))
	docker build -t $(ECR_REGISTRY)/$(SERVICE):manual-$(GIT_SHA) $(if $(filter cartservice,$(SERVICE)),src/cartservice/src,src/$(SERVICE))
	docker push $(ECR_REGISTRY)/$(SERVICE):manual-$(GIT_SHA)

.PHONY: build-push-migrations
build-push-migrations: ecr-login ## Manually build+push the productcatalogservice migrations image
	docker build -t $(ECR_REGISTRY)/productcatalogservice-migrations:manual-$(GIT_SHA) src/productcatalogservice/migrations
	docker push $(ECR_REGISTRY)/productcatalogservice-migrations:manual-$(GIT_SHA)
