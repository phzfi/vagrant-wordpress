# vagrant-wordpress
Wordpress Vagrant

Username: admin
Password: password

MySQL password: root / password

Replace ip address in scripts and wp->wp_options where option_name = siteurl

Possibly install script to do that - need to change scripts and base dump

NOTE
  If vagrantbox does not work with default IP 192.168.66.66 you have
  to change IP to some another in Vagrantfile.
  
  If you change the IP, you will see that Wordpress site is totally
  crashed and links won't point to correct URL. To fix this, you must
  update database in Vagrant like this:
  
  update wp_options set option_value="http://wordpress-vagrant.local/wordpress" where option_id in(1,2);

  If you use that, be sure to set /etc/hosts correctly outside the
  vagrantbox (add wordpress-vagrant.local there).
