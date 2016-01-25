#!/bin/bash

#Fix phpmyadmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password password' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password password' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password password' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
sudo aptitude -q -y install phpmyadmin

sudo locale-gen UTF-8

sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www
sudo mv /etc/apache2/sites-available /etc/apache2/sites-available.dpkg
sudo ln -fs /vagrant/etc/apache2/sites-available /etc/apache2/sites-available
sudo a2dissite 000-default
sudo a2ensite wordpress-vagrant.local

sudo a2enmod rewrite
sudo a2enmod headers
sudo apt-get install php5-sqlite

sudo service apache2 stop
# changing apache user to "vagrant" for multiplatform compliance for development
sudo sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/g' /etc/apache2/envvars
sudo sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/g' /etc/apache2/envvars
sudo chown vagrant:root /var/lock/apache2
if [ ! -x /etc/apache2/conf.d/SendFile ]; then
    echo "EnableSendfile off" > /tmp/SendFile
    sudo chown root:root /tmp/SendFile
    sudo mv /tmp/SendFile /etc/apache2/conf.d/SendFile
fi

sudo /etc/init.d/apache2 start

sudo service mysql restart

ln -sf /var/run/mysqld/mysqld.sock /tmp/mysql.sock
