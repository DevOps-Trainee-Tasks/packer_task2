source "amazon-ebs" "llm" {
  region                                    = var.aws_region
  source_ami                                = var.source_ami
  instance_type                             = var.instance_type
  ssh_username                              = var.ssh_username
  ami_name                                  = "${var.project}-llm-{{timestamp}}"
  temporary_security_group_source_public_ip = true

  tags = {
    Name      = "${var.project}-llm-ami"
    Project   = var.project
    Role      = "llm"
    ManagedBy = "Packer"
  }
}
