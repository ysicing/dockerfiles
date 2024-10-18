#!/bin/bash

if [ -n "$PROXY_REMOTE_URL" ]; then
  sed -i "s|registry-1.docker.io|$PROXY_REMOTE_URL|g" /config.yml
fi

if [ "$1" == "bash" ]; then
    exec /bin/bash
else
    exec /usr/bin/registry serve /config.yml
fi
