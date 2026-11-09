output "security_group_ids" {
  value = {
    for group_name, group in aws_security_group.security_groups :
    group_name => group.id
  }
}
