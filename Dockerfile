FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update

# Setup kubectl
RUN apt install -y curl
# AMD64, see ARM instructions here https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# Install deps
RUN apt install -y net-tools nmap ncat etcd iputils-ping iproute2 iptables

# kubeletctl
RUN curl -LO https://github.com/cyberark/kubeletctl/releases/download/v1.9/kubeletctl_linux_amd64
RUN chmod a+x ./kubeletctl_linux_amd64
RUN mv ./kubeletctl_linux_amd64 /usr/local/bin/kubeletctl

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
