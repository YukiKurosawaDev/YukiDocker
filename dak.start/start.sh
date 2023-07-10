#! /bin/bash


SHOW_PROGRESS(){
 if [ -f /usr/bin/dialog ];then
  echo $[$OK*100/$ALL]|dialog --backtitle "$BTITLE" --title "$TITLE" --gauge "$1" 8 50 $[$OK*100/$ALL] 2>/dev/null
  sleep 1
 else
  echo "$1 $2"
 fi
}

SHOW_MIXPROGRESS(){
 if [ -f /usr/bin/dialog ];then
  dialog --backtitle "$BTITLE" --title "$TITLE" --mixedgauge "" 0 0 "$[$OK*100/$ALL]" "$@" 2>/dev/null
  sleep 1
 else
  echo "$1"
 fi
}

# Starting Service ...
OK=0
ALL=2

BTITLE="Environment Preparation"
TITLE="Starting Services"

SHOW_PROGRESS "Starting Postgresql ..."
service postgresql start 1>/dev/null 2>&1
OK=$[$OK+1]

SHOW_PROGRESS "Starting Nginx ..."
service nginx start 1>/dev/null 2>&1
OK=$[$OK+1]

sleep 1
clear

# Updating Package Source

USER_CMD="sudo -E -u dak -s -H"
DAK="$USER_CMD /srv/dak/bin/dak"
APT="$USER_CMD apt download"
APTS="$USER_CMD apt source"
DI="$DAK import -s jammy main "

OK=0
ALL=1

BTITLE="Environment Preparation"
TITLE="Updating Package Catalogs"

SHOW_PROGRESS "Updating Catelogs ..."
apt update 1>/dev/null 2>&1
OK=$[$OK+1]

sleep 1
clear

cd /home/dak
mkdir /test.tmp

OK=0
ALL=$(cat /etc/apt/sources.list | wc -l)
BTITLE="Bootstrap Packages to DAK"
TITLE="Importing Packages"

function add_package()
{
    SHOW_MIXPROGRESS "Download package $1 ... " "PROCESSING" "Download source $1 ... " "WAITING" "Import source $1 ... " "WAITING" "Import package $1 ... " "WAITING"
    $APT $1 1>/dev/null 2>&1
    DEBO=$(ls *.deb)

    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Download source $1 ... " "PROCESSING" "Import source $1 ... " "WAITING" "Import package $1 ... " "WAITING"
    $APTS $1 1>/dev/null 2>&1
    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Download source $1 ... " "DONE" "Import source $1 ... " "WAITING" "Import package $1 ... " "WAITING"
    
    #echo $DEBO
    DEB=$(echo $DEBO| sed -e s/%3a/-/)
    #echo $DEB
    mv $DEBO $DEB 1>/dev/null 2>&1
    cp $DEB /test.tmp/$DEB

    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Download source $1 ... " "DONE" "Import source $1 ... " "PROCESSING" "Import package $1 ... " "WAITING"
    $DI *.dsc
    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Download source $1 ... " "DONE" "Import source $1 ... " "DONE" "Import package $1 ... " "PROCESSING"
    $DI *.deb
    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Download source $1 ... " "DONE" "Import source $1 ... " "DONE" "Import package $1 ... " "DONE"
    rm -rvf *.* 1>/dev/null 2>&1
    OK=$[$OK+1]
    sleep 1
}

bash bootstrap.sh

BTITLE="Bootstrap Packages to DAK"
TITLE="Finalizing Repository"
OK=0
ALL=2

SHOW_MIXPROGRESS "Generate Package Source $1 ... " "PROCESSING" "Generate Repo Release $1 ... " "WAITING"
$DAK generate-packages-sources2 1>/dev/null 2>&1
OK=$[$OK+1]
SHOW_MIXPROGRESS "Generate Package Source $1 ... " "DONE" "Generate Repo Release $1 ... " "PROCESSING"
$DAK generate-release 1>/dev/null 2>&1
OK=$[$OK+1]
SHOW_MIXPROGRESS "Generate Package Source $1 ... " "DONE" "Generate Repo Release $1 ... " "DONE"

clear


debootstrap --no-check-gpg jammy /test http://localhost/kslinux
cp -r /test.tmp /test/pkgs
cp /dak.dev/keys/.no-key.gpg /test/etc/apt/trusted.gpg.d/no-key.gpg

mkdir -p /run/shm

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

arch-chroot /test /bin/bash

#nano /test/debootstrap/debootstrap.log

/bin/bash