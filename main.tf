module "networking"{
    source = "./modules/networking"
    vpc_cidr =  var.vpc_cidr
    env =  var.env
    name = var.name
    zones_public = var.zones_public
    public_subnets = var.public_subnets
    public_ip = var.public_ip
    private_subnets = var.private_subnets
    zones_private = var.zones_private
    dns_hostname = var.dns_hostname
    dns_support = var.dns_support
}