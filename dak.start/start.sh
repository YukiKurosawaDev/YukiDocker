#! /bin/bash
service postgresql start
service nginx start


USER_CMD="sudo -E -u dak -s -H"
DAK="$USER_CMD /srv/dak/bin/dak"
APT="$USER_CMD apt download"
APTS="$USER_CMD apt source"
DI="$DAK import -s jammy main "

apt update 1>/dev/null 2>&1

cd /home/dak

function add_package()
{
    echo -n "IMPORTING $1 ... "
    $APT $1 1>/dev/null 2>&1
    $APTS $1 1>/dev/null 2>&1
    DEBO=$(ls *.deb)
    #echo $DEBO
    DEB=$(echo $DEBO| sed -e s/%3a/-/)
    #echo $DEB
    mv $DEBO $DEB 1>/dev/null 2>&1
    $DI *.dsc
    $DI *.deb
    rm -rvf *.* 1>/dev/null 2>&1
    echo "DONE"
}

add_package base-files

add_package libc6
add_package libc-bin

add_package bash
add_package dash
add_package libtinfo6

add_package coreutils

add_package mount
add_package libmount1
add_package libblkid1

add_package dpkg
add_package libselinux1
add_package zlib1g
add_package libpcre2-8-0
add_package libzstd1
add_package liblzma5
add_package libbz2-1.0

add_package tar
add_package libacl1

add_package diffutils

add_package apt

add_package adduser


$DAK generate-packages-sources2 1>/dev/null 2>&1
$DAK generate-release 1>/dev/null 2>&1

debootstrap --no-check-gpg jammy /test file:///srv/dak/ftp

chroot /test /bin/bash

nano /test/debootstrap/debootstrap.log

/bin/bash