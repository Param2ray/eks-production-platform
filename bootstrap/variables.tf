variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
  default     = "ca-central-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
  default     = "eks-deployment-tfstate"
}

variable "github_org" {
  description = "GitHub username or organization"
  type        = string
  default     = "Param2ray"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "eks-production-platform"
}

variable "frontend_ecr_name" {
  description = "Frontend ECR repository name"
  type        = string
  default     = "eks-platform-app"
}

variable "backend_ecr_name" {
  description = "Backend ECR repository name"
  type        = string
  default     = "eks-platform-backend"
}