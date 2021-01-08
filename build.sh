#!/bin/bash

set -e

mirrors=$1

images=$(ls -al | grep "drwxr"  | grep -v "\." | awk '{print $NF}' | grep -v "cachet" | tr '\n' ' ')
for image in ${images[@]}
do
    echo "start build ${image}"
    cp -a ./upx ${image}/upx
    chmod +x ${image}/upx
    cat ${image}/Dockerfile | grep FROM | awk '{print $2}' | xargs -I {} docker pull {}
    docker build --no-cache --pull -t ysicing/${image} ${image}
    [ ! -z $mirrors ] && (
        docker tag ysicing/${image} registry.cn-beijing.aliyuncs.com/k7scn/${image}
        docker push registry.cn-beijing.aliyuncs.com/k7scn/${image}
    )
    docker push ysicing/${image}
    curl -s https://cr.hk1.godu.dev/pull\?name="ysicing/${image}"
    rm -rf ${image}/upx
done