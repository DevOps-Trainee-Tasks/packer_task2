#!/bin/bash
set -e

cat > /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
baseurl=https://rpm.grafana.com
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

dnf install -y grafana

mkdir -p /etc/systemd/system/grafana-server.service.d
mkdir -p /var/lib/grafana/dashboards

cat > /etc/grafana/provisioning/datasources/prometheus.yml <<EOF
apiVersion: 1
datasources:
  - name: Prometheus
    uid: PBFA97CFB590B2093
    type: prometheus
    access: proxy
    url: http://127.0.0.1:$PROMETHEUS_PORT
    isDefault: true
EOF

cat > /etc/grafana/provisioning/datasources/cloudwatch.yml <<EOF
apiVersion: 1
datasources:
  - name: CloudWatch
    uid: P034F075C744B399F
    type: cloudwatch
    jsonData:
      authType: default
      defaultRegion: $AWS_REGION
EOF

cat > /etc/grafana/provisioning/dashboards/monitoring.yml <<'EOF'
apiVersion: 1
providers:
  - name: Monitoring
    folder: Monitoring
    options:
      path: /var/lib/grafana/dashboards
EOF

cat > /etc/grafana/grafana.ini <<EOF
[smtp]
enabled=true
host=$SMTP_HOST
user=$ALERT_EMAIL
password=\$__file{/etc/grafana/smtp-password}
from_address=$ALERT_EMAIL
startTLS_policy=$SMTP_STARTTLS_POLICY
EOF

cat > /etc/systemd/system/grafana-smtp-password.service <<EOF
[Unit]
Description=Load Grafana SMTP password from SSM
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
Environment="AWS_REGION=$AWS_REGION"
Environment="SMTP_PARAMETER_NAME=$SMTP_PARAMETER_NAME"
ExecStart=/usr/local/bin/fetch-smtp-password.sh
EOF

cat > /etc/systemd/system/grafana-server.service.d/smtp.conf <<'EOF'
[Unit]
Requires=grafana-smtp-password.service
After=grafana-smtp-password.service
EOF
