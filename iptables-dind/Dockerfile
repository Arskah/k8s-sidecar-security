FROM docker

RUN apk update && apk upgrade
RUN apk add ip6tables iptables

COPY ./iptables.sh iptables.sh
