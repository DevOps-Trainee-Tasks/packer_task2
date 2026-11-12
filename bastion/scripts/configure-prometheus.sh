#!/bin/bash
set -e

install -m 644 /tmp/prometheus.yml /etc/prometheus/prometheus.yml
install -m 644 /tmp/prometheus.service /etc/systemd/system/prometheus.service
