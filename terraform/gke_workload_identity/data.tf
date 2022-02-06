data "google_compute_zones" "available" {
  region  = local.region
  project = google_project.this.project_id
}
