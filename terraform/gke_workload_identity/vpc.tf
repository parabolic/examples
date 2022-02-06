resource "google_compute_network" "this" {
  project = google_project.this.project_id

  name                    = local.name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "cluster" {
  project = google_project.this.project_id

  name   = local.name
  region = local.region

  ip_cidr_range            = "10.1.0.0/20"
  network                  = google_compute_network.this.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${local.name}-services"
    ip_cidr_range = "10.2.0.0/20"
  }

  secondary_ip_range {
    range_name    = "${local.name}-pods"
    ip_cidr_range = "10.3.0.0/20"
  }
}
