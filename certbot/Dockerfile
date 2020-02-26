FROM alpine:3.10
LABEL maintainer "Manaki <manakinaoe@gmail.com>"

RUN set -xe && \
    apk add --no-cache --update \
        certbot

ENTRYPOINT [ "certbot" ]