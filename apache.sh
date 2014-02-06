#/bin/bash
# Instalacion de Apache
# Debian 7
clear
echo "Script instalador de Apache"
echo "Esta ejecutando el Scrip como root?"
echo "1 - Si"
echo "2 - No"
read respuesta
case $respuesta in
	1) echo "Instalando paquetes..."
	sleep 2
	apt-get install -y libapache2-mod-php5
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