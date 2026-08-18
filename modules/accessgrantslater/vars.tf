variable "eks_admin_user_arns"{
    type = list(string)
    default     = ["arn:aws:iam::1234567890:root"]
}
variable "eks_cluster_name" {
    type = string
}