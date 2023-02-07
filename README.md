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
