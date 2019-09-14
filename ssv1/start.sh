#!/bin/bash

if [[ "$1" == "bash" ]];then
  exec /bin/bash
else
  exec ssserver -c /ss/gfw.json
fi
