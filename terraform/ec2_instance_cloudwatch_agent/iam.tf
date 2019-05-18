resource "aws_iam_instance_profile" "cloudwatch_agent" {
  name_prefix = "${module.label.id}-"
  role        = "${module.cloudwatch_agent.role_name}"
}
