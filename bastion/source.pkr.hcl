source "amazon-ebs" "bastion" {
  region                                    = var.aws_region
  source_ami                                = var.source_ami
  instance_type                             = var.instance_type
  ssh_username                              = var.ssh_username
  ami_name                                  = "${var.project}-bastion-{{timestamp}}"
  temporary_security_group_source_public_ip = true

  tags = {
    Name      = "${var.project}-bastion-ami"
    Project   = var.project
    Role      = "bastion"
    ManagedBy = "Packer"
  }
}