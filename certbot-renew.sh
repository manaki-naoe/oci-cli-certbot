#!/bin/bash

VOLEME_PATH="/root/docker/oci-cli-certbot"
DOCKER_RUN="docker run --rm -v ${VOLEME_PATH}/certbot/certs:/etc/letsencrypt -v ${VOLEME_PATH}/certbot/log/letsencrypt:/var/log/letsencrypt -v /var/www/html/.well-known:/var/www/html/.well-known my_certbot:latest"

if [ -z "$@" ]; then
    RESULT=`${DOCKER_RUN} renew`
else
    RESULT=`${DOCKER_RUN} renew $@`
fi

echo "${RESULT}"