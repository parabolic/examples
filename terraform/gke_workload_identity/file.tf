locals {
  k8s_script_path = var.k8s_script_path == "./" ? "${path.module}/k8s.sh" : "${var.k8s_script_path}/k8s.sh"
}

resource "local_file" "k8s" {
  filename = local.k8s_script_path

  content = templatefile("src/k8s.sh.tftpl",
    {
      k8s_namespace       = var.k8s_namespace
      k8s_service_account = var.k8s_service_account
      gcp_region          = local.region
      cluster_name        = google_container_cluster.primary.name
      gcp_project_id      = google_project.this.project_id
      k8s_context         = "gke_${google_project.this.project_id}_${local.region}_${google_container_cluster.primary.name}"
      gcp_service_account = "cloudlad-${random_pet.name.id}-k8s@${google_project.this.project_id}.iam.gserviceaccount.com"
    }
  )
}
