#!/bin/bash
#===============================================================================
#
#          FILE:  node.ubuntu.bash
#
#         USAGE:  ./node.ubuntu.bash
#
#   DESCRIPTION: Node Installer Script and also install popular package manager,
#                dependency managers, bundlers etc.
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
echo -e "\nInstalling Node.JS & NPM...\n"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install npm
sudo npm install --global npm
sudo npm install --global n
sudo n stable
sudo ln -sf /usr/local/bin/node /usr/bin/nodejs
echo -e "\nInstalling Dependency Managers...\n"
sudo npm install --global bower yarn
echo -e "\nInstalling Task Runners and Dependency Bundlers...\n"
sudo npm install --global gulp grunt webpack browserify
