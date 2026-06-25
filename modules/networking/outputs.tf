output "vpc_id"{
    description = "vpc_id"
    value = aws_vpc.vpc.id
}
output "public_subnet_ids"{
    description = "public_subnet_ids"
    value = aws_subnet.public[*].id
}
output "private_subnet_ids"{
    description = "private_subnet_ids"
    value = aws_subnet.private[*].id
}
output "eks_cluster_sg_id" {
    description = "The ID of the EKS cluster control plane security group"
    value       = aws_security_group.eks_cluster.id
}
output "eks_nodes_sg_id" {
    description = "The ID of the EKS cluster control plane security group"
    value       = aws_security_group.eks_nodes.id
}