FROM alpine:3.24.4

RUN apk add --no-cache ca-certificates

RUN set -eux; \
    apk add --repository=https://dl-cdn.alpinelinux.org/alpine/v3.24/community --no-cache yq-go; \
    yq --version

