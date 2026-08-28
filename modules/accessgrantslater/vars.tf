variable "eks_admin_user_arns" {
  type    = list(string)
  default = ["arn:aws:iam::1234567890:root"]
}
variable "eks_cluster_name" {
  type = string
}
variable "eks_cluster_oidc_issuer_url" {
  type = string
}
variable "env" {
  type = string
}
variable "name" {
  type = string
}
variable "eks_node_role_name" {
  type = string
}