# Attacking cluster from malicious sidecar

<https://docs.google.com/document/d/1o0N-eOt_ryY2TnjHHzR0ecKc53juZvuCcSAypYIXgVw/edit?usp=sharing>

## Minikube setup

- Install minikube
- Start with network plugin
- Add worker node, for isolation of control and data planes
- Add label for kube-system
- Label all hosts for Calico
- Set automatic Calico endpoints

```bash
minikube start --network-plugin=cni --cni=calico
minikube node add
kubectl get node -l '!node-role.kubernetes.io/control-plane' -o custom-columns=NAME:.metadata.name | tail -n +2 | xargs -I{} kubectl label nodes {} kubernetes-worker= node-role.kubernetes.io/worker=
kubectl label namespace kube-system name=kube-system
kubectl label nodes --all kubernetes-host=
calicoctl patch kubecontrollersconfiguration default --patch='{"spec": {"controllers": {"node": {"hostEndpoint": {"autoCreate": "Enabled"}}}}}'
```

## Cluster setup

- Build the sidecar

```bash
docker build . -t malicious-sidecar
minikube image load malicious-sidecar
```

- Setup the cluser

```bash
kubectl apply -f cluster/insecure-ns
```

- Check pods are healthy with

```bash
kubectl get -A pods
```

- Jump to sidecar terminal with

```bash
kubectl exec --stdin --tty <insert-pod-name> -c sidecar-container -- /bin/bash
```

Or simply

```bash
NAMESPACE=insecure-ns && kubectl get pods -n $NAMESPACE -l app=simple-webapp -o name | rg "pod/" -r "" | head -n 1 | xargs -o -J % kubectl exec -n $NAMESPACE -it % -c sidecar-container -- /bin/bash
```

- Test connectivity to Nginx

```bash
kubectl port-forward -n $NAMESPACE service/simple-webapp 8080:80

```

## Cluster models

### Insecure cluster

- Pod-level service account
- No admission control
- Shared network interface (localhost), unblockable with NetworkPolicy
  - Kubernetes constraint, Pod is the lowest security boundary
  - Blocking this requires manual tweaking

### Secure cluster

- Automatic mounting of service account disabled, mount only where needed (or automatic default which has no permission, mount more priviledged SA where needed)
- Admission control to prevent MutatingWebhooks causing misconfigurations (automatic tools like `istioctl` use these, malicious installation could force priviledged containers?)
- Calico to block localhost ports? (network isolation)

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
