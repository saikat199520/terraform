output "vpc_id" {
  description = "vpc_id"
  value       = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  description = "public_subnet_ids"
  value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  description = "private_subnet_ids"
  value       = aws_subnet.private[*].id
}
output "eks_cluster_sg_id" {
  description = "The ID of the EKS cluster control plane security group"
  value       = aws_security_group.eks_cluster.id
}
output "eks_nodes_sg_id" {
  description = "The ID of the EKS cluster control plane security group"
  value       = aws_security_group.eks_nodes.id
}
output "acm_dns_records" {
  value = {
    for dvo in aws_acm_certificate.ssl.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}
output "acm_ssl_arn" {
  value = aws_acm_certificate.ssl.arn
}