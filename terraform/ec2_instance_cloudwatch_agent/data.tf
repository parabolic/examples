data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  owners = [
    "099720109477",
  ]
}

data "template_file" "cloud-init" {
  template = "${file("${path.module}/templates/cloud_init.yaml")}"

  vars {
    username = "${module.label.id}"
    password = "${random_id.http_password.hex}"
  }
}
