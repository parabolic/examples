resource "aws_security_group" "ec2" {
  description = "Security group for the instances."
  vpc_id      = "${module.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_allow_web_from_ips" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = "${local.access_ips}"

  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "ingress_allow_ssh_from_ips" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = "${local.access_ips}"

  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "ingress_allow_ping_from_everywhere" {
  type      = "ingress"
  from_port = "-1"
  to_port   = "-1"
  protocol  = "icmp"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "egress_allow_all" {
  type      = "egress"
  from_port = "-1"
  to_port   = "-1"
  protocol  = "-1"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  security_group_id = "${aws_security_group.ec2.id}"
}
