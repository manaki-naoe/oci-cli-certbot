#!/bin/bash

VOLEME_PATH="/root/docker/oci-cli-certbot"

function certbotRenew() {
    source ${VOLEME_PATH}/certbot-renew.sh
}

function lbCertUpdate() {
    source ${VOLEME_PATH}/lb-cert-update.sh
}

function dateComp()
{
    ARG1_SECOND=`date -d "$1" '+%s'`
    ARG2_SECOND=`date -d "$2" '+%s'`

    expr $ARG1_SECOND - $ARG2_SECOND
}

source ${VOLEME_PATH}/cron-config.sh

# Get certificate renewal date before renewal
OLD_CERT=`date +'%F %T' -r ${CERTS_LIVE_PATH}/cert.pem`
echo ${OLD_CERT}

certbotRenew

# Get certificate renewal date after renewal
NEW_CERT=`date +'%F %T' -r ${CERTS_LIVE_PATH}/cert.pem`
echo ${NEW_CERT}

# Get certificate before renewal and get renewal date after renewal
ret=`dateComp "${OLD_CERT}" "${NEW_CERT}"`

# If the certificate before renewal and the renewal date after renewal are different, renew the certificate of the load balancer
if [ ${ret} != 0 ]; then
    lbCertUpdate
fi