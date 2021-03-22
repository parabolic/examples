terraform {
  required_version = "0.14.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
  }
}
