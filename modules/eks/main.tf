resource "aws_eks_cluster" "eks"{
    name = "${var.env}-${var.name}-eks-cluster"
    role_arn = var.eks_cluster_role_arn
    version = var.cluster_version

    vpc_config{
        subnet_ids = var.private_subnet_ids
        endpoint_private_access = true
        endpoint_public_access = true
        security_group_ids      = [var.eks_cluster_sg_id]
    }

    access_config {
        authentication_mode = "API_AND_CONFIG_MAP"
        bootstrap_cluster_creator_admin_permissions = true
    }

    upgrade_policy {
    support_type = "STANDARD"
    }

}

resource "aws_launch_template" "nodes_launch_template" {
    name_prefix = "${var.env}-${var.name}-eks-node-"
    description = "Unified launch template for EKS managed worker nodes"
    vpc_security_group_ids = [var.eks_nodes_sg_id]
    
    metadata_options {
        http_endpoint               = "enabled"
        http_tokens                 = "required" # Forces IMDSv2
        http_put_response_hop_limit = 2          # Allows pod network hop to reach IMDS
    }

    block_device_mappings {
        device_name = "/dev/xvda"
        ebs {
            volume_size           = 50
            volume_type           = "gp3"
            delete_on_termination = true
        }
    }
}

resource "aws_eks_node_group" "nodes" {
    cluster_name = aws_eks_cluster.eks.name
    node_group_name = "${var.env}-${var.name}-eks-node-group"
    node_role_arn = var.eks_node_role_arn
    subnet_ids = var.private_subnet_ids

    ami_type = var.node_ami_type
    instance_types = var.node_instance_types

    launch_template {
        id      = aws_launch_template.nodes_launch_template.id
        version = aws_launch_template.nodes_launch_template.latest_version
    }

    scaling_config {
        desired_size = var.node_desired_size
        max_size = var.node_max_size
        min_size = var.node_min_size
    }
    update_config{
        max_unavailable = var.node_max_unavailable
    }

    labels = {
        role = "worker"
    }

    tags = {
        Name = "${var.env}-${var.name}-eks-node-group"
    }
}