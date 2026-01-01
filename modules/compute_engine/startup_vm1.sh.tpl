#!/bin/bash

sudo apt update && sudo apt install -y nginx ssl-cert

cat <<EOF | sudo tee /etc/nginx/sites-available/hello.conf
server {
    listen 80;
    listen 443 ssl;

    # Self-signed certs
    ssl_certificate     /etc/ssl/certs/ssl-cert-snakeoil.pem;
    ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

    server_name _;

    location / {
        default_type text/plain;
        return 200 "OK, hello world\n";
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/hello.conf /etc/nginx/sites-enabled/hello.conf
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx