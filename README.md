# EKS Production Platform on AWS  
## Amazon EKS, Terraform, Kubernetes, GitHub Actions, ArgoCD, HTTPS, Monitoring

![AWS](https://img.shields.io/badge/aws-cloud-orange)
![EKS](https://img.shields.io/badge/amazon%20eks-kubernetes-blue)
![Terraform](https://img.shields.io/badge/terraform-iac-purple)
![Kubernetes](https://img.shields.io/badge/kubernetes-orchestration-blue)
![GitHub Actions](https://img.shields.io/badge/github%20actions-ci%2Fcd-black)
![ArgoCD](https://img.shields.io/badge/argocd-gitops-red)
![Docker](https://img.shields.io/badge/docker-containers-blue)
![Prometheus](https://img.shields.io/badge/prometheus-monitoring-orange)
![Grafana](https://img.shields.io/badge/grafana-observability-orange)
![HTTPS](https://img.shields.io/badge/https-letsencrypt-green)

A production-style Kubernetes platform deployed on Amazon EKS using Terraform, Kubernetes, GitHub Actions, ArgoCD, Helm, ExternalDNS, cert-manager, Prometheus and Grafana.

The platform deploys a containerised web application to Amazon EKS, exposes it publicly through NGINX Ingress, manages DNS automatically with ExternalDNS, provisions trusted HTTPS certificates with cert-manager and Let’s Encrypt, and monitors cluster health using Prometheus and Grafana.

The application was available at:

```text
https://eks.tm.paramjyot2ray.com

```

## Architecture Diagram

<img width="1159" height="1339" alt="EKS Architectural diagram" src="https://github.com/user-attachments/assets/644b2879-6ff6-4d4e-b771-e8f83cb69ed2" />


## Table of Contents

- Overview
- Tech Stack
- Repository Structure
- Architecture Overview
- CI/CD Workflow
- Kubernetes Application Flow
- GitOps with ArgoCD
- DNS and HTTPS
- Monitoring and Observability
- Security and Validation
- Terraform and State Management
- Screenshots
- Destroy Workflow
- What This Project Demonstrates
- Future Improvements

## Overview

This project demonstrates an end-to-end Amazon EKS platform following real-world DevOps and platform engineering practices.

It includes:

- Infrastructure as Code using Terraform
- Modular AWS infrastructure design
- Amazon EKS cluster provisioning
- Managed worker nodes in private subnets
- Docker image build and push to Amazon ECR
- CI/CD automation with GitHub Actions
- OIDC authentication with no long-lived AWS keys
- GitOps deployment using ArgoCD
- NGINX Ingress Controller for external traffic
- ExternalDNS for automated Route53 DNS updates
- cert-manager for automated TLS certificates
- HTTPS using Let’s Encrypt
- Prometheus for metrics collection
- Grafana for dashboard visualisation
- Full platform teardown using a guarded destroy pipeline

The focus of this project is not just deploying an application.

The focus is building the platform around the application.

## Tech Stack
### Cloud and Infrastructure
- AWS
- Amazon EKS
-  Amazon ECR
- Amazon VPC
- IAM
- KMS
- Route53
- Elastic Load Balancing
## Infrastructure as Code
- Terraform
- Modular Terraform structure
- S3 remote backend
- S3 state locking using use_lockfile = true
## Kubernetes Platform
- Kubernetes
- Managed node groups
- NGINX Ingress Controller
- cert-manager
- ExternalDNS
- Helm
## CI/CD and GitOps
- GitHub Actions
- OIDC authentication
- ArgoCD
- Docker
- Trivy
- Checkov
- TFLint
## Monitoring and Observability
- Prometheus
- Grafana
- kube-state-metrics
- node-exporter


## Repository Structure
```
eks-production-platform/
│
├── .github/
│   └── workflows/
│       ├── terraform-plan.yaml          # Terraform validation, linting, Checkov and plan
│       ├── terraform-apply.yaml         # Manual infrastructure deployment
│       ├── platform-addons.yaml         # Helm-based platform add-ons deployment
│       ├── build-scan-push.yaml         # Docker build, Trivy scan, ECR push and image tag update
│       └── terraform-destroy.yaml       # Full guarded platform and infrastructure teardown
│
├── app/
│   └── Dockerfile                       # Application container image build
│
├── kubernetes/
│   ├── app/
│   │   ├── deployment.yaml              # Kubernetes Deployment
│   │   ├── service.yaml                 # Kubernetes Service
│   │   └── ingress.yaml                 # Ingress and TLS configuration
│   │
│   ├── argocd/
│   │   └── web-app.yaml                 # ArgoCD Application
│   │
│   └── cert-manager/
│       └── cluster-issuer.yaml          # Let’s Encrypt ClusterIssuer
│
├── terraform/
│   ├── provider.tf                      # Providers and remote backend
│   ├── main.tf                          # Root Terraform module calls
│   ├── variables.tf                     # Root variables
│   ├── outputs.tf                       # Root outputs
│   ├── terraform.tfvars                 # Environment values
│   │
│   └── modules/
│       ├── vpc/                         # VPC, subnets, routing, NAT, IGW
│       ├── eks/                         # EKS cluster, node group, IAM, KMS
│       └── ecr/                         # ECR repository
│
└── README.md
```
## Architecture Overview

The platform runs inside a custom AWS VPC.

Traffic flow:

```
User
↓
Route53 DNS record
↓
AWS Load Balancer
↓
NGINX Ingress Controller
↓
Kubernetes Service
↓
Web application Pods
```

### Infrastructure flow:

```
Terraform
↓
AWS VPC, subnets, IAM, ECR, EKS, node groups
↓
GitHub Actions platform pipeline
↓
Helm installs platform add-ons
↓
ArgoCD deploys Kubernetes application manifests
```

### Deployment flow:

```
Developer pushes code
↓
GitHub Actions builds Docker image
↓
Trivy scans image
↓
Image pushed to Amazon ECR
↓
deployment.yaml image tag updated automatically
↓
ArgoCD detects Git change
↓
Kubernetes rolls out updated pods

```

## CI/CD Workflow

All pipelines use GitHub Actions.

Authentication to AWS is handled using GitHub OIDC.

No long-lived AWS access keys are stored in GitHub.

## Terraform Plan

```
terraform-plan.yaml
```
Purpose:

- Runs manually using workflow_dispatch
- Initializes Terraform
- Formats and validates Terraform code
- Runs TFLint
- Runs Checkov security scanning
- Generates a Terraform execution plan

This provides a safe review stage before infrastructure changes are applied.

## Terraform Apply

```
terraform-apply.yaml

```
Purpose:

- Runs manually using workflow_dispatch
- Authenticates to AWS using OIDC
- Runs Terraform init
- Applies infrastructure changes
- Creates or updates the EKS platform infrastructure

This provisions:

- VPC
- public and private subnets
- NAT Gateway
- Internet Gateway
- IAM roles
- EKS cluster
- managed node group
- ECR repository
- KMS encryption for EKS secrets

## Platform Addons

```
platform-addons.yaml
```

Purpose:

Installs and configures Kubernetes platform components using Helm.

Installed components:

- ArgoCD
- NGINX Ingress Controller
- cert-manager
- ExternalDNS
- Prometheus
- Grafana

It also applies:

- cert-manager ClusterIssuer
- ArgoCD Application manifest

This means the Kubernetes platform can be rebuilt without manually applying these resources from the terminal.

## Build, Scan and Push

```
build-scan-push.yaml
```

Purpose:

- Builds the Docker image
- Scans the image using Trivy
- Pushes the image to Amazon ECR
- Tags the image using the Git commit SHA
- Updates the Kubernetes deployment image tag automatically
- Pushes the updated manifest back to GitHub

This connects CI with GitOps.

The pipeline does not directly deploy the app into the cluster.

Instead:

```
GitHub Actions updates deployment.yaml
↓
ArgoCD detects the Git change
↓
ArgoCD syncs Kubernetes
```
## Kubernetes Application Flow

The application is deployed using Kubernetes manifests.

### Deployment

```
kubernetes/app/deployment.yaml
```

The Deployment defines:

- application container image
- replica count
- pod template
- container port
- rolling updates

It ensures the desired number of application pods stay running.

### Service
```
kubernetes/app/service.yaml
```

The Service provides stable internal networking for the application pods.

Pods are temporary and can be recreated.

The Service gives them a stable endpoint inside the cluster.

### Ingress

```
kubernetes/app/ingress.yaml
```

The Ingress defines external HTTP and HTTPS routing rules.

It routes traffic for:

```
eks.tm.paramjyot2ray.com

```
To the internal Kubernetes Service.

The Ingress also references the TLS secret created by cert-manager.

## GitOps with ArgoCD

ArgoCD is used as the GitOps deployment engine.

ArgoCD watches the Kubernetes manifests stored in GitHub.

When the manifests change, ArgoCD reconciles the cluster state to match the desired state in Git.

Flow:

```
Git repository
↓
ArgoCD Application
↓
Kubernetes Deployment, Service, Ingress and Certificate
↓
Running application
```

ArgoCD provides:

- automated sync
- application health checks
- deployment visibility
- resource tree view
- Git as the source of truth

## DNS and HTTPS

### ExternalDNS

ExternalDNS watches Kubernetes Ingress resources and updates Route53 automatically.

When the ingress load balancer changes, ExternalDNS updates the DNS record.

This removes the need to manually create or update Route53 records.

### cert-manager

cert-manager automates TLS certificate management inside Kubernetes.

It requests and renews certificates automatically.


### ClusterIssuer

The ClusterIssuer tells cert-manager how to request certificates.

This project uses Let’s Encrypt.

Once issued, the certificate is stored as a Kubernetes Secret and attached to the Ingress.

Final result:

```
https://eks.tm.paramjyot2ray.com
```
with a trusted browser certificate.

## Monitoring and Observability

Prometheus and Grafana are deployed using Helm.

### Prometheus

Prometheus collects metrics from:

- Kubernetes nodes
- pods
- services
- kube-state-metrics
- node-exporter
- cluster components

### Grafana

Grafana visualizes metrics using dashboards.

The project includes monitoring for:

- cluster memory usage
- container CPU usage
- container memory usage
- network I/O
- node-level metrics
- pod and workload visibility

### Security and Validation

Security practices implemented:

- GitHub OIDC authentication
- No static AWS credentials stored in GitHub
- IAM roles for GitHub Actions
- IAM roles for EKS cluster and worker nodes
- ECR image scanning on push
- Trivy container vulnerability scanning
- Checkov Infrastructure as Code scanning
- TFLint Terraform linting
- KMS encryption for EKS secrets
- ECR encryption
- immutable ECR image tags
- private subnets for worker nodes
- HTTPS with Let’s Encrypt
- manual guarded destroy workflow

### Terraform and State Management

Terraform uses a remote S3 backend.

```
backend "s3" {
  bucket       = "eks-deployment-tfstate"
  key          = "terraform.tfstate"
  region       = "ca-central-1"
  use_lockfile = true
}
```

This provides:

- centralised state storage
- safer collaboration
- state locking
- repeatable infrastructure deployment

## Screenshots

### Application over HTTPS


<img width="1920" height="1032" alt="Screenshot 2026-05-21 173157" src="https://github.com/user-attachments/assets/0fe99adc-fea8-4360-bc01-536da1d422ec" />


### Secure Browser Connection


<img width="1920" height="1032" alt="Screenshot 2026-05-21 173257" src="https://github.com/user-attachments/assets/4c9a9e94-bf90-4110-b74f-f5500ac32387" />



### ArgoCD Application Healthy and Synced

<img width="1918" height="948" alt="Screenshot 2026-05-21 172904" src="https://github.com/user-attachments/assets/00612cd7-9d2d-47d5-a42f-d1930e32b1aa" />


### ArgoCD Resource Tree

<img width="1920" height="949" alt="Screenshot 2026-05-21 173028" src="https://github.com/user-attachments/assets/2c5042aa-2298-465d-894f-e0f2b34547d2" />


### Grafana Monitoring Dashboard

<img width="1920" height="1032" alt="EPIC3350" src="https://github.com/user-attachments/assets/0801dd63-3af4-46a0-8446-899db06c6184" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171705" src="https://github.com/user-attachments/assets/a87e4dcd-ef14-4ab9-9626-0ca7b1d2f2fc" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171728" src="https://github.com/user-attachments/assets/b6bd8624-1105-44a1-8efe-9aaa9b53a008" />

<img width="1920" height="1032" alt="Screenshot 2026-05-21 171808" src="https://github.com/user-attachments/assets/e3dd1623-ce35-4a71-8742-e3df357cabe2" />


## GitHub Actions Pipelines

### Terraform plan pipeline

<img width="319" height="233" alt="plan" src="https://github.com/user-attachments/assets/25aa7a35-5337-4feb-a0b6-1ca58ef06773" />

### Terraform apply pipeline

<img width="345" height="235" alt="apply" src="https://github.com/user-attachments/assets/e006273f-97ce-4973-b938-9fd47125bf52" />

### Platform addons pipeline

<img width="350" height="217" alt="platform addons" src="https://github.com/user-attachments/assets/4b8086a3-4d49-4d4c-90de-22bf5fa7b7e0" />

### Build scan push pipeline

<img width="341" height="211" alt="build-scan-push" src="https://github.com/user-attachments/assets/469baa86-011c-4f62-9ca6-6924373f3220" />

### Terraform destroy pipeline

<img width="316" height="216" alt="destroy" src="https://github.com/user-attachments/assets/9de15b99-ece2-46e7-9e1d-0f1a1714b92b" />




## Destroy Workflow

The project includes a guarded destroy pipeline.

```
terraform-destroy.yaml
```
The workflow requires manual confirmation.

The user must type:

```
destroy
```
Before the workflow runs.

Destroy order:

```
Delete Kubernetes application
↓
Delete ArgoCD Application
↓
Delete ClusterIssuer
↓
Uninstall Helm platform add-ons
↓
Wait for AWS load balancers to delete
↓
Run terraform destroy
↓
Remove AWS infrastructure
```
This prevents accidental platform destruction and ensures Kubernetes-created AWS resources are cleaned up before Terraform destroys the underlying infrastructure.

### What This Project Demonstrates

This project demonstrates:

- production-style EKS platform design
- Kubernetes workload deployment
- Infrastructure as Code using Terraform
- modular Terraform structure
- CI/CD automation using GitHub Actions
- secure AWS authentication using OIDC
- GitOps deployment using ArgoCD
- Docker image build and deployment to ECR
- automated image tag updates
- Kubernetes Ingress traffic management
- automated DNS using ExternalDNS
- automated HTTPS using cert-manager and Let’s Encrypt
- monitoring using Prometheus and Grafana
- secure infrastructure teardown using a guarded destroy workflow
- troubleshooting across AWS, Terraform, Kubernetes, Helm and CI/CD

### Future Improvements

Potential future improvements:

- use separate dev and prod environments
- add custom Grafana dashboards
- add alerting rules in Prometheus/Grafana
- add Horizontal Pod Autoscaler
- add Kubernetes NetworkPolicies
- add sealed secrets or external secrets
- add ArgoCD app-of-apps pattern
- add Terraform environment separation
- add private EKS API endpoint
- restrict cluster public access CIDRs
- add cost monitoring and budget alarms









