#!/bin/bash

set -x

MAIN_PID=$(crictl -r unix:///var/run/containerd/containerd.sock ps --name node-app -q | xargs crictl -r unix:///var/run/containerd/containerd.sock inspect | jq '.info.pid')

nsenter -t $MAIN_PID -n sysctl -w net.ipv4.conf.all.route_localnet=1
nsenter -t $MAIN_PID -n iptables -t nat -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
nsenter -t $MAIN_PID -n iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p udp --dport 8125 -j DNAT --to-destination 192.168.1.202:8125
nsenter -t $MAIN_PID -n iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE

set +x

while true; do sleep 1; done
