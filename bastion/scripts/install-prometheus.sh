#!/bin/bash
set -e

curl -fsSL "https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz" -o /tmp/prometheus.tar.gz
tar -xzf /tmp/prometheus.tar.gz -C /tmp
install "/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus" /usr/local/bin/

useradd -r -s /sbin/nologin prometheus
mkdir -p /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus