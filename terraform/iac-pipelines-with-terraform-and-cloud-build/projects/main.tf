terraform {
  required_version = ">= 0.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
  }
}
variable "folder_id" {
  type = string
}

variable "billing_account" {
  type = string
}

locals {
  projects = {
    cloud-build-3660853213 = {
      services = [
        "cloudbuild.googleapis.com",
        "iam.googleapis.com",
    ] }
    prod-1549784393 = {
      services = [
        "pubsub.googleapis.com",
        "storage-api.googleapis.com",
        "iam.googleapis.com",
    ] }
    stag-3380426388 = {
      services = [
        "pubsub.googleapis.com",
        "redis.googleapis.com",
        "storage-api.googleapis.com",
        "iam.googleapis.com",
    ] }
  }
}

resource "google_project" "project" {
  for_each = local.projects

  billing_account = var.billing_account
  folder_id       = var.folder_id == "" ? lookup(each.value, "folder_id", null) : var.folder_id
  name            = each.key
  project_id      = lower(replace(each.key, " ", "-"))

  auto_create_network = lookup(each.value, "auto_create_network", false)
  skip_delete         = lookup(each.value, "skip_delete", true)

  # labels = var.labels
}
locals {
  # Creates a map of apis and project { project/api => project }
  project_services = zipmap(
    flatten(
      [for projects_k, projects_v in local.projects :
        [for services_k, services_v in lookup(projects_v, "services", []) :
        "${projects_k}/${services_v}"]
    ]),
    flatten(
      [for projects_k, projects_v in local.projects :
        [for _, _ in lookup(projects_v, "services", []) : projects_k]
    ])
  )
}
resource "google_project_service" "apis" {
  for_each = local.project_services

  project = each.value
  service = replace(each.key, "/.*\\//", "")

  disable_dependent_services = true
}

# If there is no repository connected the following blocks will throw an error.
# Error: Error creating Trigger: googleapi: Error 400: Repository mapping does not exist. Please visit https://console.cloud.google.com/
# This should be uncommented only when the repository is added manually "click-opsed" in the console.
# Currently there's no way to connect a repo via the api.

# resource "google_cloudbuild_trigger" "pull_request_merge" {
#   project     = "cloud-build-3660853213"
#   name        = "pull-request-merge"
#   description = <<EOF
#   Trigger for Cloud Build when a pull request is created.
#   EOF

#   github {
#     name  = "examples"
#     owner = "parabolic"

#     pull_request {
#       branch          = "^master$"
#       comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
#       invert_regex    = true
#     }
#   }

#   filename   = "cloudbuild.yaml" # Root of the repository
#   depends_on = [google_project_service.apis]
# }

resource "google_cloudbuild_trigger" "pull_request_push" {
  project     = "cloud-build-3660853213"
  name        = "pull-request-push"
  description = <<EOF
  Trigger for Cloud Build when a pull request is merged into master.
  EOF

  ignored_files  = ["**"]
  included_files = ["*.tf"]

  github {
    name  = "examples"
    owner = "parabolic"

    pull_request {
      branch          = "^master$"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }

  filename   = "cloudbuild.yaml" # Root of the repository
  depends_on = [google_project_service.apis]
}
