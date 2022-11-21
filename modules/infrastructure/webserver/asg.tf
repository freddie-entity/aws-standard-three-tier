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

# Bastion
# resource "aws_launch_template" "bastion" {
#   image_id                    = data.aws_ami.launch_template_ami.id
#   instance_type               = var.ec2_instance_type
#   key_name                    = var.ec2_key_pair_name
#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups = [aws_security_group.bastion.id]
#   }
#   iam_instance_profile    {
#     arn = aws_iam_instance_profile.bastion.arn
#   }

#   user_data = filebase64("${path.module}/scripts/httpd.sh")
# }

# resource "aws_autoscaling_group" "bastion" {
#   name                  = "bastion"
#   vpc_zone_identifier   = var.public_subnets
#   max_size              = var.ec2_max_instance_size
#   min_size              = var.ec2_min_instance_size

#   launch_template {
#     id = aws_launch_template.bastion.id
#     version = aws_launch_template.bastion.latest_version
#   }
#   health_check_type     = "ELB"
#   target_group_arns        = [aws_lb_target_group.bastion.arn]

#   tag {
#     key                 = "Name"
#     propagate_at_launch = true
#     value               = var.tag_production
#   }

#   tag {
#     key                 = "Type"
#     propagate_at_launch = true
#     value               = var.tag_webapp
#   }
# }


# resource "aws_autoscaling_policy" "bastion" {
#   autoscaling_group_name   = aws_autoscaling_group.bastion.name
#   name                     = "bastion"
#   policy_type              = "TargetTrackingScaling"
#   min_adjustment_magnitude = 1

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 80.0
#   }
# }

# Webserver
resource "aws_launch_template" "webserver" {
  image_id                    = data.aws_ami.launch_template_ami.id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_pair_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.webserver.id]
  }
  iam_instance_profile    {
    arn = aws_iam_instance_profile.webserver.arn
  }

  user_data = filebase64("${path.module}/scripts/httpd.sh")
}

resource "aws_autoscaling_group" "webserver" {
  name                  = "webserver"
  vpc_zone_identifier   = var.private_subnets
  max_size              = var.ec2_max_instance_size
  min_size              = var.ec2_min_instance_size

  launch_template {
    id = aws_launch_template.webserver.id
    version = aws_launch_template.webserver.latest_version
  }
  health_check_type     = "ELB"
  target_group_arns        = [aws_lb_target_group.webserver.arn]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.tag_production
  }

  tag {
    key                 = "Type"
    propagate_at_launch = true
    value               = var.tag_webapp
  }
}


resource "aws_autoscaling_policy" "webserver" {
  autoscaling_group_name   = aws_autoscaling_group.webserver.name
  name                     = "webserver"
  policy_type              = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}