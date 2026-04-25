# EKS Production Platform (Work in Progress)

🚧 Work in Progress: AWS EKS Platform Project

This project is currently under development as I deepen my hands-on understanding of Kubernetes, Amazon EKS, platform engineering, and cloud-native operations.

The goal is to build a production-style Kubernetes platform on AWS using modern DevOps practices including Infrastructure as Code, ingress, observability, GitOps, CI/CD, and secure networking.

---

## What I’ve Implemented So Far

### AWS Infrastructure with Terraform
- Custom VPC built with Terraform
- Public and private subnets across multiple Availability Zones
- Internet Gateway for public traffic
- NAT Gateway for controlled outbound access from private subnets
- Route tables and subnet associations
- Remote Terraform state stored in Amazon S3

### Amazon EKS Platform
- Amazon EKS cluster provisioned with Terraform modules
- Managed node group deployed across private subnets
- IAM roles for control plane and worker nodes
- Automated EKS access management using Terraform access entries

### Kubernetes Foundations
- Cluster access configured with kubectl
- Core Kubernetes namespaces validated
- Workload scheduling verified across nodes
- Kubernetes resource structure prepared for applications

### Ingress and Traffic Management
- NGINX Ingress Controller deployed using Helm
- AWS LoadBalancer created for external traffic entry
- Ready for application routing through Kubernetes Ingress resources

### Observability and Monitoring
- Prometheus deployed with Helm
- Grafana deployed with Helm
- Monitoring namespace created
- Cluster metrics collection enabled
- Node exporter running on worker nodes
- kube-state-metrics deployed
- Grafana exposed through AWS LoadBalancer

### Troubleshooting and Operations
Worked through real engineering issues during the build:
- EKS authentication and access control issues
- kubeconfig endpoint refresh after cluster recreation
- Helm deployment failures
- Persistent volume claim issues with Prometheus
- Layered Terraform applies for cluster bootstrapping
- Kubernetes workload verification using kubectl

---

## Current Focus

- Deploying the application workload into EKS
- Kubernetes Services and Ingress resources
- HTTPS with CertManager
- Dynamic DNS with ExternalDNS
- GitOps deployments with ArgoCD
- CI/CD automation pipelines
- Enhanced Grafana dashboards and alerting
- Architecture documentation

---

## Tech Stack

- AWS
- Amazon EKS
- Terraform
- Kubernetes
- Helm
- Prometheus
- Grafana
- NGINX Ingress Controller
- IAM
- GitHub Actions (planned)
- ArgoCD (planned)

---

## Why This Project

This project is focused on building real platform engineering skills, not just deploying containers. It covers networking, security, automation, observability, troubleshooting, and Kubernetes operations in a cloud environment.

---

## More Updates Coming

This repository will continue evolving as more components are implemented.
