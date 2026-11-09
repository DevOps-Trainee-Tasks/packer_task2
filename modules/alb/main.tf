resource "aws_lb" "alb" {
  name = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  security_groups = [var.security_groups_id]
}

resource "aws_lb_target_group" "lb_target_group" {
  name = "${var.name_prefix}-ollama"
  vpc_id = var.vpc_id
  port = var.ollama_port
  protocol = "HTTP"
  target_type = "instance"
  health_check {
    path = "/api/tags"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.port_listener
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
