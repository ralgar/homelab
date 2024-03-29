variable "repository" { type = string }
variable "ref_name" { type = string }
variable "path" { type = string }

variable "configs" {
  description = "Map of config key/value pairs for GitOps variable substitution."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Map of secret key/value pairs for GitOps variable substitution."
  type        = map(string)
  default     = {}
}
