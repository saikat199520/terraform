resource "aws_eks_addon" "ebs_csi" {
  cluster_name = var.eks_cluster_name
  addon_name = "aws-ebs-csi-driver"
  service_account_role_arn = var.aws_eks_extra_storage_roles
  
  configuration_values = jsonencode({  ######have reduced the replica set to 1 for budget constraint
    controller = {
      replicaCount = 1
    }
  })

}
resource "aws_eks_addon" "efs_csi" {
  cluster_name = var.eks_cluster_name
  addon_name = "aws-efs-csi-driver"
  service_account_role_arn = var.aws_eks_extra_storage_roles
  
  configuration_values = jsonencode({  ######have reduced the replica set to 1 for budget constraint
    controller = {
      replicaCount = 1
    }
  })

}

resource "aws_eks_addon" "secrets_store" {
  cluster_name = var.eks_cluster_name
  addon_name = "aws-secrets-store-csi-driver-provider"

}
resource "aws_eks_addon" "metrics_server" {
  cluster_name = var.eks_cluster_name
  addon_name = "metrics-server"
  
  configuration_values = jsonencode({  ######have reduced the replica set to 1 for budget constraint
    replicas = 1
  })

}
#resource "aws_eks_addon" "kube_state_metrics" {  #### if using prometheus you can turn this on and turn off metrics server
#  cluster_name = var.eks_cluster_name
#  addon_name = "kube-state-metrics"
#
#  configuration_values = jsonencode({  ######have reduced the replica set to 1 for budget constraint
#     replicas = 1
#  })
#}
############           marked for removal on a later date
#resource "aws_eks_addon" "vpc_cni" {
#  cluster_name = var.eks_cluster_name
#  addon_name = "vpc-cni"
#  service_account_role_arn = var.aws_eks_vpc_cni_role
#  resolve_conflicts_on_update = "OVERWRITE"
#  resolve_conflicts_on_create = "OVERWRITE"
#}