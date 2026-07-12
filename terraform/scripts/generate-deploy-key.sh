#!/usr/bin/env bash
set -euo pipefail

# Generates an SSH deploy key for argocd-image-updater's git write-back,
# adds it to the GitHub repo with write access, and stores the private
# key in AWS Secrets Manager (never committed to git).
#
# Requires: ssh-keygen, gh (authenticated), aws cli
# Run this once, locally. Not part of the Terraform apply itself.

REGION="ap-south-1"
REPO="quantinium3/aurelia"
SECRET_NAME="aurelia/image-updater/git-ssh-key"
OUTPUT_DIR="$(pwd)/image-updater"

mkdir -p "$OUTPUT_DIR"
KEY_PATH="$OUTPUT_DIR/deploy_key"

if [ -f "$KEY_PATH" ]; then
  echo "Error: $KEY_PATH already exists. Remove it first if you want to regenerate." >&2
  exit 1
fi

echo "Generating SSH deploy key..."
ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "argocd-image-updater"

echo "Adding deploy key to $REPO with write access..."
gh repo deploy-key add "${KEY_PATH}.pub" --repo "$REPO" --title "argocd-image-updater" --allow-write

echo "Storing private key in Secrets Manager as $SECRET_NAME..."
aws secretsmanager create-secret \
  --name "$SECRET_NAME" \
  --description "SSH deploy key for argocd-image-updater git write-back" \
  --secret-string "file://${KEY_PATH}" \
  --region "$REGION"

echo "Removing local private key copy (kept safely in Secrets Manager)..."
rm "$KEY_PATH"

echo ""
echo "Done. Public key kept at: ${KEY_PATH}.pub"
echo "Private key stored in Secrets Manager: $SECRET_NAME"
