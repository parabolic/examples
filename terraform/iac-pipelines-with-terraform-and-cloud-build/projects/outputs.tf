output "cloudbuild_service_account_email" {
  value = google_project_service_identity.cloudbuild.email
}
