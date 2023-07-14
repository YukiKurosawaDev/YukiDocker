#! /bin/bash

echo -n "STARTING postgresql ... "
service postgresql restart 1>/dev/null 2>&1
echo DONE

echo -n "STARTING nginx ... "
service nginx restart 1>/dev/null 2>&1
echo DONE

echo -n "DOWNLOADING dak ... "
cd /
git clone https://salsa.debian.org/ftp-team/dak.git 1>/dev/null 2>&1
chmod -Rv 0777 dak 1>/dev/null 2>&1 
echo DONE

echo -n "CONFIGURING dak ... "
sudo addgroup ftpmaster 1>/dev/null 2>&1
sudo adduser dak --disabled-login --ingroup ftpmaster --shell /bin/bash --gecos "" 1>/dev/null 2>&1
sudo mkdir /etc/dak 1>/dev/null 2>&1
sudo mkdir /srv/dak 1>/dev/null 2>&1
sudo mkdir /srv/dak/etc 1>/dev/null 2>&1
sudo mkdir -p /srv/dak/keyrings/s3kr1t/dot-gnupg
sudo ln -s /srv/dak/etc/dak.conf /etc/dak/dak.conf 1>/dev/null 2>&1
chown -Rv dak:ftpmaster /srv/dak 1>/dev/null 2>&1
cd /dak
setup/dak-setup.sh 1>/dev/null 2>&1
echo 'export PATH="/srv/dak/bin:${PATH}"' > ~/.bashrc
echo DONE