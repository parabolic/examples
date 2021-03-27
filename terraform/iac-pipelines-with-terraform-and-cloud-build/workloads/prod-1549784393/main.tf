terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
  }

  backend "gcs" {
    bucket = "prod-1549784393-terraform-state"
  }
}

locals {
  project = "prod-1549784393"
  region  = "eu-west4"
}

provider "google" {
  project = local.project
  region  = local.region
}

resource "google_storage_bucket" "terraform_state" {
  name    = "${local.project}-terraform-state"
  project = local.project

  force_destroy               = false
  location                    = "EU"
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
