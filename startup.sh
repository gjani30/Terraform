#!/bin/bash
apt update
apt upgrade -y

# install nginx
apt-get install -y \
    nginx

git clone https://github.com/jimini55/catsdogs-cloud9.git

cp -r catsdogs-cloud9/* /var/www/html/