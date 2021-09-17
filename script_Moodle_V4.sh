#!/bin/bash
# Debian 11
apt -y install php7.4 php7.4-{mysql,curl,gd,gmp,intl,xsl,xmlrpc,soap,zip} memcached
apt -y install mariadb-server apache2 git net-tools dnsutils acl htop curl postfix mailutils
a2enmod ssl rewrite
systemctl restart apache2.service
rm /var/www/html/index.html
