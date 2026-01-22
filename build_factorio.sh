#!/bin/bash
apt update && apt upgrade -y
echo "creating user"
adduser --disabled-login -no-create-home --gecos factorio factorio
echo "created user"
cd /opt
wget -O factorio_headless.tar.gz https://www.factorio.com/get-download/latest/headless/linux64
tar -xvf factorio_headless.tar.gz
rm factorio_headless.tar.gz
chown -R factorio:factorio /opt/factorio