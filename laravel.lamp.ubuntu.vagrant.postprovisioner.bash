#!/bin/bash
echo -e "\nInstalling MySQL Server\n"
sudo apt-get -y install mysql-server
echo -e "\nSecure Installig MYSQL dataBases\n"
sudo mysql_secure_installation
echo -e "\nInstallig phpMyAdmin\n"
sudo apt-get -y install phpmyadmin
echo -e "\nCreating database\n"
mysql -u $2 -p$3 -e "CREATE DATABASE $1";
echo -e "\nJumping into project root\n"
cd /var/www/app
echo -e "\nChanging permission for Laravel\n"
sudo chmod -R a+w bootstrap/cache/ storage/
echo -e "\nSetting up environment variables\n"
sudo cat > .env <<- "EOF"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_LOG_LEVEL=debug
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
EOF
sudo echo -e 'DB_DATABASE='$1'\nDB_USERNAME='$2'\nDB_PASSWORD='$3'\n' >> .env
cat >> .env <<- "EOF"
BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=database

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=

EOF
echo -e "\nSetting up application key...\n"
php artisan key:generate
echo -e "\nMastering VirtualHost\n"
sudo cat > /etc/apache2/sites-available/000-default.conf <<- "EOF"
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin djsmuman@gmail.com

    <Directory /var/www>
        AllowOverride All
    </Directory>

    DocumentRoot /var/www
    <Directory /var/www>
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
echo -e "\nEnabling VirtualHost\n"
sudo a2ensite 000-default.conf
echo -e "\nRestarting Apache2 Server\n"
sudo service apache2 restart
cd ../app
echo -e "\nMigrating tables\n"
php artisan migrate
echo -e "\nSeeding database\n"
php artisan db:seed
cd ..
echo -e "\nPutting vagrant cache and log into .gitignore\n"
cat >> .gitignore <<-"EOF"
.vagrant
ubuntu-xenial-16.04-cloudimg-console.log
EOF
echo -e "\nPutting Apache2 into default user group\n"
sudo usermod -a -G ubuntu www-data
echo -e "\nRestarting Apache2 Service\n"
sudo systemctl restart apache2.service
echo -e "\n\t\tSetup Complete! \n\t\t===============\n"
