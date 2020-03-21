#!/bin/bash

ifconfig

HOSTIP=`ifconfig | sed 's/addr//g' | grep eth0 -A3 | grep "inet " | awk -F'[ :]+' '{print $3}'`

echo HOSTIP:${HOSTIP}

echo "docker pull mysql"
docker pull mysql:5.6

echo "docker run mysql"
docker run -dit -p 3306:3306 -e MYSQL_ROOT_PASSWORD=12345 mysql:5.6 

echo "docker pull tars framework"
docker pull tarscloud/framework

echo "docker run tars framework"
docker run --net=host -itd -e MYSQL_HOST=${HOSTIP} -e MYSQL_ROOT_PASSWORD=12345 \
        -eREBUILD=true -eINET=eth0 -eSLAVE=false \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework

echo "docker build tars-demo"
docker build . -f docker/Dockerfile -t tars-demo 

echo "docker run tars-demo"
docker run -it -eWEB_HOST=http://${HOSTIP}:3000 -eMYSQL_HOST=${HOSTIP} -eTARS_TOKEN=xxxx tars-demo 
