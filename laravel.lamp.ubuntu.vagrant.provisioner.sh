#!/bin/bash
echo -e "\nLaunching setup script"
echo -e "\nUpdating Ubuntu Software Repsoitory\n"
sudo apt-get -y update
echo -e "\nInstalling updates\n"
sudo apt-get -y upgrade
echo -e "\nUpgrading...\n"
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
echo -e "\nInstalling Apache2\n"
sudo apt-get -y install apache2
echo -e "\nRestarting Apache2\n"
sudo systemctl restart apache2
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

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

EOF
echo -e "\nEnabling PHP Modules\n"
sudo phpenmod mcrypt
sudo phpenmod mbstring
echo -e "\nEnabling Apache2 Rewrite Module\n"
sudo a2enmod rewrite
echo -e "\nRestarting Apache2\n"
sudo systemctl restart apache2
sudo systemctl status apache2
echo -e "\nInstalling \"Composer\" Globally\n"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo rm -r /var/www/html
# To install a new Laravel project
# echo -e "\nCrafting new Laravel Project\n"
# sudo composer create-project --prefer-dist laravel/laravel /var/www/html
# mv /var/www/html/* /var/www
# mv /var/www/html/.* /var/www
cd /var/www/app
echo -e "\nUpdating Project Dependencies...\n"
sudo composer update
echo -e "\n\t\tInitialization Complete! \n\t\t========================\n\nTo enter into your newly created vagrant environment please run \n\t\"vagrant ssh\"\nThen do\n\t\"cd /var/www/scripts\"\nand run\n\t\"sudo bash setup <project_name> <db_username> <db_password>\"\nor\n\t\"sudo ./setup <project_name> <db_username> <db_password>\"\n"
