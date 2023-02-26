#!/bin/bash

set -e

mirrors=$1

pushd stable

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | tr '\n' ' ')
for image in ${images[@]}
do
    echo "start build ${image}"
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    docker build --no-cache --pull -t ysicing/${image} ${image}
    [ ! -z $mirrors ] && (
        docker tag ysicing/${image} ghcr.io/ysicing/${image}
        docker push ghcr.io/ysicing/${image}
    )
    docker push ysicing/${image}
    curl -s https://cr.hk1.godu.dev/pull\?image="ysicing/${image}"
    # rm -rf ${image}/upx
done

docker run --rm --name kubectl ghcr.io/ysicing/kubectl:latest

popd
