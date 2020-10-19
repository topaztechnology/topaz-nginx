#!/bin/bash

set -eo pipefail

function listCertFiles {
  ls -l /etc/nginx/certs
}


export EXTERNAL_HOSTNAME=$(cd /etc/nginx/certs && find . -type f \( -iname \*.crt -o -iname \*.key \) | sed -E 's/^\.\/(.*)\.(key|crt)$/\1/g' | sort | uniq)
NUM_HOSTNAMES=$(echo $EXTERNAL_HOSTNAME | wc -l)

if [[ -z "${INTERNAL_SOCKET}" ]]; then
  echo "No INTERNAL_SOCKET variable is defined for nginx to forward to"
  exit 1
elif [[ "${NUM_HOSTNAMES}" -eq 0 ]]; then
  echo "No certificate files (crt or key) found"
  listCertFiles
  exit 1
elif [[ "${NUM_HOSTNAMES}" -gt 1 ]]; then
  echo "Files for more than one certificate found"
  listCertFiles
  exit 1
elif [[ ! -f "/etc/nginx/certs/${EXTERNAL_HOSTNAME}.key" ]]; then
  echo "${EXTERNAL_HOSTNAME}.key file not found"
  listCertFiles
  exit 1
elif [[ ! -f "/etc/nginx/certs/${EXTERNAL_HOSTNAME}.crt" ]]; then
 echo "${EXTERNAL_HOSTNAME}.crt file not found"
  listCertFiles
 exit 1
fi

envsubst '${EXTERNAL_HOSTNAME},${INTERNAL_SOCKET}' < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'
