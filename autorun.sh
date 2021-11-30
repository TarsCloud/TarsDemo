#!/bin/bash

if [ $# -lt 3 ]; then
    echo "$0 framework-tag(dev) tarsdemo-tag(dev) rebuld(true/false) update-framework-image(true/false)"
    echo "rebuild means rebuild tarsdemo"
    exit 0
fi

FRAMEWORK_TAG=$1
TARSDEMO_TAG=$2
REBUILD=$3
PULL_FRAMEWORK=$4

ifconfig

HOSTIP=`ifconfig | sed 's/addr//g' | grep eth0 -A3 | grep "inet " | awk -F'[ :]+' '{print $3}'`

echo HOSTIP:${HOSTIP}

docker kill mysql
docker container rm mysql
docker kill framework
docker container rm framework

docker kill node
docker container rm node

docker network rm tarsdemo

docker network rm tarsdemo
docker network create -d bridge --subnet 172.35.0.1/16 tarsdemo

echo "docker pull mysql"
docker pull mysql:5.6

echo "docker run mysql"
docker run -d \
        --rm \
        --name mysql \
        --net=tarsdemo \
        --ip 172.35.0.200 \
        -e MYSQL_ROOT_PASSWORD=12345 \
        mysql:5.6 

echo "Waiting for mysql to start"
sleep 10

if [ $PULL_FRAMEWORK != 'false' ]; then
    echo "docker pull tars framework"
    docker pull tarscloud/framework:$FRAMEWORK_TAG
fi

echo "docker run tars framework tarscloud/framework:$FRAMEWORK_TAG"
docker run -d --net=tarsdemo \
        --rm \
        --name framework \
        -e MYSQL_HOST=172.35.0.200 \
        -e MYSQL_ROOT_PASSWORD=12345 \
        -e REBUILD=true \
        -e INET=eth0 \
        -e TARS_WEB_UPLOAD=true \
        -e TARS_ENABLE_LOGIN=false \
        -e SLAVE=false \
        --ip 172.35.0.2 \
        tarscloud/framework:$FRAMEWORK_TAG

if [[ $REBUILD = "true" ]]; then
        echo "docker build tars-demo"
        docker build -f Dockerfile -t tarscloud/tarsdemo:$TARSDEMO_TAG .

        echo "docker run tars-demo"
        docker run --rm \
                --name node \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                -e REBUILD_PROJECTS=false \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                tarscloud/tarsdemo:$TARSDEMO_TAG
else
        echo "docker pull tars tarsdemo"
        docker pull tarscloud/tarsdemo:$TARSDEMO_TAG
        docker run --rm \
                --name node \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                -e REBUILD_PROJECTS=false \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                tarscloud/tarsdemo:$TARSDEMO_TAG
fi
