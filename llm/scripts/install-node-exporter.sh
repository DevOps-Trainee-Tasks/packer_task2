#!/bin/bash
set -e

curl -fsSL "https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz" -o /tmp/node_exporter.tar.gz
echo "$NODE_EXPORTER_SHA256  /tmp/node_exporter.tar.gz" | sha256sum -c -
tar -xzf /tmp/node_exporter.tar.gz -C /tmp
install "/tmp/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter" /usr/local/bin/

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

systemctl enable node_exporter