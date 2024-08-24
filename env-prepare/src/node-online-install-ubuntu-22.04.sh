#!/bin/bash

nvmVersion="0.40.0"
nodeVersion="16.13.0"
pm2Version="5.2.2"

wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/v${nvmVersion}/install.sh" | bash

source /root/.bashrc

nvm install "${nodeVersion}"

nvm alias default "${nodeVersion}"

npm install -g pm2@"${pm2Version}"

pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M

echo "Node.js version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "PM2 version: $(pm2 -v)"
echo "Node.js and PM2 have been installed successfully."
