FROM --platform=amd64 docker

RUN apk update && apk upgrade
RUN apk add ip6tables iptables

COPY ./iptables.sh iptables.sh
