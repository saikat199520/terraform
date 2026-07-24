variable "aws_region" {
    type = string
    default = "ap-south-2"
}
variable "profile" {
    type = string
    default = "default"
}
variable "env"{
    type = string
}
variable "name"{
    type = string
}
variable "vpc_cidr"{
    type = string
}
variable "dns_hostname"{
    type = bool
}
variable "dns_support"{
    type = bool
}
variable "zones_public"{
    type = list(string)
    default = ["ap-south-1a","ap-south-1b"]
}
variable "public_subnets"{
    type = list(string)
}
variable "public_ip"{
    type = list(bool)
    default = [true,true]
}
variable "zones_private"{
    type = list(string)
    default = ["ap-south-1a","ap-south-1b"]
}
variable "private_subnets"{
    type = list(string)
}
variable "cluster_version" {
    type = string
}
variable "node_ami_type" {
    type = string
}
variable "node_instance_types" {
    type = list(string)
    default = ["t4g.small"]
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