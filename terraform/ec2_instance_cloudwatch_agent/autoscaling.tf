resource "aws_autoscaling_group" "web" {
  name                 = "${module.label.id}"
  vpc_zone_identifier  = ["${module.dynamic_subnets.public_subnet_ids}"]
  availability_zones   = "${local.availability_zones}"
  launch_configuration = "${aws_launch_configuration.web.name}"
  min_size             = "${local.autoscaling["min_size"]}"
  max_size             = "${local.autoscaling["max_size"]}"
  health_check_type    = "${local.autoscaling["health_check_type"]}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${module.label.id}"
    propagate_at_launch = true
  }

  tag {
    key                 = "stage"
    value               = "${module.label.stage}"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "web" {
  security_groups      = ["${aws_security_group.ec2.id}"]
  name_prefix          = "${module.label.id}-"
  iam_instance_profile = "${aws_iam_instance_profile.cloudwatch_agent.name}"
  image_id             = "${data.aws_ami.ubuntu.id}"
  instance_type        = "${local.instance_type}"
  user_data            = "${module.cloudwatch_agent.user_data}"
  key_name             = "${local.key_name}"

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
