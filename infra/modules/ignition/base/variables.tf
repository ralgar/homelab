variable "domain" { type = string }
variable "keypair" {}

variable "quadlets" {
  description = "A map of quadlet filenames to a map of optional key/value pairs for template substitution"
  type        = map(map(string))
  default     = {}
}
