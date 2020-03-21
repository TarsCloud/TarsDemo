#!/bin/bash

ifconfig

HOSTIP=`ifconfig | sed 's/addr//g' | grep eth0 -A3 | grep "inet " | awk -F'[ :]+' '{print $3}'`

echo HOSTIP:${HOSTIP}

docker pull mysql:5.6

docker run -dit -p 3306:3306 -e MYSQL_ROOT_PASSWORD=12345 mysql:5.6 

docker pull tarscloud/framework

docker run --net=host -e MYSQL_HOST=${HOSTIP} -e MYSQL_ROOT_PASSWORD=12345 \
        -eREBUILD=true -eINET=eth0 -eSLAVE=false \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework

./build-docker.sh		

docker run -it -eWEB_HOST=${HOSTIP} -eMYSQL_HOST=${HOSTIP} -eTARS_TOKEN=xxxx tars-demo 