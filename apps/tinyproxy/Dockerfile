FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
	    tinyproxy~"${VERSION}" && \
	rm -rf /etc/tinyproxy/* && \
    rm -rf /var/cache/apk/*

COPY ./apps/tinyproxy/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

# Expose tinyproxy port
EXPOSE 8888
