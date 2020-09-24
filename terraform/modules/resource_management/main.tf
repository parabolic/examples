resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = var.folder_parent
}

resource "google_project" "project" {
  for_each = var.projects

  billing_account = var.billing_account

  name       = each.key
  project_id = lower(replace(each.key, " ", "-"))
  folder_id  = google_folder.folder.id

  auto_create_network = lookup(each.value, "auto_create_network", false)
  skip_delete         = lookup(each.value, "skip_delete", true)
}

locals {
  # Creates a map of apis and project { project/api => project }
  services = zipmap(
    flatten(
      [
        for projects_k, projects_v in var.projects :
        [
          for services_k, services_v in lookup(projects_v, "services", []) : "${projects_k}/${services_v}"
        ]
      ]
    ),
    flatten(
      [
        for projects_k, projects_v in var.projects :
        [
          for _, _ in lookup(projects_v, "services", []) : projects_k
        ]
      ]
    )
  )
}

resource "google_project_service" "services" {
  for_each   = local.services
  project    = each.value
  service    = replace(each.key, "/.*\\//", "")
  depends_on = [google_project.project]
}
