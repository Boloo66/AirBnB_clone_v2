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

source_file="/data/web_static/current"
destiny_file="/data/web_static/releases/test/"

ln -sf /data/web_static/releases/test/index.html /data/web_static/current

chown -R ubuntu /data/
chgrp -R ubuntu /data/

sudo sed -i "38i \ \tlocation /hbnb_static/ {\n\t\talias $source_file/;\n\t\tautoindex off;\n\t}\n" /etc/nginx/sites-enabled/default

service nginx restart