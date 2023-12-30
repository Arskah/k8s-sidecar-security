#!/bin/bash
APP_UID=1000
APP_PORT=8888
SIDECAR_UID=2000
SIDECAR_PORT=8125

set -x
# SIDECAR_CONFIG=$(crictl ps --name statsd -q| xargs crictl inspect)
SIDECAR_PID=$(crictl -r unix:///var/run/containerd/containerd.sock ps --name statsd -q | xargs crictl -r unix:///var/run/containerd/containerd.sock inspect | jq '.info.pid')

# SIDECAR_CONFIG=$(docker ps -q | xargs docker inspect --format '{{.State.Pid}},{{.Config.User}},{{.Name}}' | grep sidecar)
# SIDECAR_PID=$(echo $SIDECAR_CONFIG | cut -f1 -d,)

nsenter -t $SIDECAR_PID -n iptables-restore < iptables.rules

set +x

while true; do sleep 1; done
