#!/bin/bash

# OCID of target load balancer
LB_OCID="< Load Balancer OCID >"
# letsencrypt directory path
CERTS_PATH="/etc/letsencrypt/live/< Domain name >"
# The name of the certificate to enroll
CREATE_CERT_NAME="< App name >_${DATE}"
# Backend set name
BACK_END_SET_NAME="< Backend set name >"
# HTTPS listener name set in the load balancer
LISTENER_NAME="< HTTPS listener name >"