#!/bin/bash
#===============================================================================
#
#          FILE:  laravel.lemp.ubuntu.vagrant.provisioner.bash
#
#         USAGE:  ./laravel.lemp.ubuntu.vagrant.provisioner.bash
#
#   DESCRIPTION: Vagrant provisioning script for local web app development.
#                Provisoning LEMP Stack includes Ubuntu 16.04 LTS as OS, NGINX
#                as Web Server, MariaDB as DataBase Server and PHP 7.1 as Server
#                side Processor. Configuring NGINX Server Blocks to serve
#                Laravel as a backend Web Framework.
#
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Deepjyoti Mukherjee, djmsuman@gmail.com
#       COMPANY:  ---
#       VERSION:  1.0
#       CREATED:  08/05/2017 01:21:01 AM IST
#      REVISION:  ---
#===============================================================================
echo -e "\nUpdating full system...\n"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get auto-remove -y
echo -e "\nInstalling NGINX server...\n"
sudo apt-get install -y nginx
echo -e "\nAllowing NGINX through Firewall...\n"
sudo ufw allow 'Nginx HTTP'
sudo ufw status
echo -e "\nInstalling PHP7.1...\n"
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install -y php7.1 php7.1-fpm php7.1-mbstring php7.1-mcrypt php7.1-cgi php7.1-cli php7.1-common php7.1-curl php7.1-dom php7.1-zip php7.1-bcmath php7.1-xml php7.1-json php7.1-mysql
echo -e "\nEnabling PHP Modules...\n"
sudo phpenmod mcrypt
sudo phpenmod mbstring
echo -e "\nConfiguring PHP Processor...\n"
sudo sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.1/fpm/php.ini
sudo systemctl restart php7.1-fpm
echo -e "\nAllowing user permission on webroot...\n"
sudo usermod -a -G www-data $USER
sudo chown -R $USER:www-data /var/www/html
echo -e "\nConfiguring NGINX default server block to process PHP...\n"
cat > /etc/nginx/sites-available/default <<- "EOF"
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
sudo -e "\nChecking NGINX server with PHP...\n"
if [ -f "index.nginx-debian.html" ]; then
  sudo rm -f index.nginx-debian.html
fi
sudo cat > index.php <<- "EOF"
<?php phpinfo(); ?>
EOF
sudo systemctl restart nginx
