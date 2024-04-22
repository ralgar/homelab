variable "name" {
  description = "Unique name to assign to the bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment (prod, staging, dev)"
  type        = string
}
