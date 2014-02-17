#!/bin/sh
# Script que valida que un usuario sea root
# Autor: Enrique Tezozomoc Perez Campos
# merrovingo@gmail.com
##############################################################
# 	Definicion de variables		#
ID_USUARIO=$(id -u)
ID_ROOT="0"
##############################################################
#	Main						#
##############################################################
echo "Script para validar el usuario"
echo "------------------------------"
echo "Comprobando..."
if test "$ID_USUARIO" = "$ID_ROOT"
	then
	echo "Todo correcto, eres root"
	echo "Tu ID es $ID_USUARIO"
	exit 0
else
	echo "No eres root"
	echo "Tu ID es $ID_USUARIO"
	exit 1
fi