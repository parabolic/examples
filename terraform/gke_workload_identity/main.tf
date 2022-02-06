terraform {
  required_version = ">= 1.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

provider "google" {
  region = local.region
}

provider "google-beta" {
  region = local.region
}
