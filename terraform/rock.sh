#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# CodeDeploy

systemctl start codedeploy-agent

# -----------------------------------------------------------------------------
# JouralD -> CloudWatch

cat <<EOF > /etc/systemd-cloud-watch.conf
log_group = "rock"
EOF

# Looks like there's a but that results in a lot of log output from this library.
#
# Fix is in this PR: https://github.com/advantageous/systemd-cloud-watch/pull/16
# systemctl start systemd-cloud-watch

# Fortunately there's an alternative bash script
systemctl start journald-cloud-watch-script
