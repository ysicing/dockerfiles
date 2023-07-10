#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    echo "start build ${image}"
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    docker buildx build --pull --psuh -t ysicing/${image} -t ghcr.io/ysicing/${image} ${image}
    curl -s https://cr.hk1.godu.dev/pull\?image="ysicing/${image}"
done
