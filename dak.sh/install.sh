#! /bin/bash

# INITIALIZE ENVIRONMENT
apt update

# INSTALL PACKAGES
apt install nginx -y

# CLEAN ENVIRONMENT
apt autoremove -y
apt clean
rm -rvf /var/lib/apt/lists/*