FROM alpine:3.20.10

RUN apk add --no-cache ca-certificates

RUN set -eux; \
    apk add --repository=https://dl-cdn.alpinelinux.org/alpine/v3.21/community --no-cache apprise; \
    apprise --version

RUN apk add --no-cache curl

RUN apk add --no-cache mysql-client

RUN apk add --no-cache openssl

