#!/bin/bash

# 					### Сборка проекта esr10/12V ###

# $1 -	директория, в которую перейти для сборки
# $2 -	в качестве параметра необходимо передать config esr 
# 		для которого планируете осуществлять сборку (config-esr10; config-esr12V)
# $3 -	какую сборку необходимо выполнить

cd $1
make clean
make unconfig
make $2
if [[ $? != 0 ]] ; then
	echo "ERROR: input configuration with build esr: config-esr10 or config-esr12V"
	exit 1
fi
make uboot
if [[ $? != 0 ]] ; then
	echo "ERROR uboot"
	exit 1
elif [[ $3 == 1 ]] ; then
	echo "UBOOT DONE"
	exit 0
fi
make linux-userspace
if [[ $? != 0 ]] ; then
	echo "ERROR linux-userspace"
	exit 1
elif [[ $3 == 2 ]] ; then
	echo "KERNEL DONE"
	exit 0
fi
make apps-all
if [[ $? -eq 0 ]] ; then 
	make firmware-initramfs
else
	make apps-all
	if [[ $? -eq 0 ]] ; then 
		make firmware-initramfs
	else
		make apps-all
		if [[ $? -eq 0 ]] ; then 
			make firmware-initramfs
		fi
	fi
fi

echo "BUILD ESR DONE"
exit 0
