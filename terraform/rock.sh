#!/usr/bin/env bash

cat <<EOF > /etc/systemd-cloud-watch.conf
log_group = "rock"
EOF

systemctl daemon-reload
systemctl start systemd-cloud-watch
