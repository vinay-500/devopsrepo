#FROM nginx
# FROM richarvey/nginx-php-fpm:latest
FROM openresty/openresty

# Install DNS Utils (for dig)
# RUN apt-get update
# RUN apk add --no-cache bind-tools
#RUN apk add --no-cache wget
#RUN apk update && apk add bash

RUN apt-get update
RUN apt-get install -y curl dnsutils

COPY 404.html /etc/nginx/html/index.html
COPY nginx.conf /etc/nginx

# Lua
COPY lua /usr/local/openresty/nginx/lua
RUN chmod -R 777 /usr/local/openresty/nginx/logs

RUN chmod +x /usr/local/openresty/nginx/lua/last-access.sh
RUN chmod +x /usr/local/openresty/nginx/lua/forward.sh

# Confs
RUN mkdir /etc/nginx/confs
COPY confs /etc/nginx/confs

# Default Copy
COPY default.conf /etc/nginx/conf.d

CMD ["nginx", "-g", "daemon off;"]