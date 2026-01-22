#!/bin/bash
built=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [$built -lt 1] then
apt update && apt upgrade -y
echo -e "${BLUE}Creating user and group factorio"
adduser --disabled-login -no-create-home --gecos factorio factorio
echo -e "$created user"
cd /opt
# wget -O factorio_headless.tar.gz https://www.factorio.com/get-download/latest/headless/linux64
# tar -xvf factorio_headless.tar.gz
# rm factorio_headless.tar.gz
echo -e "_________ \ngiving permissions to factorio user"
chown -R factorio:factorio /opt/factorio
echo """
    [Unit]
    Description=Factorio Headless Server
    After=network.target

    [Service]
    User=factorio
    WorkingDirectory=/opt/factorio
    ExecStart=/opt/factorio/bin/x64/factorio --start-server /opt/factorio/saves/YourSaveFile.zip --server-settings /opt/factorio/data/server-settings.json
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
 """ > /etc/systemd/system/factorio.service

systemctl enable factorio
systemctl start factorio
fi