#! /bin/bash

# INITIALIZE ENVIRONMENT
apt update

# INSTALL PACKAGES
apt install postgresql-14 postgresql-14-debversion -y
cp /dak.sh/postgresql.conf /etc/postgresql/14/main/postgresql.conf
cp /dak.sh/pg_hba.conf /etc/postgresql/14/main/pg_hba.conf

service postgresql restart
echo "ALTER USER postgres WITH PASSWORD 'postgres';"| su - postgres -c psql

apt install nginx -y

# CLEAN ENVIRONMENT
apt autoremove -y
apt clean
rm -rvf /var/lib/apt/lists/*