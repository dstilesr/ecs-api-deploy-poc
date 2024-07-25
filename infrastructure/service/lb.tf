
resource "aws_lb" "alb" {
  name                       = "test-lb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.subnet_ids
  security_groups            = [aws_security_group.load_balancer.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_target" {
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "ecs_listen" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target.arn
  }
}
