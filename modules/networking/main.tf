resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.dns_hostname
  enable_dns_support   = var.dns_support

  tags = {
    Name = "${var.env}-${var.name}-vpc"
  }
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.name}-ig"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.zones_public[count.index]
  map_public_ip_on_launch = var.public_ip[count.index]

  tags = {
    Name                                                       = "${var.env}-${var.name}-public_subnet-${var.zones_public[count.index]}"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/cluster/${var.env}-${var.name}-eks-cluster" = "shared"

  }
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.private_subnets)
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.zones_private[count.index]

  tags = {
    Name                                                       = "${var.env}-${var.name}-private_subnet-${var.zones_private[count.index]}"
    "kubernetes.io/role/internal-elb"                          = "1"
    "kubernetes.io/cluster/${var.env}-${var.name}-eks-cluster" = "shared"

  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "${var.env}-${var.name}-public-rt"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name                                                       = "${var.env}-${var.name}-private-rt"
    "kubernetes.io/role/internal-elb"                          = 1
    "kubernetes.io/cluster/${var.env}-${var.name}-eks-cluster" = "shared"
  }
}



resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name = "${var.env}-${var.name}-nat-eip-${var.zones_public[0]}"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.env}-${var.name}-nat-gw-${var.zones_public[0]}"
  }
}
resource "aws_security_group" "eks_nodes" {
  name   = "${var.env}-${var.name}-eks-worker-sg"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                                       = "${var.env}-${var.name}-eks-worker-sg"
    "kubernetes.io/cluster/${var.env}-${var.name}-eks-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "self_route" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id

}


resource "aws_security_group" "eks_cluster" {
  name   = "${var.env}-${var.name}-eks-cluster-sg"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                                       = "${var.env}-${var.name}-eks-cluster-sg"
    "kubernetes.io/cluster/${var.env}-${var.name}-eks-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "cluster_self_route" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_cluster.id

}

resource "aws_security_group_rule" "nodes_to_cluster" {
  type                     = "ingress"
  from_port                = 0    #443
  to_port                  = 0    #443
  protocol                 = "-1" #"tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id # 👈 Source is Nodes
  description              = "Allow worker nodes to check into the Kubernetes API"
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  type                     = "ingress"
  from_port                = 0    #10250
  to_port                  = 0    #10250
  protocol                 = "-1" #"tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id # 👈 Source is Cluster Control Plane
  description              = "Allow control plane to manage pods and pull logs"
}

resource "aws_security_group" "pg_sg" {
  name   = "${var.env}-${var.name}-pg-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.name}-pg-sg"
  }
}
resource "aws_security_group" "mysql_sg" {
  name   = "${var.env}-${var.name}-mysql-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name}-mysql-sg"
  }
}
resource "aws_security_group" "redis_sg" {
  name   = "{$var.env}-${var.name}-redis-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name}-redis-sg"
  }
}
resource "aws_acm_certificate" "ssl" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain}"]

  lifecycle {
    create_before_destroy = true
  }
}