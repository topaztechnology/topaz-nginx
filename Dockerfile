FROM nginx:1.18.0-alpine

LABEL maintainer="info@topaz.technology"

RUN apk add --update --no-cache curl bash

COPY nginx.template.conf /etc/nginx/
COPY start-nginx.sh /usr/local/bin/

VOLUME /etc/nginx/certs

EXPOSE 80 443

CMD [ "sh", "-c", "/usr/local/bin/start-nginx.sh" ]
