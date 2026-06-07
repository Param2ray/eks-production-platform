# EKS Production Platform on AWS

## Amazon EKS | Terraform | Kubernetes | GitHub Actions | ArgoCD | Traefik | Prometheus | Grafana

![AWS](https://img.shields.io/badge/AWS-CLOUD-orange)
![AMAZON\_EKS](https://img.shields.io/badge/AMAZON_EKS-KUBERNETES-blue)
![TERRAFORM](https://img.shields.io/badge/TERRAFORM-IAC-purple)
![KUBERNETES](https://img.shields.io/badge/KUBERNETES-ORCHESTRATION-blue)
![GITHUB\_ACTIONS](https://img.shields.io/badge/GITHUB_ACTIONS-CI%2FCD-black)
![ARGOCD](https://img.shields.io/badge/ARGOCD-GITOPS-red)
![DOCKER](https://img.shields.io/badge/DOCKER-CONTAINERS-blue)
![PROMETHEUS](https://img.shields.io/badge/PROMETHEUS-MONITORING-orange)
![GRAFANA](https://img.shields.io/badge/GRAFANA-OBSERVABILITY-orange)
![HTTPS](https://img.shields.io/badge/HTTPS-LETSENCRYPT-green)

Production-style Kubernetes platform deployed on Amazon EKS using Terraform, GitHub Actions, ArgoCD, Traefik, ExternalDNS, cert-manager, Prometheus and Grafana.

The platform provisions AWS infrastructure, deploys workloads using GitOps, automates HTTPS certificate management, manages DNS records automatically and provides cluster observability through Prometheus and Grafana.

---

## Table of Contents

* [Architecture Diagram](#architecture-diagram)
* [Project Overview](#project-overview)
* [Key Features](#key-features)
* [Technology Stack](#technology-stack)
* [Repository Structure](#repository-structure)
* [Architecture Overview](#architecture-overview)
* [CI/CD and GitOps Workflow](#cicd-and-gitops-workflow)
* [Security](#security)
* [Monitoring and Observability](#monitoring-and-observability)
* [Project Screenshots](#project-screenshots)
* [GitHub Actions Pipelines](#github-actions-pipelines)
* [Destroy Workflow](#destroy-workflow)
* [What This Project Demonstrates](#what-this-project-demonstrates)
* [Future Improvements](#future-improvements)

---

## Architecture Diagram

<img width="1159" height="1339" alt="EKS Architectural diagram drawio" src="https://github.com/user-attachments/assets/c87678fc-f636-4339-94e8-4a8c1e26ae5d" />

---

## Project Overview

This project demonstrates the design and deployment of a production-style Kubernetes platform on Amazon EKS.

The platform combines Infrastructure as Code, CI/CD automation, GitOps deployment practices and observability tooling to create a repeatable deployment workflow.

The application was deployed at:
```
Example deployment endpoint:

https://eks.tm.paramjyot2ray.com

Available when the platform is deployed through the automated infrastructure lifecycle.
```

## Key Features

* Modular Terraform infrastructure
* Amazon EKS cluster provisioning
* Docker image build and deployment to Amazon ECR
* GitHub Actions CI/CD pipelines
* Secure AWS authentication using OIDC
* GitOps deployment using ArgoCD
* Traefik ingress controller
* Automated DNS management using ExternalDNS
* Automated HTTPS certificates using cert-manager and Let's Encrypt
* Prometheus metrics collection
* Grafana monitoring dashboards
* Guarded infrastructure destroy workflow

---

## Technology Stack

### Cloud

* AWS
* Amazon EKS
* Amazon ECR
* Route53
* IAM
* KMS
* VPC
* Load Balancer

### Infrastructure as Code

* Terraform
* Modular Terraform Design
* Remote State Backend

### Kubernetes

* Kubernetes
* Traefik
* ArgoCD
* ExternalDNS
* cert-manager
* Helm

### CI/CD

* GitHub Actions
* Docker
* Trivy
* Checkov
* TFLint
* OIDC

### Monitoring

* Prometheus
* Grafana
* kube-state-metrics
* node-exporter

---

## Repository Structure

```text
eks-production-platform/
├── .github/
│   └── workflows/
│       ├── build-scan-push.yaml      # Build, scan and push image to ECR
│       ├── helmfile-sync.yaml        # Deploy platform add-ons with Helmfile
│       ├── terraform-apply.yaml      # Terraform apply
│       ├── terraform-destroy.yaml    # Guarded teardown workflow
│       └── terraform-plan.yaml       # Terraform plan
│
├── app/                              # Frontend application source
├── backend/                          # Backend API source
│
├── bootstrap/                        # One-time backend setup
│
├── kubernetes/
│   ├── app/                          # Web app manifests
│   ├── backend/                      # Backend API manifests
│   ├── argocd/                       # ArgoCD application definitions
│   ├── cert-manager/                 # ClusterIssuer manifest
│   ├── helm-values/                  # Helm values for platform add-ons
│   ├── monitoring/                   # Prometheus/Grafana values
│   └── helmfile.yaml                 # Helmfile platform add-ons
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/                      # VPC, subnets, routes, NAT, IGW
│   │   ├── eks/                      # EKS cluster, node groups, access
│   │   └── ecr/                      # Container registry
│   │
│   ├── external-dns-iam.tf           # IAM for ExternalDNS
│   ├── main.tf                       # Root Terraform configuration
│   ├── provider.tf                   # AWS provider configuration
│   ├── variables.tf                  # Input variables
│   ├── outputs.tf                    # Terraform outputs
│   └── terraform.tfvars              # Environment values
│
├── README.md
└── .gitignore
```

---

## Architecture Overview

### User Traffic Flow

```text
Internet User
      │
      ▼
Cloudflare DNS
      │
      ▼
Route53 Hosted Zone
      │
      ▼
AWS Load Balancer
      │
      ▼
Traefik Ingress Controller
      │
      ▼
Kubernetes Service
      │
      ▼
Application Pods
```

### Deployment Flow

```text
Developer Push
 ↓
GitHub Actions
 ↓
Docker Build
 ↓
Trivy Scan
 ↓
Amazon ECR
 ↓
Manifest Update
 ↓
ArgoCD
 ↓
Amazon EKS
```

### GitOps Flow

```text
Git Repository
 ↓
ArgoCD
 ↓
Kubernetes Resources
 ↓
Running Application
```

---

## CI/CD and GitOps Workflow

### Terraform Plan

* Terraform validation
* TFLint
* Checkov security scanning
* Infrastructure execution plan generation

### Terraform Apply

Creates and configures:

* VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* EKS Cluster
* Managed Node Groups
* ECR Repository
* IAM Roles and Policies
* OIDC Provider

### Platform Add-ons Deployment

Helmfile deploys and manages platform services:

* ArgoCD
* Traefik Ingress Controller
* cert-manager
* ExternalDNS
* Prometheus
* Grafana

### Build, Scan and Push

* Docker image build
* Trivy vulnerability scanning
* Push image to Amazon ECR
* Update Kubernetes image tag
* Commit manifest update to Git

### GitOps Deployment

ArgoCD continuously monitors the Git repository and automatically reconciles cluster state with Git.

Deployment flow:

GitHub Actions
↓
Amazon ECR
↓
Manifest Update
↓
Git Repository
↓
ArgoCD
↓
Amazon EKS

Git remains the single source of truth for all application and platform deployments.

### Terraform Destroy

Automated environment teardown:

* Remove application resources
* Remove ArgoCD applications
* Destroy Helm-managed platform services
* Clean up AWS load balancers
* Remove Kubernetes namespaces
* Destroy EKS infrastructure using Terraform

This enables cost-efficient testing and full environment recreation.

---

## Security

Implemented controls include:

* GitHub OIDC authentication
* No long-lived AWS credentials
* IAM least privilege
* Trivy image scanning
* Checkov infrastructure scanning
* TFLint validation
* KMS encryption
* HTTPS with Let's Encrypt
* Private worker nodes
* Guarded destroy workflow

---

## Monitoring and Observability

Prometheus collects metrics from:

* Nodes
* Pods
* Services
* Kubernetes workloads

Grafana dashboards provide visibility into:

* CPU usage
* Memory consumption
* Network traffic
* Cluster health
* Container performance

---

## Project Screenshots

<img width="1920" height="1032" alt="Screenshot 2026-05-21 173257" src="https://github.com/user-attachments/assets/559a6615-a604-405c-917f-2ea96b19c814" />

<img width="1920" height="1020" alt="hump me" src="https://github.com/user-attachments/assets/5a447f22-3323-4991-82d6-d7a7efbb335e" />

<img width="1920" height="1020" alt="treeee" src="https://github.com/user-attachments/assets/2ca9760f-743c-4c4d-b139-7efbf83748be" />

<img width="1920" height="1032" alt="EPIC3350" src="https://github.com/user-attachments/assets/b0c67965-160b-400b-975c-c9036f72da5c" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171705" src="https://github.com/user-attachments/assets/edb45185-397e-41e8-9ca0-f14203cd0edf" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171728" src="https://github.com/user-attachments/assets/928dd037-a258-43dc-b56b-d30163e66efd" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171808" src="https://github.com/user-attachments/assets/6a34eb86-2510-40b2-a951-9a9019f7aa1d" />

---

## GitHub Actions Pipelines

### Terraform Plan

<img width="319" height="233" alt="plan" src="https://github.com/user-attachments/assets/bb0bccca-adc0-4035-bdd4-7534b8b18570" />

### Terraform Apply

<img width="345" height="235" alt="apply" src="https://github.com/user-attachments/assets/a041edab-4234-4b79-8f92-78af6fd11606" />

### Platform Addons

<img width="336" height="208" alt="platform" src="https://github.com/user-attachments/assets/f9514ce1-7158-4ac3-8355-6f6f6773ae38" />

### Build Scan Push

<img width="341" height="211" alt="build-scan-push" src="https://github.com/user-attachments/assets/de636001-df39-4fe9-b53a-a19507b784dc" />

### Terraform Destroy

<img width="316" height="216" alt="destroy" src="https://github.com/user-attachments/assets/2993dd28-27f8-46e9-901a-5b4692475560" />

---

## Destroy Workflow

Manual confirmation is required before infrastructure destruction.

```text
destroy
```

Workflow order:

```text
Delete Application
 ↓
Delete ArgoCD Resources
 ↓
Remove Platform Components
 ↓
Wait For Load Balancer Cleanup
 ↓
Terraform Destroy
 ↓
AWS Infrastructure Removed
```

---

## What This Project Demonstrates

* Amazon EKS administration
* Kubernetes workload deployment
* Infrastructure as Code
* GitOps with ArgoCD
* CI/CD automation
* Secure AWS authentication
* Container image management
* Observability implementation
* Platform engineering concepts
* Cloud troubleshooting

## Project Outcomes

• Provisioned production-style EKS platform using Terraform
• Implemented GitOps deployments with ArgoCD
• Automated DNS management with ExternalDNS
• Automated TLS certificate issuance with cert-manager
• Implemented cluster observability with Prometheus and Grafana
• Secured AWS access using GitHub OIDC authentication
• Built fully automated platform lifecycle including destroy workflow

---

## Future Improvements

* ArgoCD App of Apps
* Horizontal Pod Autoscaler
* Network Policies
* External Secrets
* Separate dev and prod environments
* External Secrets
* Alerting Rules
* Private EKS API Endpoint
* Cost Monitoring
* Budget Alerts
* Environment Separation

```









