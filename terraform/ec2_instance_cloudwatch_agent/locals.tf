locals {
  region             = "eu-west-1"
  availability_zones = ["${local.region}a", "${local.region}b", "${local.region}c"]
  cidr_block         = "10.50.0.0/16"
  name               = "example"
  stage              = "test"
  namespace          = "cloudwatch-agent"
  key_name           = ""
  instance_type      = "t2.micro"

  autoscaling {
    health_check_type = "EC2"
    min_size          = 1
    max_size          = 1
  }

  access_ips = [
    "0.0.0.0/0",
  ]
}
