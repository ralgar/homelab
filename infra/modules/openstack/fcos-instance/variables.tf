variable "fcos_version" {
  description = "Desired major version of the instance image"
  type        = number
}
variable "domain" {}
variable "keypair" {}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "name" {
  type        = string
  description = "Name to assign to the instance."
}

variable "flavor_name" {
  type        = string
  description = "Which flavor to use for the instance."
}

variable "container_storage_size" {
  type        = number
  description = "Storage to allocate (in GB) for Podman images and volumes."
  default     = 20
}

variable "secgroup_ids" {
  type        = list(string)
  description = "List of security group IDs to apply to the instance."
  default     = []
}

variable "quadlets" {
  description = "A map of quadlet filenames to a map of optional key/value pairs for template substitution"
  type        = map(map(string))
  default     = {}
}

variable "ignition_configs" {
  type        = list(any)
  description = "List of ignition configs to apply to the instance."
  default     = []
}

variable "volumes" {
  type        = list(any)
  description = "List of block storage volumes to attach to the instance."
  default     = []
}
