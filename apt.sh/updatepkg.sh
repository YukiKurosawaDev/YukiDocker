#/bin/bash
apt update
apt upgrade -y
apt install ca-certificates -y
apt autoremove -y
apt clean
rm -rvf /var/lib/apt/lists/*

rm -vf /etc/apt/sources.list
mv /apt.sh/sources.list /etc/apt/sources.list

apt update
apt upgrade -y
apt autoremove -y
apt clean
rm -rvf /var/lib/apt/lists/*