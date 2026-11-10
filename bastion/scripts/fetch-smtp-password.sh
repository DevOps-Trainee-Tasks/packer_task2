#!/bin/bash
set -e

install -m 600 /dev/null /etc/grafana/smtp-password
aws ssm get-parameter \
  --name "$SMTP_PARAMETER_NAME" \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text > /etc/grafana/smtp-password
chown grafana:grafana /etc/grafana/smtp-password