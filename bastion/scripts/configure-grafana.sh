#!/bin/bash
set -e

install -m 644 /tmp/grafana-prometheus.yml /etc/grafana/provisioning/datasources/prometheus.yml
install -m 644 /tmp/grafana-cloudwatch.yml /etc/grafana/provisioning/datasources/cloudwatch.yml
install -m 644 /tmp/grafana-monitoring.yml /etc/grafana/provisioning/dashboards/monitoring.yml
install -m 644 /tmp/grafana.ini /etc/grafana/grafana.ini
install -m 644 /tmp/grafana-smtp-password.service /etc/systemd/system/grafana-smtp-password.service
install -m 644 /tmp/grafana-smtp.conf /etc/systemd/system/grafana-server.service.d/smtp.conf

install -m 644 /tmp/cpu.json /var/lib/grafana/dashboards/cpu.json
install -m 644 /tmp/memory.json /var/lib/grafana/dashboards/memory.json
install -m 644 /tmp/root-disk.json /var/lib/grafana/dashboards/root-disk.json
install -m 644 /tmp/alb-4xx.json /var/lib/grafana/dashboards/alb-4xx.json
install -m 644 /tmp/alb-5xx.json /var/lib/grafana/dashboards/alb-5xx.json
install -m 644 /tmp/response-time.json /var/lib/grafana/dashboards/response-time.json
install -m 644 /tmp/alert-rules.yaml /etc/grafana/provisioning/alerting/alert-rules.yaml
install -m 644 /tmp/contact-points.yaml /etc/grafana/provisioning/alerting/contact-points.yaml
install /tmp/fetch-smtp-password.sh /usr/local/bin/fetch-smtp-password.sh

systemctl enable prometheus grafana-server
