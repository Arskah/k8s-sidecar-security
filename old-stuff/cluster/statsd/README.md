# Setup

Main application "node-app" and it's sidecar "node-app-statsd", a StatsD server, run on own Pods with addition network interface br0. IP addresses are 192.168.0.1 and 192.168.1.202 respectively. IPTables rule on node-app that forwards localhost:8125 -> 192.168.1.202:8125 sends comms to the sidecar. NetworkPolicy and MultiNetworkPolicy build a zero trust networking model everywhere.

## Setting up localhost redirection

Find PID on Node machine

```bash
CID=$(sudo crictl ps) # Get container id
sudo crictl inspect $CID | grep pid # Get PID
```

```bash
sudo nsenter -t $PID -n sysctl -w net.ipv4.conf.all.route_localnet=1
sudo nsenter -t $PID -n iptables -t nat -A OUTPUT -p ALL --dport 8125 -j DNAT --to-destination 192.168.1.202:8125
sudo nsenter -t $PID -n iptables -t nat -A POSTROUTING -j MASQUERADE
```
