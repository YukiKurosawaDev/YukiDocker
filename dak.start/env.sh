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

USER_CMD="sudo -E -u dak -s -H"
DAK="$USER_CMD /srv/dak/bin/dak"
APT="$USER_CMD apt download"
APTS="$USER_CMD apt source"
DI="$DAK import -s jammy main "


cd /home/dak

OK=0
ALL=1
BTITLE="Add Packages to DAK"
TITLE="Importing Packages"

function add_source()
{
    SHOW_MIXPROGRESS "Download source $1 ... " "PROCESSING" "Import source $1 ... " "WAITING"
    $APTS $1 1>/dev/null 2>&1
    SHOW_MIXPROGRESS "Download source $1 ... " "DONE" "Import source $1 ... " "WAITING"
    
    SHOW_MIXPROGRESS "Download source $1 ... " "DONE" "Import source $1 ... " "PROCESSING"
    $DI *.dsc
    
    SHOW_MIXPROGRESS "Download source $1 ... " "DONE" "Import source $1 ... " "DONE"
    rm -rvf *.* 1>/dev/null 2>&1
    OK=$[$OK+1]
    sleep 1
}

function add_package()
{
    SHOW_MIXPROGRESS "Download package $1 ... " "PROCESSING" "Import package $1 ... " "WAITING"
    $APT $1 1>/dev/null 2>&1
    DEBO=$(ls *.deb)

    #echo $DEBO
    DEB=$(echo $DEBO| sed -e s/%3a/-/)
    #echo $DEB
    mv $DEBO $DEB 1>/dev/null 2>&1
    cp $DEB /test.tmp/$DEB

    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Import package $1 ... " "PROCESSING"
    $DI *.deb
    SHOW_MIXPROGRESS "Download package $1 ... " "DONE" "Import package $1 ... " "DONE"
    rm -rvf *.* 1>/dev/null 2>&1
    OK=$[$OK+1]
    sleep 1
}

add_source $1
add_package $1


BTITLE="Add Packages to DAK"
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

cp -r /test.tmp /test/pkgs
arch-chroot /test /bin/bash -c "apt --allow-unauthenticated update && apt --allow-unauthenticated install $2"