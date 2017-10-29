#!/bin/bash
#===============================================================================
#
#          FILE:  laravel.lemp.ubuntu.vagrant.postprovisioner.bash
#
#         USAGE:  ./laravel.lemp.ubuntu.vagrant.postprovisioner.bash
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
if [ $# -eq 0 ]; then
  echo -n "Please enter database passowrd for root user: "
  read db_pwd
  echo -n "Please enter project name: "
  read proj_name
else
  if [[ $1 == "-p" && ! -z $2 ]]; then
    db_pwd=$2
  elif [[ $1 == "-n" && ! -z $2 ]]; then
    proj_name=$2
  fi
  if [[ $3 == "-p" && ! -z $4  ]]; then
    db_pwd=$4
  elif [[ $3 == "-n" && ! -z $4 ]]; then
    proj_name=$4
  fi
fi
echo -e "\Installing MariaDB Server..."
sudo apt-get install -y mariadb-server mariadb-client
sudo mysql_secure_installation
sudo mysql -u root -p$db_pwd -Bse "
USE mysql;
UPDATE user SET plugin='' WHERE User='root';
FLUSH PRIVILEGES;CREATE DATABASE ${proj_name,,};
EXIT;"
echo -e "\Insatlling phpMyAdmin..."
curl -O https://files.phpmyadmin.net/phpMyAdmin/4.7.3/phpMyAdmin-4.7.3-english.tar.xz
tar -xzf phpMyAdmin-4.7.3-english.tar.xz
sudo mv -f phpMyAdmin-4.7.3-english/ /usr/share/phpmyadmin/
sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
blowfish=`openssl rand -base64 32`;
sudo sed -i -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$blowfish'|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['controluser'\] = 'pma';|$cfg\['Servers'\]\[$i\]\['controluser'\] = 'pma';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['controlpass'\] = 'pmapass';|$cfg\['Servers'\]\[$i\]\['controlpass'\] = '$db_pwd';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['pmadb'\] = 'phpmyadmin';|$cfg\['Servers'\]\[$i\]\['pmadb'\] = 'phpmyadmin';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['bookmarktable'\] = 'pma__bookmark';|$cfg\['Servers'\]\[$i\]\['bookmarktable'\] = 'pma__bookmark';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['relation'\] = 'pma__relation';|$cfg\['Servers'\]\[$i\]\['relation'\] = 'pma__relation';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['table_info'\] = 'pma__table_info';|$cfg\['Servers'\]\[$i\]\['table_info'\] = 'pma__table_info';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['table_coords'\] = 'pma__table_coords';|$cfg\['Servers'\]\[$i\]\['table_coords'\] = 'pma__table_coords';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['pdf_pages'\] = 'pma__pdf_pages';|$cfg\['Servers'\]\[$i\]\['pdf_pages'\] = 'pma__pdf_pages';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['column_info'\] = 'pma__column_info';|$cfg\['Servers'\]\[$i\]\['column_info'\] = 'pma__column_info';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['history'\] = 'pma__history';|$cfg\['Servers'\]\[$i\]\['history'\] = 'pma__history';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['table_uiprefs'\] = 'pma__table_uiprefs';|$cfg\['Servers'\]\[$i\]\['table_uiprefs'\] = 'pma__table_uiprefs';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['tracking'\] = 'pma__tracking';|$cfg\['Servers'\]\[$i\]\['tracking'\] = 'pma__tracking';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['userconfig'\] = 'pma__userconfig';|$cfg\['Servers'\]\[$i\]\['userconfig'\] = 'pma__userconfig';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['recent'\] = 'pma__recent';|$cfg\['Servers'\]\[$i\]\['recent'\] = 'pma__recent';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['favorite'\] = 'pma__favorite';|$cfg\['Servers'\]\[$i\]\['favorite'\] = 'pma__favorite';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['users'\] = 'pma__users';|$cfg\['Servers'\]\[$i\]\['users'\] = 'pma__users';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['usergroups'\] = 'pma__usergroups';|$cfg\['Servers'\]\[$i\]\['usergroups'\] = 'pma__usergroups';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['navigationhiding'\] = 'pma__navigationhiding';|$cfg\['Servers'\]\[$i\]\['navigationhiding'\] = 'pma__navigationhiding';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['savedsearches'\] = 'pma__savedsearches';|$cfg\['Servers'\]\[$i\]\['savedsearches'\] = 'pma__savedsearches';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['central_columns'\] = 'pma__central_columns';|$cfg\['Servers'\]\[$i\]\['central_columns'\] = 'pma__central_columns';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['designer_settings'\] = 'pma__designer_settings';|$cfg\['Servers'\]\[$i\]\['designer_settings'\] = 'pma__designer_settings';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg\['Servers'\]\[$i\]\['export_templates'\] = 'pma__export_templates';|$cfg\['Servers'\]\[$i\]\['export_templates'\] = 'pma__export_templates';|" /usr/share/phpmyadmin/config.inc.php
sudo mysql -u root -p$db_pwd -Bse "
GRANT USAGE ON mysql.* TO 'pma'@'localhost' IDENTIFIED BY '$db_pwd';
GRANT SELECT (
    Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
    Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
    File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
    Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
    Execute_priv, Repl_slave_priv, Repl_client_priv
    ) ON mysql.user TO 'pma'@'localhost';
GRANT SELECT ON mysql.db TO 'pma'@'localhost';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv)
    ON mysql.tables_priv TO 'pma'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost';
