output "cluster_name" {
  description = "The name of the EKS Cluster"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server"
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}