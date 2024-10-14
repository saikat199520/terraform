resource "aws_nat_gateway" "eks-nat-gw" {
  allocation_id = aws_eip.eks-eip-nat.id
  subnet_id     = aws_subnet.eks-vpc-pub-sub1.id

  tags = {
    Name = "eks-${var.env}-nat-gw-ShowPilot"
    "pick" = "ShowPilot"
  }
}

#resource "aws_nat_gateway" "eks-nat2-gw" {
#  allocation_id = aws_eip.eks-eip-nat2.id
#  subnet_id     = aws_subnet.eks-vpc-pub-sub2.id

#  tags = {
#    Name = "eks-${var.env}-nat2-gw"
#  }
#}