#!/bin/bash
apt -y install php7.3 php7.3-{pear,mysql,curl,gd,gmp,intl,xsl,xmlrpc,soap,zip,memcached}
apt -y install mariadb-server apache2 git net-tools dnsutils
a2enmod ssl rewrite
systemctl restart apache2.service
rm /var/www/html/index.html