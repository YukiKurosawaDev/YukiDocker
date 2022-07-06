#! /bin/bash

# INITIALIZE ENVIRONMENT
echo -n UPDATING PACKAGE LISTS ... 
apt update 1>/dev/null 2>&1
echo DONE

# INSTALL PACKAGES
echo -n INSTALLING postgresql ...
apt install postgresql-14 postgresql-14-debversion -y 1>/dev/null 2>&1
echo DONE

echo -n CONFIGURING postgresql ...
cp /dak.sh/postgresql.conf /etc/postgresql/14/main/postgresql.conf 1>/dev/null 2>&1
cp /dak.sh/pg_hba.conf /etc/postgresql/14/main/pg_hba.conf 1>/dev/null 2>&1
echo DONE

echo -n RESTARTING postgresql ...
service postgresql restart 1>/dev/null 2>&1
echo DONE

echo -n CHANGING postgresql SUPER PASSWORD ...
echo "ALTER USER postgres WITH PASSWORD 'postgres';"| su - postgres -c psql
echo DONE

echo -n INSTALLING nginx ...
apt install nginx -y 1>/dev/null 2>&1
echo DONE

# CLEAN ENVIRONMENT
echo -n REMOVING TEMP FILES ...
apt autoremove -y 1>/dev/null 2>&1
apt clean 1>/dev/null 2>&1
rm -rvf /var/lib/apt/lists/* 1>/dev/null 2>&1
echo DONE
