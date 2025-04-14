variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
}

variable "deployment" {
  description = "Name of the deployment. Should correspond to the name of the current directory."
  type = string
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
}
