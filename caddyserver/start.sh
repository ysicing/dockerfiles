#!/bin/bash

if [ "$1" = "bash" ];then
    exec /bin/bash
elif [ "$1" = "version" ];then
    exec /usr/local/bin/caddy -version
elif [ "$1" = "plugins" ];then
    exec /usr/local/bin/caddy -plugins
else
    exec /usr/local/bin/caddy $@
fi