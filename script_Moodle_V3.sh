#!/bin/bash
DEBIAN_FRONTEND=noninteractive
apt -y install php7.3 php7.3-{mysql,curl,gd,gmp,intl,xsl,xmlrpc,soap,zip,mbstring} memcached
apt -y install mariadb-server apache2 git net-tools dnsutils acl htop curl postfix mailutils
a2enmod ssl rewrite
systemctl restart apache2.service
rm /var/www/html/index.html
