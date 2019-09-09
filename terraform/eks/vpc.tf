module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.9.0"

  name = module.label.id
  cidr = local.vpc_cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = local.private_subnets_cidrs
  public_subnets  = local.public_subnets_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = module.label_shared.tags
}
