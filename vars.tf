variable "k8s-ver" {
  default     = "1.30"
  description = "K8s Version"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "Region"
}
variable "pick" {
  type = string
  default = "test"
}

variable "env-in" {
  type        = string
  default     = "prod"
  description = "Environment"
}

variable "env" {
  type        = string
  default     = "${var.pick}-${var.env-in}"
  description = "infra Environment"
}

variable "vpc-cidr" {
  type        = string
  default     = "10.20.0.0/16"
  description = "VPC cidr"
}

variable "pub-sub-1-cidr" {
  type        = string
  default     = "10.20.0.0/20"
  description = "subnet cidr"
}

variable "pub-sub-2-cidr" {
  type        = string
  default     = "10.20.16.0/20"
  description = "subnet cidr"
}

variable "pri-sub-1-cidr" {
  type        = string
  default     = "10.20.32.0/20"
  description = "subnet cidr"
}

variable "pri-sub-2-cidr" {
  type        = string
  default     = "10.20.64.0/20"
  description = "subnet cidr"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "ami_type"
}

variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "capacity_type"
}

variable "disk_size" {
  type        = string
  default     = "50"
  description = "disk_size"
}

variable "force_update_version" {
  type        = string
  default     = "false"
  description = "force_update_version"
}

variable "instance_types" {
  type        = string
  default     = "t3a.large"
  description = "instance_types"
}