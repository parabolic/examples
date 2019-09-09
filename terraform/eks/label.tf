module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.15.0"
  stage     = local.stage
  name      = local.name
  namespace = local.region
  delimiter = "-"
  tags = {
    "kubernetes.io/cluster/${module.label.id}" = "owned"
  }
  additional_tag_map = {
    propagate_at_launch = "true"
  }
}

module "label_owned" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.15.0"
  stage     = local.stage
  name      = local.name
  namespace = local.region
  delimiter = "-"
  tags = {
    "kubernetes.io/cluster/${module.label_owned.id}" = "owned"
  }
  additional_tag_map = {
    propagate_at_launch = "true"
  }
}

module "label_shared" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.15.0"
  stage     = local.stage
  name      = local.name
  namespace = local.region
  delimiter = "-"
  tags = {
    "kubernetes.io/cluster/${module.label_shared.id}" = "shared"
  }
  additional_tag_map = {
    propagate_at_launch = "true"
  }
}
