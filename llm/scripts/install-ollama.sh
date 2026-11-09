#!/bin/bash
set -e

dnf install -y tar gzip shadow-utils zstd

NODE_EXPORTER_VERSION="1.12.1"
curl -fsSL "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz" -o /tmp/node_exporter.tar.gz
echo "b51d8a76aa2a9156a55d501aca6276fae09e262259a5e4e831d2c2222f084e63  /tmp/node_exporter.tar.gz" | sha256sum -c -
tar -xzf /tmp/node_exporter.tar.gz -C /tmp
install -m 755 /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

useradd -r -s /sbin/nologin node_exporter
cat > /etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

curl -fsSL --connect-timeout 10 --retry 5 --retry-delay 5 \
  https://ollama.com/install.sh -o /tmp/install-ollama.sh
sh /tmp/install-ollama.sh

mkdir -p /etc/systemd/system/ollama.service.d
cat > /etc/systemd/system/ollama.service.d/override.conf <<'EOF'
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
EOF

systemctl daemon-reload
systemctl enable --now node_exporter
systemctl enable ollama
systemctl restart ollama

curl -fsS --retry 30 --retry-connrefused --retry-delay 2 \
  http://127.0.0.1:11434/api/tags >/dev/null

HOME=/root ollama pull qwen3:0.6b