#!/bin/bash

docker build -t my_certbot certbot/

docker build -t oci-cli oci-cli/

echo '*******************************************************************************************************************************'
echo 'After issuing the certificate with the following command, manually attach the certificate to the load balancer on the OCI side.'
echo '*******************************************************************************************************************************'
echo 'Initial certificate issuing command'
echo '--------------------------------------------------------------'
echo 'docker run \'
echo '--rm \'
echo '-v ${PWD}/certbot/certs:/etc/letsencrypt \'
echo '-v ${PWD}/certbot/log/letsencrypt:/var/log/letsencrypt \'
echo '-v /var/www/html/.well-known:/var/www/html/.well-known \'
echo '-it my_certbot:latest \'
echo 'certonly \'
echo '--webroot \'
echo '-w /var/www/html \'
echo '--register-unsafely-without-email \'
echo '--agree-tos \'
echo '--manual-public-ip-logging-ok \'
echo '--preferred-challenges http \'
echo '--domain < Domain name > \'
echo '--dry-run'
echo '--------------------------------------------------------------'
echo 'If there is no problem with a dry run, run without -dry-run.'
echo '*******************************************************************************************************************************'
