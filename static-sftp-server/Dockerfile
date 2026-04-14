FROM alpine:latest

ARG S6_OVERLAY_VERSION=3.2.2.0

RUN apk add --no-cache caddy openssh curl tar xz ca-certificates

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

RUN rm /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-x86_64.tar.xz

RUN mkdir -p /var/run/sshd /data /config

COPY rootfs/ /

RUN find /etc/s6-overlay/s6-rc.d/ -name "run" -exec chmod +x {} + && find /etc/s6-overlay/s6-rc.d/ -name "up" -exec chmod +x {} +

EXPOSE 8080 2222

ENTRYPOINT ["/init"]