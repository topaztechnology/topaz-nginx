# nginx image with autoconfiguration

## Supported tages and respective `Dockerfile` links

| Tag    | nginx  | Dockerfile |
|--------|--------|------------|
| 1.18.0 | 1.18.0 | [(Dockerfile)](https://github.com/topaztechnology/topaz-nginx/blob/1.18.0/Dockerfile) |

## Overview

An image based on the standard nginx Alpine image, but with `nginx.conf` generation from inspection of the certs mount. Also included in the template is:

* TLS 1.2 & [strong cipher suites](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
* Redirect from HTTP to HTTPS
* WebSockets support
* SSE support

## Usage

```
docker run \
  -p 80:80 -p 443:443 \
  -e INTERNAL_SOCKET=<host:port> \
  -v <certs volume>:/etc/nginx/certs \
  topaztechnology/topaz-nginx:latest
```

The files in the certs volume mounted into the container are inspected to determine the hostname. There should be two files: `<FQDN>.crt` and `<FQDN>.key`. The FQDN should be the full DNS name as specified in the certificate as usual.
