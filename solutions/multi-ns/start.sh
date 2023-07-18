#!/bin/sh

set -x

minikube start --nodes 2 --cni=calico --container-runtime=containerd

minikube image load node-app
minikube image load iptables-injector

kubectl apply -R -f multus/
kubectl apply -f namespace.yml
kubectl apply -f local-network.yml
kubectl apply -R -f app/

kubectl apply -f redirect-injector.yml
