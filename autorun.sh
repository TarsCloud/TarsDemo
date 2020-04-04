#!/bin/bash

if [ $# -lt 3 ]; then
    echo "$0 framework-tag(dev) tarsdemo-tag(dev) rebuld(true/false)"
    echo "rebuild means rebuild tarsdemo"
    exit 0
fi

FRAMEWORK_TAG=$1
TARSDEMO_TAG=$2
REBUILD=$3

ifconfig

HOSTIP=`ifconfig | sed 's/addr//g' | grep eth0 -A3 | grep "inet " | awk -F'[ :]+' '{print $3}'`

echo HOSTIP:${HOSTIP}

docker network create -d bridge --subnet 172.35.0.1/16 tarsdemo

echo "docker pull mysql"
docker pull mysql:5.6

echo "docker run mysql"
docker run -d \
        --name tars-mysql \
        -p 3306:3306 \
        --net=tarsdemo \
        --ip 172.35.0.200 \
        -e MYSQL_ROOT_PASSWORD=12345 \
        mysql:5.6 

echo "docker pull tars framework"
docker pull tarscloud/framework:$FRAMEWORK_TAG

echo "docker run tars framework"
docker run -d --net=tarsdemo \
        --rm \
        -e MYSQL_HOST=172.35.0.200 \
        -e MYSQL_ROOT_PASSWORD=12345 \
        -e REBUILD=true \
        -e INET=eth0 \
        -e TARS_WEB_UPLOAD=true \
        -e SLAVE=false \
        -v /tmp/data/tars:/data/tars \
        --ip 172.35.0.2 \
        -p 3000:3000 \
        -p 3001:3001 \
        tarscloud/framework:$FRAMEWORK_TAG

if [ "$REBUILD" == "true" ]; then
        echo "docker build tars-demo"
        docker build . -t tars-demo:$TARSDEMO_TAG

        echo "docker run tars-demo"
        docker run --rm \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                -p "20000-20020":"20000-20020" \
                -v "${PRJ_DIR}/TarsDemo":/root/TarsDemo \
                tarscloud/tarsdemo:$TARSDEMO_TAG


else
        docker run --rm \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                -p "20000-20020":"20000-20020" \
                tarscloud/tarsdemo:$TARSDEMO_TAG

fi
