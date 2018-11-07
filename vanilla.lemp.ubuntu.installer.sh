#!/bin/bash
echo -n "Please enter database passowrd for root user: "
read -s db_pwd
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -f -y
sudo apt-get auto-remove -y
echo -e "\Installing Git Software Control Management..."
sudo apt-get install -y git
echo -e "\nInstalling NGINX server...\n"
sudo apt-get install -y nginx
echo -e "\nAllowing NGINX through Firewall...\n"
sudo ufw allow 'Nginx HTTP'
sudo ufw status
echo -e "\nInstalling PHP7.1...\n"
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install -y php7.0 php7.0-fpm php7.0-mbstring php7.0-mcrypt php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dom php7.0-zip php7.0-bcmath php7.0-xml php7.0-json php7.0-mysql php7.0-common
sudo apt-get install -y php7.1 php7.1-fpm php7.1-mbstring php7.1-mcrypt php7.1-cgi php7.1-cli php7.1-common php7.1-curl php7.1-zip php7.1-bcmath php7.1-xml php7.1-json php7.1-mysql php7.1-common
sudo apt-get install -y php7.2 php7.2-fpm php7.2-mbstring php7.2-mcrypt php7.2-cgi php7.2-cli php7.2-common php7.2-curl php7.2-zip php7.2-bcmath php7.2-xml php7.2-json php7.2-mysql php7.2-common
sudo apt-get install -y php7.3 php7.3-fpm php7.3-mbstring php7.3-cgi php7.3-cli php7.3-common php7.3-curl php7.3-zip php7.3-bcmath php7.3-xml php7.3-json php7.3-mysql php7.3-common
echo -e "\nEnabling PHP Modules...\n"
sudo phpenmod mcrypt
sudo phpenmod mbstring
echo -e "\nConfiguring PHP Processor...\n"
sudo sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.1/fpm/php.ini
sudo service php7.3-fpm start
echo -e "\nAllowing user permission on webroot...\n"
sudo usermod -a -G www-data ubuntu
sudo chown -R $USER:www-data /var/www/html
echo -e "\Installing MariaDB Server..."
sudo apt-get install -y mariadb-server mariadb-client
sudo service mysql start
sudo mysql_secure_installation
sudo mysql -u root -Bse "
USE mysql;
UPDATE user SET plugin='' WHERE User='root';
GRANT USAGE ON mysql.* TO 'root'@'localhost' IDENTIFIED BY '"$db_pwd"';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
\q;
"
sudo service mysql restart
echo -e "\Installing Composer PHP Dependency Manager..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo -e "\nInsatlling phpMyAdmin..."
git clone https://github.com/phpmyadmin/phpmyadmin
cd phpmyadmin
git checkout STABLE
composer update
bash scripts/generate-mo
cd ..
sudo mv -f phpmyadmin/ /usr/share/phpmyadmin/
sudo cp -f /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
blowfish=`openssl rand -base64 32`;
sudo sed -i -e "s|\['blowfish_secret'\] = ''|['blowfish_secret'] = '"$blowfish"'|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\/\/ $cfg|$cfg|g" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\['controlhost'\] = '';|['controlhost'] = 'localhost';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\['controlport'\] = '';|['controlport'] = '3306';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\['controluser'\] = 'pma';|['controluser'] = 'pma';|" /usr/share/phpmyadmin/config.inc.php
sudo sed -i -e "s|\['controlpass'\] = 'pmapass';|['controlpass'] = 'toor';|" /usr/share/phpmyadmin/config.inc.php
sudo mysql -u root -p$db_pwd -Bse "
GRANT USAGE ON mysql.* TO 'pma'@'localhost' IDENTIFIED BY '"$db_pwd"';
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
FLUSH PRIVILEGES;
\q;
"
sudo service mysql restart
sudo cat > /etc/nginx/sites-available/default <<- "EOF"
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
        root /usr/share/;

        index index.php index.html index.htm;

        access_log /var/log/nginx/phpmyadmin_access.log;
        error_log /var/log/nginx/phpmyadmin_error.log;

        location ~ ^/phpmyadmin/(.+\.php)$ {
            try_files       $uri =404;
            root            /usr/share/;
            fastcgi_pass    unix:/run/php/php7.3-fpm.sock; # or 127.0.0.1:9000
            fastcgi_index   index.php;
            fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include         /etc/nginx/fastcgi_params;
        }

        location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
            root /usr/share/;
        }
    }

    location /phpMyAdmin {
           rewrite ^/* /phpmyadmin last;
    }
}
EOF
sudo chown -R $USER:www-data /var/www/html
sudo service nginx restart
