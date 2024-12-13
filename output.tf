output "load_balancer_dns" {
  description = "Load Balancer DNS"
  value       = aws_alb.eks_alb.dns_name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}
