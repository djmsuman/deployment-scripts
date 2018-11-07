#!/bin/bash
sudo apt-get install -y build-essential libssl-dev libffi-dev libgmp3-dev virtualenv python-pip libpq-dev python-dev
sudo mkdir -p /opt/enviromentpy
cd /opt/enviromentpy/
sudo chown $USER:root -R ./
sudo chmod 777 -R ./
virtualenv pgadmin4
cd pgadmin4
source bin/activate
wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.0/pip/pgadmin4-2.0-py2.py3-none-any.whl
pip install pgadmin4-2.0-py2.py3-none-any.whl
cd lib/python2.7/site-packages/pgadmin4/config.py lib/python2.7/site-packages/pgadmin4/config_local.py
echo "SERVER_MODE = False" >> lib/python2.7/site-packages/pgadmin4/config_local.py
cat >> pgAdmin4.sh <<- "EOF"
#!/bin/bash
source /opt/enviromentpy/pgadmin4/bin/activate
python /opt/enviromentpy/pgadmin4/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py & 
sleep 5; sensible-browser http://127.0.0.1:5050
EOF
cat >> pgAdmin4.desktop <<- "EOF"
[Desktop Entry]
Name=pgAdmin 4
Exec=/opt/enviromentpy/pgadmin4/pgAdmin4.sh
Icon=/opt/enviromentpy/pgadmin4/pgadmin.svg
Type=Application
Categories=Database;
Terminal=false
EOF
chmod a+x pgAdmin4.sh pgAdmin4.desktop
sudo cp -f pgAdmin4.desktop /usr/share/applications/
sudo chmod a+x /usr/share/applications/pgAdmin4.desktop
wget http://kiahosseini.github.io/assets/image/pgadmin4_install/pgadmin.svg
mkdir /var/lib/pgadmin
mkdir /var/log/pgadmin
sudo chmod 777 -R /var/lib/pgadmin
sudo chmod 777 -R /var/log/pgadmin
