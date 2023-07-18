#!/bin/sh

set -x

minikube start --nodes 2 --cni=cilium --container-runtime=containerd
# minikube start --nodes 2 --cni=calico --container-runtime=containerd

minikube image load node-app
minikube image load iptables-injector

kubectl apply -f namespace.yml
kubectl apply -R -f ./app/  --wait
kubectl apply -f iptables-injector.yml