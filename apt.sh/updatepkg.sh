#/bin/bash

echo -n UPDATING PACKAGE LISTS ... 
apt update 1>/dev/null 2>&1
echo DONE

echo -n INSTALLING ca-certificates ...
apt install ca-certificates -y 1>/dev/null 2>&1
echo DONE

echo -n REMOVING TEMP FILES ...
apt clean 1>/dev/null 2>&1
rm -rvf /var/lib/apt/lists/* 1>/dev/null 2>&1
echo DONE

echo -n CHANGING PACKAGE SOURCES ...
rm -vf /etc/apt/sources.list 1>/dev/null 2>&1
mv /apt.sh/sources.list /etc/apt/sources.list 1>/dev/null 2>&1
echo DONE

echo -n UPDATING PACKAGE LISTS AND PACKAGES ...
apt update 1>/dev/null 2>&1
apt upgrade -y 1>/dev/null 2>&1
echo DONE

echo -n REMOVING TEMP FILES AGAIN ...
apt autoremove -y 1>/dev/null 2>&1
apt clean 1>/dev/null 2>&1
rm -rvf /var/lib/apt/lists/* 1>/dev/null 2>&1
echo DONE
