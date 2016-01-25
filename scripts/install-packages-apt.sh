#!/usr/bin/env bash

sed -i 's/\/archive.ubuntu.com/\/fi.archive.ubuntu.com/' /etc/apt/sources.list
sudo apt-get update
# debconf-utils offers a way of defining answers to interactive prompts
sudo apt-get -q -y install debconf-utils
sudo apt-get -q -y install aptitude
if [[ ! -f /etc/apt/sources.list.d/pkg.phz.fi.list ]]; then
     echo "deb http://pkg.phz.fi/precise ./" > /etc/apt/sources.list.d/pkg.phz.fi.list
fi
sudo apt-get update

#Set MySQL
echo 'mysql-server-5.5 mysql-server/root_password select password' | sudo debconf-set-selections
echo 'mysql-server-5.5 mysql-server/root_password_again select password' | sudo debconf-set-selections

#If MySQL is already installed, reset root password
TEST=`which mysqld |wc -l`
if [[ $TEST -gt 0 ]]; then
    sudo service mysql stop
    sleep 10
    sudo mysqld_safe --skip-grant-tables --skip-networking &
    sleep 10
    echo "UPDATE user SET password = PASSWORD('password') WHERE User='root'; FLUSH PRIVILEGES;" |mysql -u root mysql
    sudo mysqladmin shutdown
    sleep 10
    sudo service mysql start
fi

#Set Postgress
echo "postfix postfix/main_mailer_type select Satellite Site" | debconf-set-selections
echo "postfix postfix/mailname string localhost" | debconf-set-selections
echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections

#Set Snort
echo "snort	snort/address_range	string	10.0.0.0/8" | debconf-set-selections

#Set grub
dpkg-reconfigure -f noninteractive grub-pc

sudo apt-get -q -y upgrade
sudo apt-get -q -y --force-yes install phz-dev-common phz-dev-php

