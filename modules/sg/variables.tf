variable "main_vpc_id" {
  type = string
}

variable "security_groups" {
  type = map(object({
    allow_all_egress = optional(bool, false)
  }))
}

variable "ingress_rules" {
  type = map(object({
    target_group = string
    ports = set(number)
    protocol = optional(string, "tcp")
    cidr_ipv4 = optional(string)
    source_group = optional(string)
  }))
}