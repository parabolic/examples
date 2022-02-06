locals {
  default_node_pool_config = {
    node_count   = 1
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    management = {
      auto_repair = true,
    auto_upgrade = false }
    node_config = {
      machine_type             = "e2-medium"
      spot                     = false
      oauth_scopes             = ["https://www.googleapis.com/auth/cloud-platform"]
      workload_metadata_config = "UNSPECIFIED"
    }
  }
  node_pools = {
    1 = {
      node_count = 1
      management = {
        auto_repair  = true,
        auto_upgrade = true
      }
      node_config = {
        spot                     = true
        machine_type             = "e2-medium"
        oauth_scopes             = ["https://www.googleapis.com/auth/cloud-platform"]
        workload_metadata_config = "GKE_METADATA"
      }
    }
  }
}

resource "google_service_account" "this" {
  project = google_project.this.project_id

  depends_on = [google_project.this]

  account_id   = local.name
  display_name = local.name
}

resource "google_container_cluster" "primary" {
  project = google_project.this.project_id

  name     = local.name
  location = local.region

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.32/28"
  }

  network         = google_compute_network.this.id
  subnetwork      = local.name
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "${local.name}-pods"
    services_secondary_range_name = "${local.name}-services"
  }

  workload_identity_config {
    workload_pool = "${google_project.this.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "this" {
  for_each = local.node_pools

  provider = google-beta

  project = google_project.this.project_id

  name       = "${local.name}-${each.key}"
  cluster    = google_container_cluster.primary.id
  node_count = try(each.value.node_count, local.default_node_pool_config.node_count)

  management {
    auto_repair  = try(each.value.management.auto_repair, local.default_node_pool_config.management.machine_type)
    auto_upgrade = try(each.value.management.auto_upgrade, local.default_node_pool_config.management.auto_upgrade)
  }

  node_config {
    spot            = try(each.value.node_config.spot, local.default_node_pool_config.node_config.spot)
    machine_type    = try(each.value.node_config.machine_type, local.default_node_pool_config.node_config.machine_type)
    oauth_scopes    = try(each.value.node_config.oauth_scopes, local.default_node_pool_config.node_config.oauth_scopes)
    service_account = google_service_account.this.email

    workload_metadata_config {
      mode = try(each.value.node_config.workload_metadata_config, local.default_node_pool_config.node_config.workload_metadata_config)
    }
  }
}
