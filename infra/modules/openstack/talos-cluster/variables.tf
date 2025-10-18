variable "cluster_name" {
  type = string
}

variable "controlplane_flavor" {
  type        = string
  description = "OpenStack instance flavor name to use for controlplane nodes"
  default     = "m1.medium"
}

variable "install_disk" {
  type        = string
  description = "Root disk for the Talos node"
  default     = "/dev/vda"
}

variable "enable_floating_ip" {
  type    = bool
  default = false
}

variable "extra_volume_count" {
  type        = number
  description = "Number of extra volumes to provision per worker node."
  default     = 0
}

variable "extra_volume_size" {
  type        = number
  description = "Size of each extra volume (in GiB)."
  default     = 5
}

variable "internal_network" {}
variable "internal_subnet" {}
variable "public_network" {}

variable "openstack_auth_url" {
  type        = string
  description = "OpenStack identity endpoint URL"
}

variable "talos_version" {
  type        = string
  description = "Version of Talos Linux to run (image must exist and be properly tagged)."
  default     = null  # Use newest image by date, regardless of version.
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes to provision"
  default     = 2
}

variable "worker_flavor" {
  type        = string
  description = "OpenStack instance flavor name to use for worker nodes"
  default     = "m1.medium"
}
