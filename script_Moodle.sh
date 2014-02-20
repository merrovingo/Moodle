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
# 		Validacion de usuario 		#
# Comprobar que el ID del usuario corresponde a root 	#
ID_USUARIO=$(id -u)
ID_ROOT="0"
##########################################################################################################################
# 		Datos del virtualhost 				#
# Nombre del sitio
NOMBRE_SITIO="moodle"
# Correo electronico del administrador del sitio
APACHE_MAIL="curso@superserver.com"
# Nombre del servidor
APACHE_SERVER="superserver.com"
# Nombre del archivo de log de errores de Apache
APACHE_ERROR="moodle-error.log"
# Nombre del archivo de log de acceso al sitio de Apache
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
############################################################################################################################
############################################################################################################################
#		Definicion de funciones		#
############################################################################################################################
############################################################################################################################
script_apache () {
	echo "Instalando Apache..."
	sleep 3
	apt-get install -y libapache2-mod-php5
	echo "Configurando el Virtualhost..."
	sleep 3
	mkdir /var/www/$CURSO
	cd /etc/apache2/sites-available && touch $NOMBRE_SITIO
	echo "<virtualhost *.80>" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "ServerAdmin $APACHE_MAIL" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "ServerName $APACHE_SERVER" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "ServerSignature Off" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "DocumentRoot /var/www/$CURSO/" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "<Directory /var/www/$CURSO/moodle>" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "Options -Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "AllowOverride ALL" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "Order Allow, Deny" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "Allow From All" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "</Directory>" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "LogLevel warn" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "ErrorLog ${APACHE_LOG_DIR}/$APACHE_ERROR" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "CustomLog ${APACHE_LOG_DIR}/$APACHE_ACCESS combined" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "</virtualhost>" >> /etc/apache2/sites-available/$NOMBRE_SITIO
	echo "Activando el virtualhost..."
	sleep 3
	a2ensite $NOMBRE_SITIO
	echo "Reiniciando Apache..."
	sleep 3
	/etc/init.d/apache2 restart
	echo "Instalacion de Apache terminada"
	sleep 5
}
script_moodle () {
	echo "Instalando Git..."
	sleep 3
	apt-get install -y git
	echo "Clonando Moodle este proceso puede tardar un poco..."
	sleep 3
	cd /var/www/$CURSO
	git clone https://github.com/moodle/moodle.git
	echo "Cambiando a la rama $RAMA_MOODLE"
	sleep 3
	cd /var/www/$CURSO/moodle
	git branch --track $RAMA_MOODLE origin/$RAMA_MOODLE
	echo "Creando moodledata..."
	sleep 3
	mkdir /var/moodledata
	chmod 777 /var/moodledata
	echo "Instalacion de Moodle terminada"
	sleep 5
}
script_mysql () {
	echo "Instalando algunas cosas necesarias..."
	sleep 3
	apt-get install -y debconf-utils
	echo "Instalando MySQL..."
	sleep 3
	echo "mysql-server mysql-server/root_password password $PASSWORD" > mysql.preseed
	echo "mysql-server mysql-server/root_password_again password $PASSWORD" >> mysql.preseed
	cat mysql.preseed | debconf-set-selections
	apt-get install -y mysql-server
	rm mysql.preseed
	echo "Creando un usuario y una base de datos..."
	sleep 3
	mysql -u root -p$PASSWORD -e "CREATE DATABASE $BASE_MOODLE CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	mysql -u root -p$PASSWORD -e "CREATE USER usuario_moodle@'localhost' IDENTIFIED BY 'secreto';"
	mysql -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON $BASE_MOODLE.* TO usuario_moodle@'localhost'; FLUSH PRIVILEGES;"
	echo "Instalacion de MySQL terminada"
	sleep 5
}
script_php () {
	echo "Instalando PHP..."
	sleep 3
	apt-get install -y \
	php-pear php5 php5-mysql php5-curl php5-gd php5-gmp \
	php5-intl php5-mcrypt php5-xsl php5-xmlrpc mcrypt libgd-tools
	echo "Instalacion de PHP terminada"
	sleep 5
}
###########################################################################################################################
###########################################################################################################################
#		Main						#
###########################################################################################################################
###########################################################################################################################
echo "Bienvenido al Script para la instalacion de Moodle"
echo "----------------------------------------------------"
echo "El siguiente script necesita ser ejecutado como root"
echo "Comprobando identidad..."
if test "$ID_USUARIO" = "$ID_ROOT"
then
	echo "Todo correcto, la instalacion comenzara ahora..."
	script_apache 2>&1	| tee -a script_moodle.log
	script_php 2>&1		| tee -a script_moodle.log
	script_mysql 2>&1 	| tee -a script_moodle.log
	script_moodle 2>&1	| tee -a script_moodle.log
	echo "Instalacion terminada"
	echo "El nombre del archivo de logs es: script_moodle.log"
	exit 0
else
	echo "Para realizar la instalacion de Moodle se necesitan permisos de root"
	echo "Por favor intentelo nuevamente con el siguiente comando ##su -c 'sh script_Moodle.sh'##"
	exit 1
fi