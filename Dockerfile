FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update
RUN apt install -y curl

# Setup kubectl
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | tee /etc/apt/sources.list.d/kubernetes.list

# Install deps
RUN apt update
RUN apt install -y net-tools nmap ncat kubectl etcd iputils-ping iproute2

# kubeletctl
RUN curl -LO https://github.com/cyberark/kubeletctl/releases/download/v1.9/kubeletctl_linux_amd64 && chmod a+x ./kubeletctl_linux_amd64 && mv ./kubeletctl_linux_amd64 /usr/local/bin/kubeletctl

RUN apt install -y iptables

# Point to the internal API server hostname
RUN echo 'export APISERVER=https://kubernetes.default.svc' >> root/.bashrc
# Path to ServiceAccount token
RUN echo 'export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount' >> root/.bashrc
# Read this Pod's namespace
RUN echo 'export NAMESPACE="$(cat ${SERVICEACCOUNT}/namespace)"' >> root/.bashrc
# Read the ServiceAccount bearer token
RUN echo 'export TOKEN="$(cat ${SERVICEACCOUNT}/token)"' >> root/.bashrc
# Reference the internal certificate authority (CA)
RUN echo 'export CACERT="${SERVICEACCOUNT}/ca.crt"' >> root/.bashrc
