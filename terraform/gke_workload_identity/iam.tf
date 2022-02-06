resource "google_service_account" "k8s" {
  project = google_project.this.project_id

  account_id = "${local.name}-k8s"
}

resource "google_project_iam_member" "this" {
  project = google_project.this.project_id

  role   = "roles/pubsub.admin"
  member = "serviceAccount:${google_service_account.k8s.email}"
}

# The creation of the binding was failing due to the nodes not being found.
# This 5 seconds sleeps fixes the issue.
resource "time_sleep" "wait_5_seconds" {
  depends_on = [google_container_node_pool.this]

  create_duration = "5s"
}

resource "google_service_account_iam_binding" "k8s" {
  depends_on = [time_sleep.wait_5_seconds]

  service_account_id = google_service_account.k8s.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${google_project.this.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account}]",
  ]
}
