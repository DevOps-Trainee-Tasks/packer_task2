#!/bin/bash
set -e

dnf install -y zstd

curl -fsSL https://ollama.com/install.sh -o /tmp/install-ollama.sh
sh /tmp/install-ollama.sh

mkdir -p /etc/systemd/system/ollama.service.d
cat > /etc/systemd/system/ollama.service.d/override.conf <<EOF
[Service]
Environment="OLLAMA_HOST=0.0.0.0:$OLLAMA_PORT"
EOF

systemctl daemon-reload
systemctl restart ollama

curl -fsS --retry 30 --retry-connrefused --retry-delay 2 \
  http://127.0.0.1:$OLLAMA_PORT/api/tags >/dev/null

HOME=/root ollama pull "$OLLAMA_MODEL"