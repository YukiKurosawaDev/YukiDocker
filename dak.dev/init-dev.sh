#! /bin/bash

echo -n "CONFIGURING DAK ENVIRONMENT ... "
echo 'export PATH="/srv/dak/bin:${PATH}"' > ~/.bashrc
echo 'export PATH="/srv/dak/bin:${PATH}"' > /home/dak/.bashrc
source ~/.bashrc

USER_CMD="sudo -E -u dak -s -H"
DAK="/srv/dak/bin/dak"
service postgresql start 1>/dev/null 2>&1
service nginx start 1>/dev/null 2>&1
echo "DONE"

echo -n "IMPORTING TEST REPO GPG KEY ... "
$USER_CMD gpg --homedir /srv/dak/keyrings/s3kr1t/dot-gnupg --import /dak.dev/keys/.no-key 1>/dev/null 2>&1
echo DONE

echo -n "IMPORTING TEST DEVELOPER GPG KEY ... "
$USER_CMD gpg --no-default-keyring --keyring /srv/dak/keyrings/upload-keyring.gpg --import /dak.dev/keys/.no-key  1>/dev/null 2>&1
echo "DONE"

echo -n "IMPORTING dak REPO GPG KEY ... "
$USER_CMD $DAK import-keyring -U '%s' /srv/dak/keyrings/upload-keyring.gpg  1>/dev/null 2>&1
echo "DONE"

echo -n "INITING AN EMPTY REPO ... "
$USER_CMD $DAK admin architecture add amd64 "KSLinux 22.04.1 AMD64" 1>/dev/null 2>&1

$USER_CMD $DAK admin suite add-all-arches jammy 22.04.1 origin=KSLinux label=Focal codename=focal signingkey=451DD5811062DFC93DF54EEC259531ED17EE37C1 1>/dev/null 2>&1

$USER_CMD $DAK admin s-c add jammy main restricted universe multiverse 1>/dev/null 2>&1

$USER_CMD $DAK init-dirs 1>/dev/null 2>&1

$USER_CMD $DAK generate-packages-sources2 1>/dev/null 2>&1

$USER_CMD $DAK generate-release 1>/dev/null 2>&1
echo "DONE"
