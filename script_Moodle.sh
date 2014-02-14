#!/bin/sh
# Script de instalacion de la plataforma Moodle
# El siguiente script instalara: Apache, MySQL, Git y Moodle
# Esta diseñado para funcionar con Debian 7 x86, x86_64
# Autor : Enrique Tezozomoc Perez Campos
# merrovingo@gmail.com
##########################################################################################################################
##########################################################################################################################
DEBIAN_FRONTEND=noninteractive
clear
##########################################################################################################################
##########################################################################################################################
#		Definicion de variables		#
#		Sientase libre de modificar las siguientes variables segun sus necesidades particulares		#
##########################################################################################################################
##########################################################################################################################
# 		Datos del virtualhost 				#
# Nombre del sitio
NOMBRE_SITIO="moodle"
# Correo electronico del administrador del sitio
APACHE_MAIL="curso@superserver.com"
# Nombre del servidor
APACHE_SERVER="superserver.com"
# Nombre del archivo de log de errores
APACHE_ERROR="moodle-error.log"
# Nombre del archivo de log de acceso al sitio
APACHE_ACCESS="moodle-acceso.log"
###########################################################################################################################
# 		Datos del curso de Moodle 			#
# Nombre del curso para Moodle
CURSO="diplomado_innovacion"
# Rama Moodle a utilizar
RAMA_MOODLE="MOODLE_26_STABLE"
############################################################################################################################
# 		Datos de configuracion de MySQL 	#
# Contraseña de root para MySQL
PASSWORD="moodle_secreto"
# Nombre de la base de datos para Moodle
BASE_MOODLE="moodle"
# Nombre de usuario MYSQL para Moodle
USR_MOODLE="usr_moodle"
# Contraseña para el usuario de MySQL de Moodle
PASSWORD_MOODLE="usuario_secreto"
############################################################################################################################
############################################################################################################################
#		Definicion de funciones		#
############################################################################################################################
############################################################################################################################
function script_apache(){
	echo "Instalando Apache..."
	apt-get install -y libapache2-mod-php5
	echo "Configurando el Virtualhost..."
	cd /etc/apache/sites-available && touch $NOMBRE_SITIO
	echo "<virtualhost *.80>" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "ServerAdmin '$APACHE_MAIL'" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "ServerName '$APACHE_SERVER'" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "ServerSignature Off" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "DocumentRoot /var/www/'$CURSO'/" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "<Directory /var/www/'$CURSO'/moodle>" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "Options -Indexes FollowSymLinks MultiViews" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "AllowOverride ALL" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "Order Allow, Deny" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "Allow From All" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "</Directory>" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "LogLevel warn" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "ErrorLog ${APACHE_LOG_DIR}/'$APACHE_ERROR'" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "CustomLog ${APACHE_LOG_DIR}/'$APACHE_ACCESS' combined" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "</virtualhost>" >> /etc/apache/sites-available/$NOMBRE_SITIO
	echo "Instalacion de Apache terminada"
}
function script_moodle(){
	echo "Instalando Git..."
	apt-get install -y git
	echo "Clonando Moodle este proceso puede tardar un poco..."
	mkdir /var/www/$CURSO
	cd /var/www/$CURSO
	git clone https://github.com/moodle/moodle.git
	echo "Cambiando a la rama '$RAMA_MOODLE'"
	git branch --track $RAMA_MOODLE origin/$RAMA_MOODLE
	echo "Creando moodledata..."
	mkdir /var/moodledata
	chmod 777 /var/moodledata
	echo "Instalacion de Moodle terminada"
}
function script_mysql(){
	echo "Instalando algunas cosas necesarias..."
	apt-get install -y debconf-utils
	echo "Instalando MySQL..."
	echo "mysql-server mysql-server/root_password password '$PASSWORD'" > mysql.preseed
	echo "mysql-server mysql-server/root_password_again password '$PASSWORD'" >> mysql.preseed
	cat mysql.preseed | debconf-set-selections
	apt-get install -y mysql-server
	rm mysql.preseed
	echo "Creando un usuario y una base de datos..."
	mysql -u root -p$PASSWORD -e "CREATE DATABASE '$BASE_MOODLE' CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	mysql -u root -p$PASSWORD -e "CREATE USER '$USR_MOODLE'@'localhost' IDENTIFIED BY '$PASSWORD_MOODLE';"
	mysql -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON '$BASE_MOODLE'.* TO '$USR_MOODLE'@'localhost'; FLUSH PRIVILEGES;"
	echo "Instalacion de MySQL terminada"
}
function script_php(){
	echo "Instalando PHP..."
	apt-get install -y \
	php-pear php5 php5-mysql php5-curl php5-gd php5-gmp \
	php5-intl php5-mcrypt php5-xsl php5-xmlrpc mcrypt libgd-tools
	echo "Instalacion de PHP terminada"
}
###########################################################################################################################
###########################################################################################################################
#		Main						#
###########################################################################################################################
###########################################################################################################################
echo "Script para la instalacion de Moodle"
echo "El siguiente script necesita ser ejecutado como root"
echo "Por favor autentifiquese..."
su
if [[ '$USERNAME' = "root" ]]; then
	script_apache
	script_php
	script_mysql
	script_moodle
	echo "Instalacion terminada"
else
	echo "Para realizar la instalacion de Moodle se necesitan realizar operaciones"
	echo "que requieren permisos de root, por favor intentelo nuevamente"
	sh script_Moodle.sh
fi