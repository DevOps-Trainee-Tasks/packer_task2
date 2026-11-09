resource "aws_security_group" "security_groups" {
  for_each = var.security_groups

  name = each.key
  vpc_id = var.main_vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = {
    for r in flatten([
      for name, rule in var.ingress_rules : [
        for port in rule.ports : merge(rule, {
          key = "${name}:${port}"
          port = port
        })
      ]
    ]) : r.key => r
  }

  security_group_id = aws_security_group.security_groups[each.value.target_group].id
  ip_protocol = each.value.protocol
  from_port = each.value.port
  to_port = each.value.port
  cidr_ipv4 = each.value.cidr_ipv4
  referenced_security_group_id = each.value.source_group == null ? null : aws_security_group.security_groups[each.value.source_group].id
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = {
    for group_name, group in var.security_groups :
    group_name => group
    if group.allow_all_egress
  }

  security_group_id = aws_security_group.security_groups[each.key].id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}