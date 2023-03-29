#!/bin/sh
# https://stackoverflow.com/questions/42280792/reuse-inherited-images-cmd-or-entrypoint

set -x

#!/bin/bash

echo "Start my initialization script..."

SIDECAR_UID=$(id -u)
ENTRY_CMD="iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT && iptables --new-chain sidecar_user && iptables -A OUTPUT -m owner --uid-owner $SIDECAR_UID -j sidecar_user && iptables -A sidecar_user -j REJECT"

# docker inspect malicious-sidecar
# Example:
# Config.Cmd="mysqld"
# Config.Entrypoint="/entrypoint.sh"

# docker inspect results should be used here. Dummy stuff for demo
APP_CMD="echo start-up"

sh -c "$ENTRY_CMD"
sh -c "$APP_CMD"
