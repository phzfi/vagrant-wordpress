#!/bin/bash
echo 'CREATE DATABASE wp' | mysql -uroot --password="password"

mysql -u root -ppassword wp < /vagrant/wordpress_default.sql
echo 'GRANT ALL PRIVILEGES ON wp.* TO "wp"@"localhost" IDENTIFIED BY "password"' | mysql -uroot --password="password"
echo 'FLUSH PRIVILEGES' | mysql -uroot --password="password"

mysql -u root -ppassword wp < /vagrant/wordpress_default.sql
