resource "aws_eks_access_policy_association" "eks_policy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.eks_role.arn

  access_scope {
    type = "cluster"
  }
}
