module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.4.1"
  namespace  = "${module.label.namespace}"
  stage      = "${module.label.stage}"
  name       = "${module.label.name}"
  cidr_block = "${local.cidr_block}"
}

module "dynamic_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=0.8.0"
  namespace          = "${module.label.namespace}"
  stage              = "${module.label.stage}"
  name               = "${module.label.name}"
  region             = "${local.region}"
  availability_zones = "${local.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  igw_id             = "${module.vpc.igw_id}"
  cidr_block         = "${local.cidr_block}"
}
