resource "aws_lb" "main" {
  name            = "${var.tier}"
  internal        = var.lb_internal
  load_balancer_type = "application"
  security_groups = [aws_security_group.main.id]
  subnets         = var.public_subnets
}

resource "aws_lb_target_group" "main" {
  name        = "${var.tier}-${random_string.target_group.result}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true # prevent from deleting target group without replacement while it's being listen by listener
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

