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

resource "helm_release" "cert_manager" {
  name = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"
  namespace = "cert-manager"
  version = "v1.21.1"
  create_namespace = true

  set {
    name = "installCRDs"
    value = "true"
  }
  
  set {
    name  = "replicaCount"
    value = "1"
  }

  set {
    name  = "webhook.replicaCount"
    value = "1"
  }

  set {
    name  = "cainjector.replicaCount"
    value = "1"
  }

}

resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  namespace = "kube-system"

  set {
    name = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "replicaCount" # ######have reduced the replica set to 1 for budget constraint
      value = "1"
  }

  #set {
  #  name = "serviceAccount.create"
  #  value = "false"
    
  #}

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  depends_on = [helm_release.cert_manager]
}

resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true
  version = "4.15.1"

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  set { # ataching ssl certificated
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = var.ssl_arn # Reference your ACM certificate ARN
  }

  set { # 443 from the Load Balancer
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"
  }

  set { # terminating ssl at nlb
    name  = "controller.service.targetPorts.https"
    value = "http"
  }


  depends_on = [helm_release.aws_load_balancer_controller]
}

resource "helm_release" "argocd" {
  name = "argocd"
  repository= "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argo-cd"
  create_namespace = true
  version = "8.2.6"
 # depends_on = [helm_release.ingress_nginx]
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "global.domain"
    value = "argocd.${var.domain}"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTPS"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/force-ssl-redirect"
    value = "false"
  }
}


resource "helm_release" "argo-rollouts" {
  name = "argo-rollout"
  repository= "https://argoproj.github.io/argo-helm"
  chart = "argo-rollouts"
  namespace = "argo-rollouts"
  create_namespace = true
  version = "2.38.0"
 # depends_on = [helm_release.argocd]
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