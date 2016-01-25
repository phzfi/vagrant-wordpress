mkdir /vagrant/downloads
cd /vagrant/downloads
wget -nc http://wordpress.org/latest.zip
wget -nc https://downloads.wordpress.org/plugin/si-captcha-for-wordpress.zip
wget -nc https://downloads.wordpress.org/plugin/wordpress-seo.1.7.3.3.zip
wget -nc https://downloads.wordpress.org/plugin/ultimate-google-analytics.zip
wget -nc https://downloads.wordpress.org/plugin/wp-to-twitter.3.0.0.zip

mkdir /vagrant/public_html

unzip latest.zip -d /vagrant/public_html/

for zip in $(ls|grep .zip |grep -v latest)
do
  unzip $zip -d /vagrant/public_html/wordpress/wp-content/plugins/
done

cp /vagrant/public_html/wordpress/wp-config-sample.php /vagrant/public_html/wordpress/wp-config.php

sed -i 's/database_name_here/wp/g' /vagrant/public_html/wordpress/wp-config.php
sed -i 's/username_here/wp/g' /vagrant/public_html/wordpress/wp-config.php
sed -i 's/password_here/password/g' /vagrant/public_html/wordpress/wp-config.php



sudo sed -i.bkup 's/^upload_max_filesize =.*/upload_max_filesize = 200M/g' /etc/php5/apache2/php.ini
sudo sed -i.bkup2 's/^post_max_size =.*/post_max_size = 200M/g' /etc/php5/apache2/php.ini
sudo sed -i.bkup3 's/^file_uploads =.*/file_uploads = on/g' /etc/php5/apache2/php.ini
sudo sed -i.bkup4 's/^memory_limit =.*/memory_limit = 512M/g' /etc/php5/apache2/php.ini

#permissions

cd ../public_html
sudo chown -R :www-data .
cd wordpress
sudo chmod g+w wp-config.php
sudo chmod o-rwx wp-config.php
sudo mkdir wp-content/uploads
sudo chown :www-data wp-content/uploads
sudo chmod g+w wp-content/uploads


sudo rm -r /var/www
sudo ln -s /vagrant/public_html/wordpress /var/www
