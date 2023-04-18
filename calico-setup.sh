#!/bin/sh

set -x

minikube start --nodes 2 --cni=calico --container-runtime=containerd
# kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous

kubectl get node -l '!node-role.kubernetes.io/control-plane' -o custom-columns=NAME:.metadata.name | tail -n +2 | xargs -I{} kubectl label nodes {} kubernetes-worker= node-role.kubernetes.io/worker=
kubectl label namespace kube-system name=kube-system
kubectl label nodes --all kubernetes-host=

minikube image load malicious-sidecar

# calicoctl --allow-version-mismatch patch kubecontrollersconfiguration default --patch='{"spec": {"controllers": {"node": {"hostEndpoint": {"autoCreate": "Enabled"}}}}}'
# calicoctl --allow-version-mismatch apply -f calico/global-network-policy.yml
