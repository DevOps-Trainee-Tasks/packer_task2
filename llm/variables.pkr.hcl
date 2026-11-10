variable "aws_region" {
  default = "us-east-1"
}

variable "source_ami" {
  default = "ami-07ad3ac74660c86c1"
}

variable "instance_type" {
  default = "m7i-flex.large"
}

variable "ssh_username" {
  default = "ec2-user"
}

variable "project" {
  default = "task2"
}

variable "node_exporter_version" {
  default = "1.12.1"
}

variable "node_exporter_sha256" {
  default = "b51d8a76aa2a9156a55d501aca6276fae09e262259a5e4e831d2c2222f084e63"
}

variable "ollama_port" {
  default = 11434
}

variable "ollama_model" {
  default = "qwen3:0.6b"
}