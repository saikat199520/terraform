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