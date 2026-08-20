
##################################for only giving access to the root
#resource "aws_eks_access_entry" "root_user_access" {
#  cluster_name  = aws_eks_cluster.eks.name
#  principal_arn = "arn:aws:iam::1234567890:root" 
#  type          = "STANDARD"
#}

# 2. Grant Cluster Admin permissions inside Kubernetes
#resource "aws_eks_access_policy_association" "root_user_policy" {
#  cluster_name  = aws_eks_cluster.eks.name
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

resource "aws_iam_openid_connect_provider" "eks" {
    client_id_list = ["sts.amazomeaws.com"]
    url = var.eks_cluster_oidc_issuer_url
}