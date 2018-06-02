#!/bin/bash

if [ "$1" = "bash" ];then
    exec /bin/bash
else
    exec /opt/objs/srs $@
fi