#/bin/bash
# Instalacion de mysql
# Debian 7
clear
echo "Script instalador de mysql"
echo "Esta ejecutando el Scrip como root?"
echo "1 - Si"
echo "2 - No"
read respuesta
case $respuesta in
	1) echo "Ingrese su contraseña de root para mysql:"
	read pass
	echo "Instalando mysql server..."
	sleep 1
	export DEBIAN_FRONTEND=noninteractive
	export pass
	apt-get install -y -q mysql-server
	mysqladmin -u root password $pass
	echo "A continuacion crearemos un usuario mysql para moodle"
	echo "Ingrese el nombre de usuario:"
	read usuariodb
	echo "Ingrese una contraseña:"
	read passuser
	mysql -u root -p$pass -e "CREATE USER $usuariodb@'localhost' IDENTIFIED BY '$passuser';"
	echo "A continuacion crearemos una bd para moodle"
	echo "Ingrese el nombre que desea para la bd:"
	read nombrebd
	mysql -u root -p -e "CREATE DATABASE $nombrebd CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	mysql -u root -p -e "GRANT ALL PRIVILEGES ON $nombrebd.* TO $usuariodb@'localhost';"
	mysql -u root -p -e "FLUSH PRIVILEGES;"
	clear
	echo "Instalacion terminada"
	echo "Resumen de la instalacion:"
	echo "Su contraseña de root es: " $pass
	echo "Su nombre de usuario es: " $usuariodb
	echo "La contraseña para $usuariodb es: " $passuser
	echo "La base de datos creada para moodle es: " $nombrebd
	sleep 1
	;;
	2) echo "Necesita ejecutar el script como root"
	sleep 2
	;;
	*) echo "Opcion no valida"
	sleep 2
	;;
esac