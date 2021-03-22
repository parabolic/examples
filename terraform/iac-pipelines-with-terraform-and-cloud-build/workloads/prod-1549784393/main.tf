terraform {
  required_version = "0.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
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

resource "google_pubsub_topic" "production" {
  name = "production-topic"
}
