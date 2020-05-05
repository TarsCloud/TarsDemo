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

# clear containers
mysql_container=`docker ps --format="table {{.Names}}" -f name=mysql | grep mysql`
if [[ $mysql_container = 'mysql' ]]; then
    echo "Found mysql running container, killing..."
    docker kill mysql
fi
mysql_container=`docker container ls --format="table {{.Names}}" -f name=mysql | grep mysql`
if [[ $mysql_container = 'mysql' ]]; then
    echo "Found mysql container, removing..."
    docker container rm mysql
fi

framework_container=`docker ps --format="table {{.Names}}" -f name=framework | grep framework`
if [[ $framework_container = 'framework' ]]; then
    echo "Found framework running container, killing..."
    docker kill framework
fi
framework_container=`docker container ls --format="table {{.Names}}" -f name=framework | grep framework`
if [[ $framework_container = 'framework' ]]; then
    echo "Found framework container, removing..."
    docker container rm framework
fi

node_container=`docker ps --format="table {{.Names}}" -f name=node | grep node`
if [[ $node_container = 'node' ]]; then
    echo "Found node runing container, killing..."
    docker kill node
fi
node_container=`docker container ls --format="table {{.Names}}" -f name=node | grep node`
if [[ $node_container = 'node' ]]; then
    echo "Found node container, removing..."
    docker container rm node
fi

# clear network if exists
docker_network=`docker network ls  | grep tarsdemo | awk '{print $2}'`
if [[ $docker_network = 'tarsdemo' ]]; then
    docker network rm tarsdemo
fi

docker network create -d bridge --subnet 172.35.0.1/16 tarsdemo

echo "docker pull mysql"
docker pull mysql:5.6

echo "docker run mysql"
docker run -d \
        --rm \
        --name mysql \
        -p 3307:3306 \
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
        -e SLAVE=false \
        --ip 172.35.0.2 \
        -p 3000:3000 \
        -p 3001:3001 \
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
                -p "22000-22020":"22000-22020" \
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
                -p "22000-22020":"22000-22020" \
                tarscloud/tarsdemo:$TARSDEMO_TAG
fi