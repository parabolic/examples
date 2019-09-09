resource "aws_launch_configuration" "eks_worker" {
  instance_type               = local.instance_type
  name_prefix                 = module.label.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.eks_worker.name
  image_id                    = data.aws_ami.eks_worker.id
  security_groups = [
    aws_security_group.eks_workers.id
  ]
  user_data_base64 = base64encode(data.template_file.eks_worker.rendered)
  key_name         = local.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks_worker" {
  launch_configuration = "${aws_launch_configuration.eks_worker.id}"
  max_size             = local.max_size
  min_size             = local.min_size
  name                 = module.label.id
  vpc_zone_identifier  = module.vpc.public_subnets
  tags                 = module.label_owned.tags_as_list_of_maps
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${module.label.id}-scaleOut"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.eks_worker.name}"
}


resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${module.label.id}-scaleIn"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.eks_worker.name}"
}
