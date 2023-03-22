#!/bin/sh

# https://docs.cilium.io/en/v1.13/gettingstarted/k8s-install-default/

set -x

# Start minikube, install Cilium
# Requires Cilium CLI
# Requires Hubble CLI
# See cilium-install-sh

minikube start --nodes 2 --cni=false
cilium install
cilium hubble enable --ui

# minikube start --nodes 2 --cni=cilium --container-runtime=cri-o

kubectl get node -l '!node-role.kubernetes.io/control-plane' -o custom-columns=NAME:.metadata.name | tail -n +2 | xargs -I{} kubectl label nodes {} kubernetes-worker= node-role.kubernetes.io/worker=
kubectl label namespace kube-system name=kube-system
kubectl label nodes --all kubernetes-host=

minikube image load malicious-sidecar
# minikube image load go-ebpf

cilium status
# cilium connectivity test

kubectl apply -f cluster/
