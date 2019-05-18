module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.7.0"
  namespace = "${local.namespace}"
  stage     = "${local.stage}"
  name      = "${local.name}"
}
