#!/usr/bin/env bash

cat <<EOF >> /etc/ssh/sshd_config
Match User povuser
  PasswordAuthentication yes
  KbdInteractiveAuthentication yes
EOF

