#!/bin/bash
set -e

dnf install -y postgresql16 tar gzip shadow-utils

#prometheus
VERSION="3.14.0"

curl -fsSL "https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz" -o /tmp/prometheus.tar.gz

tar -xzf /tmp/prometheus.tar.gz -C /tmp
install -m 755 /tmp/prometheus-$VERSION.linux-amd64/prometheus /usr/local/bin/

useradd -r -s /sbin/nologin prometheus
mkdir -p /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

cat > /etc/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: llm-node
    ec2_sd_configs:
      - port: 9100
        filters:
          - name: tag:Name
            values: [ollama]
          - name: instance-state-name
            values: [running]
EOF

cat > /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --storage.tsdb.retention.size=2GB --web.listen-address=0.0.0.0:9090
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

#grafana
curl -fsSL https://rpm.grafana.com/gpg.key -o /tmp/grafana-gpg.key
rpm --import /tmp/grafana-gpg.key

cat > /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

dnf install -y grafana

#gt_to_pms
mkdir -p /etc/grafana/provisioning/datasources

cat > /etc/grafana/provisioning/datasources/prometheus.yml <<'EOF'
apiVersion: 1
datasources:
  - name: Prometheus
    uid: PBFA97CFB590B2093
    type: prometheus
    access: proxy
    url: http://127.0.0.1:9090
    isDefault: true
EOF

cat > /etc/grafana/provisioning/datasources/cloudwatch.yml <<'EOF'
apiVersion: 1
datasources:
  - name: CloudWatch
    uid: P034F075C744B399F
    type: cloudwatch
    jsonData:
      authType: default
      defaultRegion: us-east-1
EOF

mkdir -p /etc/grafana/provisioning/dashboards /var/lib/grafana/dashboards

cat > /etc/grafana/provisioning/dashboards/monitoring.yml <<'EOF'
apiVersion: 1
providers:
  - name: Monitoring
    folder: Monitoring
    options:
      path: /var/lib/grafana/dashboards
EOF