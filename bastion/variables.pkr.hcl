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

variable "prometheus_version" {
  default = "3.14.0"
}

variable "prometheus_port" {
  default = 9090
}

variable "prometheus_retention_size" {
  default = "2GB"
}

variable "scrape_interval" {
  default = "15s"
}

variable "node_exporter_port" {
  default = 9100
}

variable "llm_name_tag" {
  default = "ollama"
}

variable "alert_email" {
}

variable "smtp_host" {
  default = "smtp.gmail.com:587"
}

variable "smtp_starttls_policy" {
  default = "MandatoryStartTLS"
}