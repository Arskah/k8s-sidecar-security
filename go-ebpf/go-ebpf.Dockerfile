# Based on https://github.com/kinvolk-archives/cgnet

FROM --platform=linux/amd64 ubuntu:22.04

RUN apt-get update
RUN apt-get install -y build-essential git curl
RUN curl -LO https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
# Setup Go
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
RUN git clone https://github.com/cilium/ebpf.git

ENV PATH="${PATH}:/usr/local/go/bin"
WORKDIR /ebpf/examples
# ENTRYPOINT [ "go run ./ebpf/examples/xdp" ]
