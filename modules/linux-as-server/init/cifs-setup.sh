#!/usr/bin/env bash

echo "Nothing to do"
mkdir -p /data/data
chown smb:smb /data/data
chmod 777 /data/data
mkdir "/data/data/_hostname ${hostname}"
(echo smb; echo smb) | smbpasswd -s -a smb

wget https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.83-installer.msi -o /data/data/putty-installer.msi

cat <<EOF >> /etc/ssh/sshd_config.d/91-smb.conf
Match User smb
  ChrootDirectory /data
  ForceCommand internal-sftp -d /data
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication yes
EOF

/usr/bin/systemctl restart ssh
