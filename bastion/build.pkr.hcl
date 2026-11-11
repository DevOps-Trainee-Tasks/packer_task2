build {
  sources = ["source.amazon-ebs.bastion"]

  provisioner "shell" {
    script = "scripts/install-prometheus.sh"
    environment_vars = [
      "PROMETHEUS_VERSION=${var.prometheus_version}"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "shell" {
    script = "scripts/configure-prometheus.sh"
    environment_vars = [
      "PROMETHEUS_PORT=${var.prometheus_port}",
      "PROMETHEUS_RETENTION_SIZE=${var.prometheus_retention_size}",
      "SCRAPE_INTERVAL=${var.scrape_interval}",
      "NODE_EXPORTER_PORT=${var.node_exporter_port}",
      "LLM_NAME_TAG=${var.llm_name_tag}"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "shell" {
    script = "scripts/install-grafana.sh"
    environment_vars = [
      "AWS_REGION=${var.aws_region}",
      "PROMETHEUS_PORT=${var.prometheus_port}",
      "ALERT_EMAIL=${var.alert_email}",
      "SMTP_HOST=${var.smtp_host}",
      "SMTP_STARTTLS_POLICY=${var.smtp_starttls_policy}",
      "SMTP_PARAMETER_NAME=/${var.project}/grafana/smtp-password"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "file" {
    source      = "scripts/fetch-smtp-password.sh"
    destination = "/tmp/fetch-smtp-password.sh"
  }

  provisioner "file" {
    sources = [
      "grafana/dashboards/cpu.json",
      "grafana/dashboards/memory.json",
      "grafana/dashboards/root-disk.json"
    ]
    destination = "/tmp/"
  }

  provisioner "file" {
    content     = templatefile("grafana/dashboards/alb-4xx.json", { alb_name = "${var.project}-alb" })
    destination = "/tmp/alb-4xx.json"
  }

  provisioner "file" {
    content     = templatefile("grafana/dashboards/alb-5xx.json", { alb_name = "${var.project}-alb" })
    destination = "/tmp/alb-5xx.json"
  }

  provisioner "file" {
    content     = templatefile("grafana/dashboards/response-time.json", { alb_name = "${var.project}-alb" })
    destination = "/tmp/response-time.json"
  }

  provisioner "file" {
    content     = templatefile("grafana/alert-rules.yaml", { alb_name = "${var.project}-alb" })
    destination = "/tmp/alert-rules.yaml"
  }

  provisioner "file" {
    content     = templatefile("grafana/contact-points.yaml", { alert_email = var.alert_email })
    destination = "/tmp/contact-points.yaml"
  }

  provisioner "shell" {
    script          = "scripts/configure-grafana.sh"
    execute_command = "sudo bash '{{ .Path }}'"
  }
}
