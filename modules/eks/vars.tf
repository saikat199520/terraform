
variable "env"{
    type = string
}
variable "name"{
    type = string
}
variable "cluster_version" {
    type = string
}
variable "private_subnet_ids" {
    type = list(string)
}
variable "eks_cluster_sg_id" {
    type = string
}
variable "eks_nodes_sg_id" {
    type = string
}
variable "node_ami_id" {
    type = string
}
variable "eks_cluster_role_arn" {
    type = string
}
variable "eks_node_role_arn" {
    type = string
}
variable "node_instance_types" {
    type = list(string)
}
variable "node_min_size" {
    type = number
}
variable "node_max_size" {
    type = number
}
variable "node_desired_size" {
    type = number
}