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
	1) echo "Instalando algunas cosas necesarias..."
	apt-get install -y debconf-utils
	echo "Instalando mysql server..."
	sleep 1
	echo "mysql-server-5.5 mysql-server/root_password password prueba" > mysql.preseed
	echo "mysql-server-5.5 mysql-server/root_password_again password prueba" >> mysql.preseed
	cat mysql.preseed | debconf-set-selections
	apt-get install -y mysql-server
	rm mysql.preseed
	echo "Instalacion completa"
	sleep 1
	;;
	2) echo "Necesita ejecutar el script como root"
	sleep 2
	;;
	*) echo "Opcion no valida"
	sleep 2
	;;
esac