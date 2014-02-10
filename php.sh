#/bin/bash
# Instalacion de PHP
# Debian 7
clear
echo "Script instalador de PHP para Moodle"
echo "Esta ejecutando el Scrip como root?"
echo "1 - Si"
echo "2 - No"
read respuesta
case $respuesta in
	1) echo "Instalando los paquetes necesarios..."
	sleep 2
	apt-get install -y \
	php-pear php5 php5-mysql php5-curl php5-gd php5-gmp \
	php5-intl php5-mcrypt php5-xsl php5-xmlrpc mcrypt libgd-tools
	echo "Instalacion terminada"
	sleep 1
	;;
	2) echo "Necesita ejecutar el script como root"
	sleep 2
	;;
	*) echo "Opcion no valida"
	sleep 2
	;;
esac