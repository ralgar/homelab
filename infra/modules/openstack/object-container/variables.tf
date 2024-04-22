variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "../../../metal/output/clouds.yaml"
}

variable "name" {
  description = "Unique name to assign to the bucket"
  type        = string
  default     = "tf-test-bucket"
}

variable "environment" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "dev"
}
