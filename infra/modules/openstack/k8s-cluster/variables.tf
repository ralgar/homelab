variable "image" {}
variable "keypair" {}
variable "internal_network" {}
variable "internal_subnet" {}
variable "external_network" {}

variable "ha_control_plane" {
  type    = bool
  default = false
}

variable "base_worker_count" {
  type    = number
  default = 1
}

variable "bootstrap" {
  description = "Toggles whether to bootstrap the cluster using Flux v2."
  type        = object({
    enabled    = bool
    repository = string
    ref_name   = string
    path       = string
    configs    = map(string)
    secrets    = map(string)
  })
  default     = {
    enabled     = false
    repository  = null
    ref_name    = null
    path        = null
    configs     = {}
    secrets     = {}
  }
}
