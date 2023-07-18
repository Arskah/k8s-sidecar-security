FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update -y
RUN apt install -y iptables jq wget

# Install crictl
ENV CRICTL_VERSION="v1.26.0"
RUN wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz
RUN tar zxvf crictl-$CRICTL_VERSION-linux-amd64.tar.gz -C /usr/local/bin
RUN rm -f crictl-$CRICTL_VERSION-linux-amd64.tar.gz

COPY ./iptables.sh iptables.sh
COPY ./iptables-file.sh iptables-file.sh
COPY ./iptables.rules iptables.rules

COPY ./localhost-redirect.sh localhost-redirect.sh
