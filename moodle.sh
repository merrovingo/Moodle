#/bin/bash
# Instalacion de moodle y git
# Debian 7
clear
echo "Script instalador de Moodle"
echo "Esta ejecutando el Scrip como root?"
echo "1 - Si"
echo "2 - No"
read respuesta
case $respuesta in
	1) echo "Instalando Git..."
	sleep 2
	apt-get install -y git
	echo "Escriba el nombre para su curso de Moodle:"
	read curso
	mkdir /var/www/$curso
	cd /var/www/$curso
	echo "Clonando el repositorio de Git..."
	sleep 2
	git clone https://github.com/moodle/moodle.git
	# Falta seleccionar rama estable #
	echo "Creando moodledata..."
	mkdir /var/moodledata
	chmod 777 /var/moodledata
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