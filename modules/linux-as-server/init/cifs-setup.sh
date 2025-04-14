#!/usr/bin/env bash

echo "Nothing to do"
mkdir /data
chown smb /data
chmod 777 /data
mkdir "/data/_hostname ${hostname}"
(echo smb; echo smb) | smbpasswd -s -a smb

wget https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.83-installer.msi -o /data/putty-installer.msi
