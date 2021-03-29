terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
  }
  backend "gcs" {
    bucket = "stag-3380426388-terraform-state"
  }
}

locals {
  project = "stag-3380426388"
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

resource "google_pubsub_topic" "app_1" {
  name = "app-1"

  labels = {
    app = "1"
  }
}

resource "google_pubsub_subscription" "app_1" {
  name  = "app-1"
  topic = google_pubsub_topic.app_1.name

  labels = {
    app = "1"
  }

  message_retention_duration = "200s"
  retain_acked_messages      = false

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }

  retry_policy {
    minimum_backoff = "30s"
  }

  enable_message_ordering = false
}

resource "google_service_account" "app_1" {
  account_id   = "app-1"
  display_name = "app-1"
}

resource "google_service_account_key" "app_1" {
  service_account_id = google_service_account.app_1.name
}

resource "google_pubsub_subscription_iam_binding" "" {
  subscription = google_pubsub_subscription.app_1
  role         = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${google_service_account.app_1}",
  ]
}

output "app_1_sa_key" {
  value     = google_service_account_key.app_1.private_key
  sensitive = true
}
