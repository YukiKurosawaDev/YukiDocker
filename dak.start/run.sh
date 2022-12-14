#! /bin/sh
dialog --backtitle "Welcome" --menu "Please Choose your option to start" 5 0 1 "dak" "Bootstrap dak envrionment" "bash" "Bash shell" 2>choose

choose=$(cat choose);

if [ "x$choose" = "x" ]; then
    false
fi

if [ "x$choose" = "xbash" ]; then
    clear
    /bin/bash
fi

if [ "x$choose" = "xdak" ]; then
    clear
    /dak.start/start.sh
fi