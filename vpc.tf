resource "aws_vpc" "eks-vpc" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "eks-${var.env}-vpc-ShowPilot"
    "pick" = "ShowPilot"
  }

  enable_dns_support   = true
  enable_dns_hostnames = true
}