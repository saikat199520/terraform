variable "env" {
  type        = string
  default     = "ShowPilot-prod"
  description = "Production Environment"
}

variable "k8s-ver" {
  default     = "1.30"
  description = "K8s Version"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "Prod Region Ohio"
}
