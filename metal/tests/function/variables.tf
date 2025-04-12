variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "../output/clouds.yaml"
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
  default     = "admin"
}
