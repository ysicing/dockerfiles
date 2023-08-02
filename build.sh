#!/bin/bash

set -ex

ctx=$1
image=$2

docker build --pull --push -t ${image} $ctx

curl -s https://cr.hk1.godu.dev/pull\?image="${image}"
