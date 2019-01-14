#!/bin/bash

set -x

if [ "$1" == "bash" ];then
    exec /bin/bash
else
    #[ ! -z "$autosecret"] && secret=$(head -c 16 /dev/urandom | xxd -ps)
    [ -z "$secret" ] && secret=${default_secret}
    [ -z "$worker" ] && worker=4
    [ -z "$port" ] && port=443
    ip=$(curl -s ip.sb)
    curl -sk https://core.telegram.org/getProxySecret -o /proxy-secret
    curl -sk https://core.telegram.org/getProxyConfig -o /proxy-multi.conf
    echo "tg://proxy?server=${ip}&port=${port}&secret=${secret}"
    exec /usr/local/bin/mtproto-proxy -u nobody -p 8888 -H ${port} -S ${secret} --aes-pwd /proxy-secret /proxy-multi.conf -M ${worker}
fi