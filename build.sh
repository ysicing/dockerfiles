#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | grep -v "cachet" | tr '\n' ' ')
for image in ${images[@]}
do

    docker build -t ysicing/${image} ${image}
    docker push ysicing/${image}
done