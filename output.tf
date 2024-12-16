output "load_balancer_dns" {
  description = "Load Balancer DNS"
  value       = aws_alb.eks_alb.dns_name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "ecr_repository_url" {
  description = "ECR Repository url"
  value       = aws_ecr_repository.main.repository_url
}

output "ecr_registry_id" {
  description = "ECR Registry id"
  value       = aws_ecr_repository.main.registry_id
}
