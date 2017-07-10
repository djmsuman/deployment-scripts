#!/bin/bash
# React App hosting with NGINX & Node.JS
# @author Deepjyoti Mukherjee <djmsuman@gmail.com>
echo -e "\nUpdating full system..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get auto-remove -y
echo -e "\nInstalling NGINX server..."
sudo apt-get install -y nginx
echo -e "\nAllowing NGINX through Firewall..."
sudo ufw allow 'Nginx HTTP'
echo -e "\nInstalling Node.JS & NPM..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install npm
sudo npm install --global npm
sudo npm install --global n
n latest
sudo ln -sf /usr/local/bin/node /usr/bin/nodejs
echo -e "\nInstalling Yarn packege manager..."
sudo npm install --global yarn
echo -e "\nAdding user to www-data group in order to allow access permission for NGINX..."
sudo usermod -a -G www-data ubuntu
sudo chown -R ubuntu:www-data /var/www/html
echo -e "\nUpdate default server block to serve..."
sudo rm -f /etc/nginx/sites-available/default
sudo cat > /etc/nginx/sites-available/default <<- 'EOF'
# NGINX ServerBlocks are same as Apache VirtualHosts
# Default server configuration for NGINX
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;

	# Document root for server
	root /var/www/html/build;

	# Define Error & Access log paths
	error_log /var/log/nginx/error.log warn;
	access_log /var/log/nginx/access.log combined;

	# Serve default file in following order
	index index.html index.htm index.js;

	server_name _;

	rewrite ^/(.*)/$ $1 permanent;
	location / {
		try_files $uri $uri/ =404;
	}
}
EOF
sudo rm -f /var/www/html/index.nginx-debian.html
sudo service nginx restart
echo -e "\nSetup complete... Happy Hosting! :D"
