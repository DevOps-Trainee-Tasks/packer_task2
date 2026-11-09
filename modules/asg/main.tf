resource "aws_launch_template" "launch_template" {
    name_prefix = var.name_prefix
    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = var.security_group_ids
    user_data = var.user_data
}

resource "aws_autoscaling_group" "scaling" {
    name = "${var.name_prefix}-llm-asg"
    vpc_zone_identifier = var.private_subnet_ids
    min_size = 2
    desired_capacity = 2
    max_size = 4
    target_group_arns = [var.target_group_arn]
    health_check_type = "ELB"
    health_check_grace_period = 676
    launch_template {
      id = aws_launch_template.launch_template.id
      version = aws_launch_template.launch_template.latest_version
    }
    tag {
        key = "Name"
        value = "ollama"
        propagate_at_launch = true
}
}

resource "aws_autoscaling_policy" "policy" {
    name = "${var.name_prefix}-cpu-scaling"
    autoscaling_group_name = aws_autoscaling_group.scaling.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 69
    }
}