build {
  sources = ["source.amazon-ebs.llm"]

  provisioner "shell" {
    script = "scripts/install-node-exporter.sh"
    environment_vars = [
      "NODE_EXPORTER_VERSION=${var.node_exporter_version}",
      "NODE_EXPORTER_SHA256=${var.node_exporter_sha256}"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }

  provisioner "shell" {
    script = "scripts/install-ollama.sh"
    environment_vars = [
      "OLLAMA_PORT=${var.ollama_port}",
      "OLLAMA_MODEL=${var.ollama_model}"
    ]
    execute_command = "sudo env {{ .Vars }} bash '{{ .Path }}'"
  }
}
