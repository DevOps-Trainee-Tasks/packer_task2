#!/bin/bash
set -e

curl -fsSL "https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz" -o /tmp/prometheus.tar.gz
tar -xzf /tmp/prometheus.tar.gz -C /tmp
install "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus" /usr/local/bin/

useradd -r -s /sbin/nologin prometheus
mkdir -p /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

cat > /etc/prometheus/prometheus.yml <<EOF
global:
  scrape_interval: $SCRAPE_INTERVAL

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:$PROMETHEUS_PORT"]

  - job_name: llm-node
    ec2_sd_configs:
      - port: $NODE_EXPORTER_PORT
        filters:
          - name: tag:Name
            values: [$LLM_NAME_TAG]
          - name: instance-state-name
            values: [running]
EOF

cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --storage.tsdb.retention.size=$PROMETHEUS_RETENTION_SIZE --web.listen-address=0.0.0.0:$PROMETHEUS_PORT
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF