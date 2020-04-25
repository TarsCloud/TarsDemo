#!/bin/bash

if [ $# -lt 2 ]; then
    echo "$0 build TAG"
    echo "$0 run TAG WEB_HOST MYSQL_HOST"
    exit 1
fi

COMMAND=$1

if [ "${COMMAND}" == "build" ]; then
    if [ $# -lt 2 ]; then
        echo "$0 build TAG"
        exit 1
    fi
fi

if [ "${COMMAND}" == "run" ]; then
    if [ $# -lt 4 ]; then
        echo "$0 run TAG WEB_HOST MYSQL_HOST"
        exit 1
    fi
fi

COMMAND=$1
TAG=$2
WEB_HOST=$3
MYSQL_HOST=$4

WORKDIR=$(cd $(dirname $0); pwd)

case $COMMAND in
    "build")
        #docker build --no-cache -t tarscloud/tarsdemo:$TAG ${WORKDIR}/docker
        docker build -t tarscloud/tarsdemo:$TAG ${WORKDIR}
        ;;
    "run")
        docker run --rm -e WEB_HOST=${WEB_HOST} -e MYSQL_HOST=${MYSQL_HOST} --net=tarsdemo --ip 172.35.0.10 -p "20000-20020":"20000-20020" tarscloud/tarsdemo:$TAG
        ;;
   *)
        echo "$0 build TAG"
        echo "[$0 run TAG WEB_HOST MYSQL_HOST]"
        ;;
esac


