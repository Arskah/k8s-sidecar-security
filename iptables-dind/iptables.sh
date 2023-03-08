set -x
# SIDECAR_UID=2000
SIDECAR_CONFIG=$(docker ps -q | xargs docker inspect --format '{{.State.Pid}},{{.Config.User}},{{.Name}}' | grep sidecar)

SIDECAR_PID=$(echo $SIDECAR_CONFIG | cut -f1 -d,)
SIDECAR_UID=$(echo $SIDECAR_CONFIG | cut -f2 -d,)

# nsenter -t $SIDECAR_PID -n

nsenter -t $SIDECAR_PID -n iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Build chain based on uid
nsenter -t $SIDECAR_PID -n iptables --new-chain sidecar_user
nsenter -t $SIDECAR_PID -n iptables -A OUTPUT -m owner --uid-owner $SIDECAR_UID -j sidecar_user

# Chain rules
nsenter -t $SIDECAR_PID -n iptables -A sidecar_user -j REJECT

while true; do sleep 1; done
