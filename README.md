# Execute oci-cli and certbot in docker environment.

## Preparation

> **Install this repository in /root/docker/**
>
> Run inside /root/docker/oci-cli-certbot.
>
> ```bash
> [root@***-admin oci-cli-certbot]# ./setup.sh
>```
> This will build the Docker image.
>
> **Create Config file and API Key**
> ```bash
> [root@***-admin oci-cli-certbot]# docker run --rm -v ${PWD}/.oci:/root/.oci -it oci-cli:latest setup config
>```
> Add the API key created here to the OCI user.

---

# Usage

## First certificate issuance

> Run inside /root/docker/oci-cli-certbot/certbot.
>
> ```bash
> docker run \
> --rm \
> -v ${PWD}/certbot/certs:/etc/letsencrypt \
> -v ${PWD}/certbot/log/letsencrypt:/var/log/letsencrypt \
> -v /var/www/html/.well-known:/var/www/html/.well-known \
> -it my_certbot:latest \
> certonly \
> --webroot \
> -w /var/www/html \
> --register-unsafely-without-email \
> --agree-tos \
> --manual-public-ip-logging-ok \
> --preferred-challenges http \
> --domain < Domain name > \
> --dry-run
> ```
> Change < Domain name > according to your environment.<br>
> After confirming with dry run, if there is no problem, delete "-dry-run" and execute.
>
>
> Add the created certificate to the OCI load balancer.
---

## Rewriting Config

> **Edit cron-config.sh**
>
> ```bash:cron-config.sh
> #!/bin/bash#
> letsencrypt directory path
> CERTS_LIVE_PATH="/root/docker/oci-cli-certbot/certbot/certs/live/< Domain name >"
> ```
>
>　Change < Domain name > according to your environment.
>
---

> **Edit oci-config.sh**
>
> ```bash:cron-config.sh
> #!/bin/bash
> # OCID of target load balancer
> LB_OCID="< Load Balancer OCID >"
> # letsencrypt directory path
> CERTS_PATH="/etc/letsencrypt/live/< Domain name >"
> # The name of the certificate to enroll
> CREATE_CERT_NAME="< App name >_${DATE}"
> # Backend set name
> BACK_END_SET_NAME="< Backend set name >"
> # HTTPS listener name set in the load balancer
> LISTENER_NAME="< HTTPS listener name >"
> ```
> < Load Balancer OCID ><br>
> < Domain name ><br>
> < App name ><br>
> < Backend set name ><br>
> < HTTPS listener name ><br>
> Please change according to your environment.
>

---

> **Edit /.oci/oci_cli_rc**
>
> ```bash:oci_cli_rc
>
> ~
>
> [DEFAULT]
> compartment-id = < Compartment OCID >
> ```
>
>　Change < Compartment OCID > according to your environment.
>

---

## Renew the certificate manually.

>
> Run certbot-renew.sh at /root/docker/oci-cli-certbot.
>
> ```bash
> ./certbot-renew.sh
>```
> When running --dry-run
>
> ```bash
> ./certbot-renew.sh --dry-run
>```
> You can also use --force-renewal as an argument.
>

---

## Manually upload the certificate and switch to OCI

>
> Run lb-cert-update.sh at /root/docker/oci-cli-certbot.
>
> ```bash
> ./lb-cert-update.sh
>```
> Upload and switch existing certificates.
>

---

## Automatically upload and switch certificates from renewal to OCI

>
> Execute cron.sh in /root/docker/oci-cli-certbot.
>
> ```bash
> ./cron.sh
>```
> Renew the certificate. If the renewal date is different from the certificate before renewal, upload and switch to OCI.
>
>
