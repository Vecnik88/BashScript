#!/bin/bash

# 					### Сборка проекта esr100/200/1000/1200 ###

# $1 -	директория, в которую перейти для сборки
# $2 -	в качестве параметра необходимо передать config esr 
# 		для которого планируете осуществлять сборку (config-esr100; config-esr200; config-esr1000; config-esr1200)
# $3 -	какую сборку необходимо выполнить

cd $1
make clean
make unconfig
make $2
if [[ $? != 0 ]] ; then
	echo "ERROR: input configuration with build esr: config-esr10 or config-esr12V"
	exit 1
elif [[ $3 == 1 ]] ; then
	make xloader
fi

if [[ $? != 0 ]] ; then
	echo "ERROR: x-loader"
	exit 1
elif [[ $3 == 1 ]] ; then
	make uboot
fi

if [[ $? != 0 ]] ; then
	echo "ERROR: uboot"
	exit 1
elif [[ $3 == 1 ]] ; then
	make sysconfig
fi

if [[ $? != 0 ]] ; then
	echo "ERROR: sysconfig"
	exit 1
fi

make linux-userspace
if [[ $? != 0 ]] ; then
	echo "ERROR: linux-userspace"
	exit 1
fi

make apps-all
if [[ $? -eq 0 ]] ; then 
	make apps-fs
else
	make apps-all
	if [[ $? -eq 0 ]] ; then 
		make apps-fs
	else
		make apps-all
		if [[ $? -eq 0 ]] ; then 
			make apps-fs
		fi
	fi
fi

make fs
if [[ $? != 0 ]] ; then
	echo "ERROR: fs"
	exit 1
fi

echo "BUILD ESR DONE"
exit 0
