#!/bin/bash
echo -e "\nRunning LAMP Installer..."
echo -e "\nUpdating Ubuntu System...\n"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
echo -e "\nInstalling Apache2\n"
sudo apt-get -y install apache2
echo -e "\nAllowing Apache2 rule Firewall"
sudo ufw allow in "Apache Full"
echo -e "\nInstalling PHP7\n"
sudo apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mbstring php7.0-mcrypt php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dom php7.0-zip php7.0-bcmath php7.0-xml php7.0-mysql php7.0-json php7.0-common
echo -e "\nChanging Apache2 preference to load PHP at first...\n"
sudo rm /etc/apache2/mods-enabled/dir.conf
sudo cat > /etc/apache2/mods-enabled/dir.conf <<- "EOF"
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF
echo -e "\nEnabling PHP Modules\n"
sudo phpenmod mcrypt
sudo phpenmod mbstring
echo -e "\nEnabling Apache2 Rewrite Module\n"
sudo a2enmod rewrite
echo -e "\nMastering VirtualHost\n"
sudo cat > /etc/apache2/sites-available/000-default.conf <<- "EOF"
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin djmsuman@gmail.com

    <Directory /var/www>
        AllowOverride All
    </Directory>

    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
echo -e "\nEnabling VirtualHost\n"
sudo a2ensite 000-default.conf
echo -e "\nRestarting Apache2 Server\n"
sudo service apache2 restartecho -e "\nInstalling MySQL Server\n"
sudo apt-get -y install mysql-server
echo -e "\nSecure Installig MYSQL dataBases\n"
sudo mysql_secure_installation
echo -e "\nInstallig phpMyAdmin\n"
sudo apt-get -y install phpmyadmin
echo -e "\nInstalling \"Composer\" Globally\n"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
