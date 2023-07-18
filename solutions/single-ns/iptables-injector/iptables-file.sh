#!/bin/bash
APP_UID=1000
APP_PORT=8080
SIDECAR_UID=2000
SIDECAR_PORT=8125

set -x
# SIDECAR_CONFIG=$(crictl ps --name statsd -q| xargs crictl inspect)
SIDECAR_PID=$(crictl -r unix:///var/run/containerd/containerd.sock ps --name statsd -q | xargs crictl -r unix:///var/run/containerd/containerd.sock inspect | jq '.info.pid')

nsenter -t $SIDECAR_PID -n iptables-restore < iptables.rules

set +x

while true; do sleep 1; done
