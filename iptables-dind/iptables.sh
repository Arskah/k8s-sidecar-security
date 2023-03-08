SIDECAR_UID=2000
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Build chain based on uid
iptables --new-chain sidecar_user
iptables -A OUTPUT -m owner --uid-owner $SIDECAR_UID -j sidecar_user

# Chain rules
iptables -A sidecar_user -j REJECT
