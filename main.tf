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
    node_max_unavailable = var.node_max_unavailable
    node_desired_size = var.node_desired_size
    cluster_version = var.cluster_version
    node_instance_types = var.node_instance_types
    node_ami_type = var.node_ami_type
    depends_on = [module.networking,module.access]
}
module "accessgrantslater" {
    source = "./modules/accessgrantslater"
    env =  var.env
    name = var.name
    eks_cluster_name = module.eks.cluster_name
    eks_cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
    eks_admin_user_arns = var.eks_admin_user_arns
    depends_on = [module.eks]
}
module "eksaddons" {
    source = "./modules/eksaddons"
    eks_cluster_name = module.eks.cluster_name
    aws_eks_extra_storage_roles = module.accessgrantslater.storage_roles
    #aws_eks_vpc_cni_role =  module.accessgrantslater.vpc_cni_role
    depends_on = [module.eks,module.accessgrantslater]
}