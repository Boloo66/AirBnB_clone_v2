#!/usr/bin/env bash
# Configures my nginx server from scartch

if ! command -v nginx &> /dev/null;
then
    sudo apt-get -y update
    sudo apt-get install -y nginx
    sudo service nginx start
fi

mkdir -p /data/
mkdir -p /data/web_static/
mkdir -p /data/web_static/releases/
mkdir -p /data/web_static/shared/
mkdir -p /data/web_static/releases/test/

echo "
    <!DOCTYPE html>
    <html lang='en'>
        <head>
            <title>Just a configuration script</title>
            <meta charset="UTF-8"/>
        </head>
        <body>
        <h1 style=color:'blue'>THIS IS MY HEADING</h1>
            <p>Incoming devops, so get ready world!</P>
        </body>
    </html>
" > /data/web_static/releases/test/index.html

ln -sf /data/web_static/releases/test/index.html /data/web_static/current

chown -R ubuntu /data/
chgrp -R ubuntu /data/

printf %s "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm;
    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }
    location /redirect_me {
        return 301 http://cuberule.com/;
    }
    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}" > /etc/nginx/sites-available/default

service nginx restart