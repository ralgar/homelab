terraform {
  required_version = ">= 1.0"
  required_providers {
    google = { source  = "hashicorp/google", version = "5.5.0" }
    random = { source  = "hashicorp/random", version = "3.5.1" }
  }
}
