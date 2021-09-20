#!/bin/bash
DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "postfix postfix/mailname string sitio.com"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt -y install php7.3 php7.3-{mysql,curl,gd,gmp,intl,xsl,xmlrpc,soap,zip,mbstring} memcached
apt -y install mariadb-server apache2 git net-tools dnsutils acl htop screen curl postfix mailutils
a2enmod ssl rewrite
systemctl restart apache2.service
rm /var/www/html/index.html
