#!/bin/bash

if [ $# -lt 1 ]; then
    echo "$0 TAG"
    exit 1
fi

TAG=$1

WORKDIR=$(cd $(dirname $0); pwd)

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker buildx create --use --name tars-builder 
docker buildx inspect tars-builder --bootstrap
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64

docker buildx build ${WORKDIR} -t tarscloud/tarsdemo:$TAG  --platform=linux/amd64,linux/arm64 --push

