resource "aws_vpc" "vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = var.dns_hostname
    enable_dns_support = var.dns_support

    tags = {
        Name = "${var.env}-${var.name}-vpc"
    }
}
resource "aws_internet_gateway" "ig"{
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.env}-${var.name}-ig"
    }
}
resource "aws_subnet" "public"{
    vpc_id = aws_vpc.vpc.id
    count = length(var.public_subnets)
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.zones_public[count.index]
    map_public_ip_on_launch = var.public_ip[count.index]

    tags = {
        Name = "${var.env}-${var.name}-public_subnet-${var.zones_public[count.index]}"
        #"kubernetes.io/role/elb" = "1"
        #"kubernetes.io/cluster/${var.env}-${var.name}-eks" = "shared"

    }
}
resource "aws_subnet" "private"{
    vpc_id = aws_vpc.vpc.id
    count = length(var.private_subnets)
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.zones_private[count.index]
    
    tags = {
        Name = "${var.env}-${var.name}-private_subnet-${var.zones_private[count.index]}"
        #"kubernetes.io/role/elb" = "1"
        #"kubernetes.io/cluster/${var.env}-${var.name}-eks" = "shared"

    }
}
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
        Name = "${var.env}-${var.name}-public-rt"
    }
}
resource "aws_route_table_association" "public"{
    count = length(var.public_subnets)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "private"{
    vpc_id = aws_vpc.vpc.id
    

    tags = {
        Name = "${var.env}-${var.name}-private-rt"
    }
}
resource "aws_route_table_association" "private"{
    count = length(var.private_subnets)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}