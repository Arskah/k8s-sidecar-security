FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update
RUN apt install -y curl

# Setup kubectl
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# Install deps
RUN apt update
RUN apt install -y net-tools nmap kubectl
