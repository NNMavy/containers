# STEP 1 build executable binary
FROM public.ecr.aws/docker/library/golang:1.20.4-alpine3.16 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETVARIANT=""

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOARM=${TARGETVARIANT}

# Install SSL ca certificates
RUN \
  apk update && apk add git \
  && go install -ldflags="-s -w" "github.com/masgustavos/alertmanager-discord@${VERSION}"

# STEP 2 build a small image
# start from scratch
FROM docker.io/library/alpine:3.20

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

# Copy our static executable
COPY --from=builder /go/bin/alertmanager-discord /go/bin/alertmanager-discord

#hadolint ignore=DL3018
RUN \
  apk add --no-cache \
  bash \
  ca-certificates \
  catatonit \
  curl

#hadolint ignore=DL3018
RUN \
  curl -o /tmp/config.yaml https://raw.githubusercontent.com/masgustavos/alertmanager-discord/main/config.example.yaml \
  && cp /tmp/config.yaml /app/config.yaml

USER nobody:nogroup
ENV LISTEN_ADDRESS=0.0.0.0:8080
ENV CONFIG_PATH=/app/config.yaml

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/go/bin/alertmanager-discord"]

LABEL org.opencontainers.image.source="https://github.com/masgustavos/alertmanager-discord"