# Zero Trust Architecture with Kubernetes sidecars

## Solutions

- [Single Namespace](solutions/single-ns), where sidecar is installed in same Pod (network namespace)
- [Multiple Namespaces](solutions/single-ns), where sidecar is its own Pod and NIC mimicing loopback device is built with Multus

## Setup

- Install minikube
- Build required containers
  - Application in [./node-app/](node-app/)
  - iptables-injector in [./solutions/iptables-injector/](solutions/iptables-injector/)
  - `cd node-app && docker build . -t node-app`
  - `cd solutions/iptables-injector && docker build . -t iptables-injecto`
- Run `start.sh` in either solution [single-ns](solutions/single-ns) and [multi-ns](solutions/multi-ns)

### Debugging netcat cmds

```bash
printf 'GET / HTTP/1.1\r\nHost: localhost:8888\r\n\r\n' | nc localhost 8888
nc -u localhost 8125
```
