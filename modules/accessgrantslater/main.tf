
##################################for only giving access to the root
#resource "aws_eks_access_entry" "root_user_access" {
#  cluster_name  = var.eks_cluster_name
#  principal_arn = "arn:aws:iam::1234567890:root" 
#  type          = "STANDARD"
#}

# 2. Grant Cluster Admin permissions inside Kubernetes
#resource "aws_eks_access_policy_association" "root_user_policy" {
#  cluster_name  = var.eks_cluster_name
#  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#  principal_arn = aws_eks_access_entry.root_user_access.principal_arn

#  access_scope {
#    type = "cluster"
#  }
#}
##################################for only giving access to the root and other users
# 1. Enable access for each ARN in the list
resource "aws_eks_access_entry" "cluster_access" {
  for_each = toset(var.eks_admin_user_arns)

  cluster_name  = var.eks_cluster_name
  principal_arn = each.value
  type          = "STANDARD"
}

# 2. Grant Cluster Admin permissions to each Access Entry
resource "aws_eks_access_policy_association" "cluster_policy" {
  for_each = toset(var.eks_admin_user_arns)

  cluster_name  = var.eks_cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.cluster_access[each.value].principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_iam_openid_connect_provider" "eks" { #creating a trusted oidc provider in aws
    client_id_list = ["sts.amazonaws.com"]
    url = var.eks_cluster_oidc_issuer_url
}

resource "aws_iam_role" "ebs_efs_shared_role" { # creating shared efs ebs storage role
  name  = "${var.env}-${var.name}-ebs-efs-shared-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          # Allows both ebs-csi and efs-csi service accounts
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = ["system:serviceaccount:kube-system:efs-csi-controller-sa","system:serviceaccount:kube-system:ebs-csi-controller-sa"]
        }
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role = aws_iam_role.ebs_efs_shared_role.name
}
resource "aws_iam_role_policy_attachment" "efs_csi_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role = aws_iam_role.ebs_efs_shared_role.name
}

#resource "aws_iam_role" "vpc_cni_role" {
#  name = "${var.env}-${var.name}-vpc-cni-role"

#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect = "Allow"
#      Principal = {
#        Federated = aws_iam_openid_connect_provider.eks.arn
#      }
#      Action = "sts:AssumeRoleWithWebIdentity"
#      Condition = {
#        StringEquals = {
#          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
#          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
#        }
#      }
#    }]
#  })
#}
#resource "aws_iam_role_policy_attachment" "vpc_cni_policy_attachment"{
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role  = aws_iam_role.vpc_cni_role.name
#}