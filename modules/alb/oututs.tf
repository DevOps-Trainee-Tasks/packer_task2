output "target_group_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}

output "alb_dns" {
    value = aws_lb.alb.dns_name
}