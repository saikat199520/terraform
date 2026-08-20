
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
}

output "storage_roles" {
  value = aws_iam_role.ebs_efs_shared_role.arn
}

#output "vpc_cni_role" {
#  value = aws_iam_role.vpc_cni_role.arn
#}