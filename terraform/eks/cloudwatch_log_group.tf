resource "aws_cloudwatch_log_group" "cloudlad" {
  name              = "/aws/eks/${module.label.id}/cluster"
  retention_in_days = 7
}
