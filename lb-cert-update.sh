#!/bin/bash

VOLEME_PATH="/root/docker/oci-cli-certbot"
DOCKER_RUN="docker run --rm -v ${VOLEME_PATH}/oci-cli/.oci:/root/.oci -v ${VOLEME_PATH}/certbot/certs:/etc/letsencrypt oci-cli:latest"
DATE=`date '+%F'-%H-%M`

source ${VOLEME_PATH}/oci-config.sh

# Get the name of the currently enrolled certificate
DELETE_CERT_NAME=`${DOCKER_RUN} lb certificate list --load-balancer-id ${LB_OCID} | grep certificate-name`
# Take out the necessary parts
DELETE_CERT_NAME=`echo ${DELETE_CERT_NAME} | awk -F':' '{print $2}'`
# Extraction within double quotes
DELETE_CERT_NAME=`echo ${DELETE_CERT_NAME} | awk -F'"' '{print $2}'`

# Upload SSL certificate
RESULT=`${DOCKER_RUN} lb certificate create --certificate-name "${CREATE_CERT_NAME}" --load-balancer-id ${LB_OCID} --ca-certificate-file ${CERTS_PATH}/chain.pem --private-key-file ${CERTS_PATH}/privkey.pem --public-certificate-file ${CERTS_PATH}/cert.pem --wait-for-state SUCCEEDED`
echo "${RESULT}"

# Update listener
RESULT=`${DOCKER_RUN} lb listener update --default-backend-set-name ${BACK_END_SET_NAME} --listener-name ${LISTENER_NAME} --load-balancer-id ${LB_OCID} --port 443 --protocol HTTP --ssl-certificate-name ${CREATE_CERT_NAME} --force --wait-for-state SUCCEEDED`
echo "${RESULT}"

# Old SSL certificate DELETE
RESULT=`${DOCKER_RUN} lb certificate delete --certificate-name "${DELETE_CERT_NAME}" --load-balancer-id ${LB_OCID} --force --wait-for-state SUCCEEDED`
echo "${RESULT}"
