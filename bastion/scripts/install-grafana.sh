#!/bin/bash
set -e

install -m 644 /tmp/grafana.repo /etc/yum.repos.d/grafana.repo

dnf install -y grafana

mkdir -p /etc/systemd/system/grafana-server.service.d
mkdir -p /var/lib/grafana/dashboards
