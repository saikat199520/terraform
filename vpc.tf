resource "aws_vpc" "eks-vpc" {
  cidr_block       = "${vpc-cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "eks-${var.env}-vpc"
    "pick" = "${var.pick}"
  }

  enable_dns_support   = true
  enable_dns_hostnames = true
}