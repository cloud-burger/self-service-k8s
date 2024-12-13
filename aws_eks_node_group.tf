resource "aws_eks_node_group" "cluster_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "NG-${var.project}"
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids      = [local.aws_public_subnet_id, local.aws_public_subnet2_id]
  disk_size       = 50
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
