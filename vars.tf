variable "aws_region" {
  type    = string
  default = "ap-south-2"
}
variable "profile" {
  type    = string
  default = "default"
}
variable "eks_admin_user_arns" {
  type    = list(string)
  default = ["arn:aws:iam::207791567608:root"]
}
variable "env" {
  type    = string
  default = "test"
}
variable "name" {
  type    = string
  default = "run"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "dns_hostname" {
  type    = bool
  default = true
}
variable "dns_support" {
  type    = bool
  default = true
}
variable "zones_public" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_ip" {
  type    = list(bool)
  default = [true, false]
}
variable "zones_private" {
  type    = list(string)
  default = ["ap-south-2b", "ap-south-2c"]
}
variable "private_subnets" {
  type    = list(string)
  default = ["10.0.100.0/24", "10.0.101.0/24"]
}
variable "cluster_version" {
  type    = string
  default = "1.34"
}
variable "node_ami_type" {
  type    = string
  default = "AL2023_ARM_64_STANDARD"
}
variable "node_instance_types" {
  type    = list(string)
  default = ["t4g.small"]
}
variable "node_min_size" {
  type    = number
  default = 0
}
variable "node_max_size" {
  type    = number
  default = 2
}
variable "node_desired_size" {
  type    = number
  default = 0
}
variable "node_max_unavailable" {
  type    = number
  default = 1
}
variable "domain" {
  type    = string
  default = "xyz.com"
}