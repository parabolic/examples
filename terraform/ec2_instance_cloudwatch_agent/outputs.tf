output "username" {
  value = "${module.label.id}"
}

output "password" {
  value = "${random_id.http_password.hex}"
}
