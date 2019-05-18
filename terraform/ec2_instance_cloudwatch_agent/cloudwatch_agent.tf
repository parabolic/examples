module "cloudwatch_agent" {
  source = "git::https://github.com/cloudposse/terraform-aws-cloudwatch-agent?ref=0.2.0"

  name                   = "${module.label.name}"
  namespace              = "${module.label.namespace}"
  aggregation_dimensions = ["AutoScalingGroupName", "InstanceId"]

  disk_resources              = ["/", "/mnt", "/home"]
  metrics_collection_interval = "60"
  metrics_config              = "advanced"

  userdata_part_content = "${data.template_file.cloud-init.rendered}"
}
