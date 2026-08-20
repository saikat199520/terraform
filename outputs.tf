output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "The ARN of the IAM OIDC Provider"
  value       = module.accessgrantslater.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "The URL of the IAM OIDC Provider"
  value       = module.accessgrantslater.oidc_provider_url
}