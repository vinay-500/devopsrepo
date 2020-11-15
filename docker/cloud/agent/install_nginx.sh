#!/bin/bash

# Keep sleeping till we got the files copied
sleep 2m

## Use this to install nginx
sudo cp ~/agent/nginx.conf /usr/local/openresty/nginx/conf/
sudo mkdir -p /usr/local/openresty/nginx/conf/conf.d
sudo cp ~/agent/default.conf /usr/local/openresty/nginx/conf/conf.d/

# Copy Lua Scripts
sudo cp -r ~/agent/lua /usr/local/openresty/nginx/
sudo chmod +x /usr/local/openresty/nginx/lua/start.sh 
sudo chmod +x /usr/local/openresty/nginx/lua/stop.sh
sudo chmod +x /usr/local/openresty/nginx/lua/logs.sh  
sudo chmod +x /usr/local/openresty/nginx/lua/status.sh  

# Start openresty
sudo openresty