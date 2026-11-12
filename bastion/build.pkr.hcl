build {
  sources = ["source.amazon-ebs.bastion"]

  provisioner "file" {
    content = templatefile("config/prometheus.yml", {
      scrape_interval    = var.scrape_interval
      prometheus_port    = var.prometheus_port
      node_exporter_port = var.node_exporter_port
      llm_name_tag       = var.llm_name_tag
    })
    destination = "/tmp/prometheus.yml"
  }

  provisioner "file" {
    content = templatefile("config/prometheus.service", {
      prometheus_retention_size = var.prometheus_retention_size
      prometheus_port           = var.prometheus_port
    })
    destination = "/tmp/prometheus.service"
  }

  provisioner "file" {
    sources = [
      "config/grafana.repo",
      "config/grafana-monitoring.yml",
      "config/grafana-smtp.conf"
    ]
    destination = "/tmp/"
  }

  provisioner "file" {
    content     = templatefile("config/grafana-prometheus.yml", { prometheus_port = var.prometheus_port })
    destination = "/tmp/grafana-prometheus.yml"
  }

  provisioner "file" {
    content     = templatefile("config/grafana-cloudwatch.yml", { aws_region = var.aws_region })
    destination = "/tmp/grafana-cloudwatch.yml"
  }

  provisioner "file" {
    content = templatefile("config/grafana.ini", {
      smtp_host            = var.smtp_host
      alert_email          = var.alert_email
      smtp_starttls_policy = var.smtp_starttls_policy
    })
    destination = "/tmp/grafana.ini"
  }

  provisioner "file" {
    content = templatefile("config/grafana-smtp-password.service", {
      aws_region          = var.aws_region
      smtp_parameter_name = "/${var.project}/grafana/smtp-password"
    })
    destination = "/tmp/grafana-smtp-password.service"
  }

  provisioner "shell" {
    script = "scripts/install-prometheus.sh"
    environment_vars = [
      "PROMETHEUS_VERSION=${var.prometheus_version}"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "shell" {
    script          = "scripts/configure-prometheus.sh"
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "shell" {
    script          = "scripts/install-grafana.sh"
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
