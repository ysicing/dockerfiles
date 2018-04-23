#!/bin/bash

if [ "$1" == "bash" ];then
    exec /bin/bash
else
    exec /usr/bin/xtrabackup $@
fi