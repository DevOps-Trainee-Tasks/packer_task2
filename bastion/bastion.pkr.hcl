packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "bastion" {
  region = "us-east-1"
  source_ami = "ami-07ad3ac74660c86c1"
  instance_type = "m7i-flex.large"
  ssh_username = "ec2-user"
  ami_name = "task2-bastion-{{timestamp}}"
  temporary_security_group_source_public_ip = true
}

build {
  sources = ["source.amazon-ebs.bastion"]

  provisioner "shell" {
    script = "scripts/install-bastion.sh"
    execute_command = "sudo bash '{{ .Path }}'"
  }
}