exit;"
sudo cat >> /etc/nginx/sites-available/default <<- "EOF"
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass    unix:/run/php/php7.1-fpm.sock;
        include         snippets/fastcgi-php.conf;
    }

    location ~ /\.ht {
        deny all;
    }

    location /phpmyadmin {
        root /usr/share/phpmyadmin;

        # Optionally set separate access and error logs for phpMyAdmin
        access_log /var/log/nginx/phpmyadmin_access.log;
        error_log /var/log/nginx/phpmyadmin_error.log;

        index   index.php;  

        try_files $uri $uri/ =404;

        # Deny some static files
        location ~ ^/phpmyadmin/(README|LICENSE|ChangeLog|DCO)$ {
            deny all;
        }

        # Deny .md files
        location ~ ^/phpmyadmin/(.+\.md)$ {
            deny all;
        }

        # Deny some directories
        location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
        }

        #FastCGI config for PhpMyAdmin
        location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_param  SCRIPT_FILENAME /usr/share/phpmyadmin/$1;
            fastcgi_pass   unix:/run/php/php7.1-fpm.sock;
            fastcgi_index  index.php;
            include        fastcgi.conf;
        }
    }
}
EOF
echo -e "\Installing Git Software Control Management..."
sudo apt-get install -y git
echo -e "\Installing Composer PHP Dependency Manager..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo -e "\Crafting a new Laravel Application..."
sudo rm -rf /var/www/html
sudo git clone https://github.com/laravel/laravel.git html
cd /var/www/html
sudo chown -R $USER:www-data /var/www/html
sudo chmod a+w -R bootstrap/cache /storage
composer install
sed -i -e 's/Laravel/$proj_name/g' .env
sed -i -e 's/localhost/${proj_name,,}.dev/g' .env
sed -i -e 's/DB_DATABASE=homestead/DB_DATABASE=${proj_name,,}/g' .env
sed -i -e 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
sed -i -e 's/DB_PASSWORD=secret/DB_PASSWORD=$db_pwd/g' .env
php artisan key:generate
cat >> .gitignore <<-"EOF"
.vagrant
ubuntu-xenial-16.04-cloudimg-console.log
EOF
echo -e "\Reconfiguring NGINX server block to serve Laravel..."
sudo sed -i -e 's/try_files $uri $uri/ =404;/try_files $uri $uri/ /index.php?$query_string;/' /etc/nginx/sites-available/default
sudo systemctl restart nginx
