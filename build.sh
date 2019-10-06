#!/bin/bash

set -xe

images=$(ls -alh | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    docker build -t ysicing/${image} ${image}
    docker push ysicing/${image}
done