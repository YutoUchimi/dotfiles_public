#!/bin/bash

IMAGE_NAME=$(basename $(cd $(dirname $0) && pwd))

set -x

docker build --no-cache -t ${IMAGE_NAME}:latest .

docker run -ti --rm \
       --net=host \
       -e DISPLAY=$DISPLAY \
       ${IMAGE_NAME}:latest

set +x
