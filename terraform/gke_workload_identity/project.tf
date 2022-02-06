locals {
  project = {
    name        = "workload-identity-${random_pet.name.id}"
    skip_delete = false # Do not use for production workloads.
    services = [
      "container.googleapis.com",
      "iam.googleapis.com",
      "sql-component.googleapis.com",
      "sqladmin.googleapis.com"
    ]
  }
}

resource "google_project" "this" {
  billing_account = var.billing_account
  folder_id       = var.folder_id == "" ? try(local.project.folder_id, null) : var.folder_id
  name            = local.project.name
  project_id      = lower(replace(local.project.name, " ", "-"))

  auto_create_network = try(local.project.auto_create_network, false)
  skip_delete         = try(local.project.skip_delete, true)
}

resource "google_project_service" "this" {
  for_each   = toset(local.project.services)
  depends_on = [google_project.this]

  project = local.project.name
  service = each.value

  disable_dependent_services = true

}
