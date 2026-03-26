variables "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variables "ami" {
  description = "AMI type for the EKS node group"
  type        = string
}

variables "instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
}

variables "desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}

variables "max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}

variables "min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
}

variables "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variables "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}   

variables "node_role_arn" {
  description = "ARN of the IAM role for the EKS node group"
  type        = string
}

variables "eks_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.31"
}

