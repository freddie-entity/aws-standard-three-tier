# Bastion
# resource "aws_lb" "bastion" {
#   name            = "bastion"
#   internal        = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.bastion.id]
#   subnets         = var.public_subnets
# }

# resource "aws_lb_target_group" "bastion" {
#   name        = "bastion-${random_string.target_group.result}"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"

#   lifecycle {
#     create_before_destroy = true # prevent from deleting target group without replacement while it's being listen by listener
#   }
# }

# resource "aws_lb_listener" "bastion_http" {
#   load_balancer_arn = aws_lb.bastion.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.bastion.arn
#   }
# }

# Webserver
resource "aws_lb" "webserver" {
  name            = "webserver"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets         = var.public_subnets
}

resource "aws_lb_target_group" "webserver" {
  name        = "webserver-${random_string.target_group.result}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true # prevent from deleting target group without replacement while it's being listen by listener
  }
}

resource "aws_lb_listener" "webserver_http" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}
