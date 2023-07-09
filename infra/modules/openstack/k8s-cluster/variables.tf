variable "image" {}
variable "keypair" {}
variable "internal_network" {}
variable "internal_subnet" {}
variable "external_network" {}

variable "bootstrap" {
  description = "Toggles whether to bootstrap the cluster using Flux v2."
  type        = object({
    enabled    = bool
    repository = string
    branch     = string
    path       = string
  })
  default     = {
    enabled     = false
    repository  = null
    branch      = null
    path        = null
  }
}
