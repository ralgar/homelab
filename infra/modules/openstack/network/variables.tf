variable "external_network" {}
variable "network_name" { type = string }
variable "default_subnet_cidr" { type = string }

variable "tags" {
  description = "List of tags to apply to network resources"
  type        = list(string)
  default     = []
}
