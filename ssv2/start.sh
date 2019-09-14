#!/bin/bash

[ $DEBUG ] && set -xe

[ -z "$PORT" ] && PORT="110"
[ -z "$PASS" ] && PORT="12345678"
[ -z "$METHOD" ] && METHOD="salsa20"

cat > /ss/gfw.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": "${PORT}",
    "manager-address": "127.0.0.1:6666",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "${PASS}",
    "timeout": 300,
    "workers": 4,
    "method": "${METHOD}",
    "fast_open": false
}
EOF

if [[ "$1" == "bash" ]];then
  exec /bin/bash
else
  exec ssserver -c /ss/gfw.json
fi
