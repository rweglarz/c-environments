#!/usr/bin/env bash

APPHOME=/home/app/

/usr/bin/python3.12 -m venv $APPHOME/.venv
$APPHOME/.venv/bin/pip3 install flask waitress

touch /etc/authbind/byport/80
chmod 777 /etc/authbind/byport/80


cat > /etc/systemd/system/webserver.service << EOF
[Unit]
Description=python mini web server
After=network.target

[Service]
Environment="hostname=${hostname}"
Environment="server_ip=$(ip route get 1.1.1.1 | grep -Po '(?<=src ).*(?= uid)')"
ExecStart=authbind --deep $APPHOME/.venv/bin/python3.12 $APPHOME/webserver.py 
Restart=always
User=app
WorkingDirectory=/home/app/

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable webserver.service
systemctl start webserver.service
