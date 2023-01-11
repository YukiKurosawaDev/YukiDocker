#! /bin/bash

# INITIALIZE ENVIRONMENT
echo -n "UPDATING PACKAGE LISTS ... "
apt update 1>/dev/null 2>&1
echo DONE

# INSTALL PACKAGES
echo -n "INSTALLING postgresql ... "
apt install postgresql-14 postgresql-14-debversion postgresql-client-14 -y 1>/dev/null 2>&1
echo DONE

echo -n "CONFIGURING postgresql ... "
cp /dak.sh/postgresql.conf /etc/postgresql/14/main/postgresql.conf 1>/dev/null 2>&1
cp /dak.sh/pg_hba.conf /etc/postgresql/14/main/pg_hba.conf 1>/dev/null 2>&1
echo DONE

echo -n "RESTARTING postgresql ... "
service postgresql restart 1>/dev/null 2>&1
echo DONE

echo -n "CHANGING postgresql SUPER PASSWORD ... "
echo "ALTER USER postgres WITH PASSWORD 'postgres';"| su - postgres -c psql 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING nginx ... "
apt install nginx -y 1>/dev/null 2>&1
cat /dak.sh/nginx.conf > /etc/nginx/nginx.conf
echo DONE

echo -n "INSTALLING git ... "
apt install git -y 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING sudo ... "
apt install sudo -y 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING nano ... "
apt install nano -y 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING dialog ... "
apt install dialog -y 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING debootstrap ... "
apt install debootstrap -y 1>/dev/null 2>&1
echo DONE

echo -n "INSTALLING dak Dependencies ... "
apt install python3-psycopg2 python3-pip python3-apt gnupg dpkg-dev lintian \
binutils-multiarch python3-yaml less python3-ldap python3-pyrss2gen python3-rrdtool \
symlinks python3-debian python3-debianbts python3-tabulate -y 1>/dev/null 2>&1
mkdir ~/.pip/ 1>/dev/null 2>&1
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
EOF
pip install SQLAlchemy==1.3.24 1>/dev/null 2>&1
echo DONE

# CLEAN ENVIRONMENT
echo -n "REMOVING TEMP FILES ... "
apt autoremove -y 1>/dev/null 2>&1
apt clean 1>/dev/null 2>&1
rm -rvf /var/lib/apt/lists/* 1>/dev/null 2>&1
echo DONE
