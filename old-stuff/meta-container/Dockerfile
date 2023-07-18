FROM --platform=amd64 malicious-sidecar

COPY meta-entrypoint.sh ./
RUN chmod +x ./meta-entrypoint.sh

RUN apt install -y iptables
USER 123

ENTRYPOINT [ "./meta-entrypoint.sh" ]
