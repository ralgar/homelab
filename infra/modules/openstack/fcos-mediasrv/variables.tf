variable "fcos_version" {
  description = "Desired major version of the instance image"
  type        = number
}
variable "domain" {}
variable "keypair" {}
variable "network" {}

variable "ignition_configs" {
  type        = list(any)
  description = "List of ignition configs to apply to the instance."
}

variable "volumes" {
  type        = list(any)
  description = "List of block storage volumes to attach to the instance."
}
