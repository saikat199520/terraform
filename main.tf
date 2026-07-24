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
module "access" {
    source = "./modules/access"
    env =  var.env
    name = var.name
}
module "eks" {
    source = "./modules/eks"
    env =  var.env
    name = var.name
    private_subnet_ids = module.networking.private_subnet_ids
    eks_cluster_role_arn = module.access.eks_cluster_role_arn
    eks_node_role_arn = module.access.eks_node_role_arn
    eks_nodes_sg_id = module.networking.eks_nodes_sg_id
    eks_cluster_sg_id = module.networking.eks_cluster_sg_id
    node_min_size = var.node_min_size
    node_max_size = var.node_max_size
    node_desired_size = var.node_desired_size
    cluster_version = var.cluster_version
    node_instance_types = var.node_instance_types
    node_ami_type = var.node_ami_type
    depends_on = [
    module.networking,
    module.access
  ]
}