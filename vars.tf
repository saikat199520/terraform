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
  description = "Production Environment"
}