#!/bin/bash

set -e

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | grep -v "cachet" | tr '\n' ' ' )
for image in ${images[@]}
do
    echo "start build ${image}"
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    docker buildx build --pull --push --no-cache -t ysicing/${image} ${image}
    curl -s https://cr.hk1.godu.dev/pull\?image="ysicing/${image}"
    # rm -rf ${image}/upx
done