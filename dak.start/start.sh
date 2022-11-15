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
mkdir /test.tmp

function add_package()
{
    echo -n "IMPORTING $1 ... "
    $APT $1 1>/dev/null 2>&1
    $APTS $1 1>/dev/null 2>&1
    DEBO=$(ls *.deb)
    echo $DEBO
    DEB=$(echo $DEBO| sed -e s/%3a/-/)
    #echo $DEB
    mv $DEBO $DEB 1>/dev/null 2>&1
    cp $DEB /test.tmp/$DEB
    $DI *.dsc
    $DI *.deb
    rm -rvf *.* 1>/dev/null 2>&1
    echo "DONE"
}

add_package	adduser
add_package	apt
add_package	base-files
add_package	bash
add_package	coreutils
add_package	dash
add_package	debconf
add_package	debianutils
add_package	diffutils
add_package	dpkg
add_package	gawk
add_package	gcc-12-base
add_package	gpg
add_package	libacl1
add_package	libapt-pkg6.0
add_package	libattr1
add_package	libaudit1
add_package	libblkid1
add_package	libbz2-1.0
add_package	libc6
add_package	libc-bin
add_package	libcrypt1
add_package	libgcc-s1
add_package	libgcrypt20
add_package	libgmp10
add_package	libgnutls30
add_package	libgpg-error0
add_package	liblz4-1
add_package	liblzma5
add_package	libmount1
add_package	libpam0g
add_package	libpam-modules
add_package	libpcre2-8-0
add_package	libseccomp2
add_package	libselinux1
add_package	libsemanage2
add_package	libstdc++6
add_package	libsystemd0
add_package	libtinfo6
add_package	libzstd1
add_package	mount
add_package	ncurses-bin
add_package	passwd
add_package	perl-base
add_package	sed
add_package	tar
add_package	ubuntu-keyring
add_package	zlib1g
add_package libcap2
add_package libxxhash0
add_package libp11-kit0
add_package libidn2-0
add_package libunistring2
add_package libtasn1-6
add_package libnettle8
add_package libhogweed6
add_package libffi8
add_package gpgconf
add_package libassuan0
add_package libreadline8
add_package libsqlite3-0
add_package libaudit-common
add_package libcap-ng0
add_package libsemanage-common
add_package libsepol2
add_package libdb5.3
add_package libtirpc3
add_package libpam-modules-bin
add_package libudev1
add_package bash-completion
add_package readline-common
add_package libgssapi-krb5-2
add_package libtirpc-common
add_package libnsl2
add_package libcom-err2
add_package libk5crypto3
add_package libkrb5-3
add_package libkrb5support0
add_package libkeyutils1
add_package libssl3
add_package libmpfr6
add_package libsigsegv2
add_package libterm-readkey-perl
add_package libterm-readline-perl-perl
add_package perl
add_package libperl5.34
add_package perl-modules-5.34
add_package libgdbm-compat4
add_package libgdbm6
add_package grep
add_package libpcre3
add_package libsmartcols1
add_package base-passwd
add_package libdebconfclient0
add_package mawk
add_package init-system-helpers
add_package gpgv

$DAK generate-packages-sources2 1>/dev/null 2>&1
$DAK generate-release 1>/dev/null 2>&1

debootstrap --no-check-gpg jammy /test http://localhost/kslinux
cp -r /test.tmp /test/pkgs

# cat > /test1/etc/passwd << "EOF"
# root:x:0:0:root:/root:/bin/bash
# bin:x:1:1:bin:/dev/null:/usr/bin/false
# daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
# messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
# uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
# nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
# EOF

# cat > /test1/etc/group << "EOF"
# root:x:0:
# bin:x:1:daemon
# sys:x:2:
# kmem:x:3:
# tape:x:4:
# tty:x:5:
# daemon:x:6:
# floppy:x:7:
# disk:x:8:
# lp:x:9:
# dialout:x:10:
# audio:x:11:
# video:x:12:
# utmp:x:13:
# usb:x:14:
# cdrom:x:15:
# adm:x:16:
# messagebus:x:18:
# input:x:24:
# mail:x:34:
# kvm:x:61:
# uuidd:x:80:
# wheel:x:97:
# users:x:999:
# nogroup:x:65534:
# EOF

# touch /test/etc/shadow

chroot /test /bin/bash

#nano /test/debootstrap/debootstrap.log

/bin/bash