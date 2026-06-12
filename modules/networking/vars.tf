variable "vpc_cidr"{
    type = string
}
variable "dns_hostname"{
    type = bool
}
variable "dns_support"{
    type = bool
}
variable "env"{
    type = string
}
variable "name"{
    type = string
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