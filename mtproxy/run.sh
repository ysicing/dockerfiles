#!/bin/bash

set -x

if [ "$1" == "bash" ];then
    exec /bin/bash
else
    #[ ! -z "$autosecret"] && secret=$(head -c 16 /dev/urandom | xxd -ps)
    [ -z "$secret" ] && secret=${default_secret}
    [ -z "$worker" ] && worker=4
    [ -z "$port" ] && port=443
    IP="$(curl -s -4 ip.sb)"
    INTERNAL_IP="$(ip -4 route get 8.8.8.8 | grep '^8\.8\.8\.8\s' | grep -Po 'src\s+\d+\.\d+\.\d+\.\d+' | awk '{print $2}')"

    curl -sk https://core.telegram.org/getProxySecret -o /proxy-secret
    curl -sk https://core.telegram.org/getProxyConfig -o /proxy-multi.conf
    echo "tg://proxy?server=${IP}&port=${port}&secret=${secret}"
    exec /usr/local/bin/mtproto-proxy -u root -p 8888 -H ${port} -C 60000 -S ${secret} --allow-skip-dh --nat-info "$INTERNAL_IP:$IP" --aes-pwd /proxy-secret /proxy-multi.conf -M ${worker}
fi
