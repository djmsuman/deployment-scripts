#!/bin/bash
echo -e "\nRunning LAMP Installer..."
echo -e "\nUpdating Ubuntu System...\n"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get install -f -y
sudo apt-get -y autoremove
echo -e "\Installing Git Software Control Management..."
sudo apt-get install -y git
echo -e "\nInstalling Apache2\n"
sudo apt-get -y install apache2
echo -e "\nAllowing Apache2 rule Firewall"
sudo ufw allow in "Apache Full"
echo -e "\nInstalling PHP7\n"
sudo apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mbstring php7.0-mcrypt php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dom php7.0-zip php7.0-bcmath php7.0-xml php7.0-json php7.0-mysql php7.0-common
sudo apt-get install -y php7.1 libapache2-mod-php7.1 php7.1-mbstring php7.1-mcrypt php7.1-cgi php7.1-cli php7.1-common php7.1-curl php7.1-zip php7.1-bcmath php7.1-xml php7.1-json php7.1-mysql php7.1-common
sudo apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-mbstring php7.2-cgi php7.2-cli php7.2-common php7.2-curl php7.2-zip php7.2-bcmath php7.2-xml php7.2-json php7.2-mysql php7.2-common
sudo apt-get install -y php7.3 libapache2-mod-php7.3 php7.3-mbstring php7.3-cgi php7.3-cli php7.3-common php7.3-curl php7.3-zip php7.3-bcmath php7.3-xml php7.3-json php7.3-mysql php7.3-common
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
sudo service apache2 restart
echo -e "\nInstalling MySQL Server\n"
sudo apt-get -y install mysql-server
echo -e "\nSecure Installig MYSQL dataBases\n"
sudo mysql_secure_installation
echo -e "\nInstallig phpMyAdmin\n"
sudo apt-get -y install phpmyadmin
echo -e "\nInstalling \"Composer\" Globally\n"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
