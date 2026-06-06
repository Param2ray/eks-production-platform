resource "aws_eks_access_entry" "param_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::512378127667:user/Param"
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_access_policy_association" "param_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.param_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.param_admin
  ]
}

resource "aws_eks_access_entry" "github_actions_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::512378127667:role/github-actions-eks-platform-role"
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_access_policy_association" "github_actions_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.github_actions_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.github_actions_admin
  ]
}

resource "aws_eks_access_entry" "github_actions_deploy_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::512378127667:role/github-actions-deploy-role"
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_access_policy_association" "github_actions_deploy_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.github_actions_deploy_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.github_actions_deploy_admin
  ]
}