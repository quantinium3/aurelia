<!-- <p align="center">
<img src="/src/frontend/static/icons/Hipster_HeroLogoMaroon.svg" width="300" alt="Online Boutique" />
</p> -->

# Aurelia

> **Attribution**: This repository is derived from
> [GoogleCloudPlatform/microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo)
> ("Online Boutique"), licensed under [Apache 2.0](/LICENSE). The application
> source code in [`src/`](/src) and [`protos/`](/protos) is unmodified and
> remains the work of Google and contributors. All GCP-specific deployment
> tooling (Kubernetes manifests, Helm chart, Kustomize, Terraform, Istio
> manifests, Skaffold, Cloud Build, CI/CD workflows) has been removed from
> this fork — the original app is used here as a base for a from-scratch
> AWS/Kubernetes (EKS) deployment learning project, unaffiliated with Google.

**Online Boutique** is a cloud-first microservices demo application. The
application is a web-based e-commerce app where users can browse items, add
them to the cart, and purchase them.

## Architecture

**Online Boutique** is composed of 11 microservices written in different
languages that talk to each other over gRPC.

[![Architecture of
microservices](/docs/img/architecture-diagram.png)](/docs/img/architecture-diagram.png)

Find **Protocol Buffers Descriptions** at the [`./protos` directory](/protos).

| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](/src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](/src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](/src/productcatalogservice) | Go            | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](/src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](/src/paymentservice)               | Node.js       | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](/src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](/src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](/src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](/src/recommendationservice) | Python        | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](/src/adservice)                         | Java          | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](/src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |

## Screenshots

| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](/docs/img/online-boutique-frontend-1.png)](/docs/img/online-boutique-frontend-1.png) | [![Screenshot of checkout screen](/docs/img/online-boutique-frontend-2.png)](/docs/img/online-boutique-frontend-2.png) |

## About this fork

This repo strips out the original project's GCP/GKE-specific deployment
tooling and keeps only the application source. It's being used as the base
application for learning how to design, deploy, and operate a microservices
architecture on AWS (EKS, IAM/IRSA, Terraform, ArgoCD, etc.) instead of
Google Cloud. Deployment tooling for that setup will be added under this
repo separately from the upstream application code.

## Documentation

- [Development](/docs/development-guide.md) to learn how to run and develop this app locally.
- [Adding a new microservice](/docs/adding-new-microservice.md)
- [Product requirements](/docs/product-requirements.md)
- [Purpose of the demo](/docs/purpose.md)
