data "aws_ami" "launch_template_ami" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_launch_template" "main" {
  name = "${var.tier}"
  image_id                    = data.aws_ami.launch_template_ami.id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_pair_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups = var.security_group_ids
  }
  iam_instance_profile    {
    arn = aws_iam_instance_profile.main.arn
  }

  user_data = filebase64("${path.module}/scripts/httpd.sh")
}

resource "aws_autoscaling_group" "main" {
  name                  = "${var.tier}"
  vpc_zone_identifier   = var.application_subnets
  max_size              = var.ec2_max_instance_size
  min_size              = var.ec2_min_instance_size

  launch_template {
    id = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }
  health_check_type     = "ELB"
  target_group_arns        = [aws_lb_target_group.main.arn]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.tier
  }
}


resource "aws_autoscaling_policy" "main" {
  autoscaling_group_name   = aws_autoscaling_group.main.name
  name                     = "${var.tier}"
  policy_type              = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}