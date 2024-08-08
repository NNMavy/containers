FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN \
	apk add --no-cache tinyproxy~"${VERSION}" && \
	rm -rf /etc/tinyproxy/* && \
    rm -rf /var/cache/apk/*

COPY ./apps/tinyproxy/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

# Expose tinyproxy port
EXPOSE 8888
