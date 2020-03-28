#!/bin/bash

ifconfig

HOSTIP=`ifconfig | sed 's/addr//g' | grep eth0 -A3 | grep "inet " | awk -F'[ :]+' '{print $3}'`

echo HOSTIP:${HOSTIP}

echo "docker pull mysql"
docker pull mysql:5.6

echo "docker run mysql"
docker run -d \
        -p 3306:3306 \
        --net=tarsdemo \
        --ip 172.35.0.200 \
        -e MYSQL_ROOT_PASSWORD=12345 \
        mysql:5.6 

echo "docker pull tars framework"
docker pull tarscloud/framework

echo "docker run tars framework"
docker run --net=tarsdemo \
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
        tarscloud/framework

echo "docker build tars-demo"
docker build docker -f docker/Dockerfile -t tars-demo 
PRJ_DIR=$(cd ..; pwd)
echo "docker run tars-demo"
docker run --rm \
        -e WEB_HOST=http://172.35.0.2:3000 \
        -e MYSQL_HOST=172.35.0.200 \
        -e INET=eth0 \
        -e TARS_TOKEN=xxxx \
        --net=tarsdemo \
        --ip 172.35.0.10 \
        -p "20000-20020":"20000-20020" \
        -v "${PRJ_DIR}/TarsDemo":/root/TarsDemo \
        tars-demo 