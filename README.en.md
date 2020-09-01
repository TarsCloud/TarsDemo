[点我看中文版](README.md)

# TarsDemo

## Goal

Complete automatic testing of the framework(>=2.4.0)

## Basic Steps
- TARS Framework deployment
- Build docker: tarsnode operating environment of tars and operating environment of all -languages
- Start docker
- docker run the script run-test.sh
- run-test.sh automatically completes the compilation of each language service, releases and runs, and calls tests

## docker run

- Run MySQL image
>-docker pull mysql: 5.6
>-Start mysql image

- Build and run the TARS image
>-git clone https://github.com/TarsCloud/TarsDocker
>-./build-docker.sh framework development
>-Build framework tarscloud/framework:dev
>-Run image (note the setting UPLOAD = true)

- Build TarsDemo image
>-git clone https://github.com/TarsCloud/TarsDemo
>-./build-docker.sh build developers
>-Build demo image: tarscloud / tarsdemo: dev
>-Run automatic testing: ./build-docker.sh run dev WEB_HOST MYSQL_HOST

The above logic is implemented in autorun.sh, and can be run directly:


## Current Progress

It is inconvenient to debug by building into docker, so you can instead debug in the following ways:
- Run autorun.sh once. This will build a set of mysql, tarsframework
- In the docker where tarsdemo was built: ./build-docker.sh build dev
- Run docker
docker run --rm \
                --name node \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                -p "22000-22020":"22000-22020" \
                tarscloud/tarsdemo:dev \
                /root/autotest/debug-entrypoint.sh

- At this point, the docker becomes a node of the tars environment
- Enter docker: docker exec -it xxx bash
- Enter the directory: cd /root/autotest
- Run run-test to debug:
./run-test.sh 172.35.0.200 3306 root 12345 http://172.35.0.2:3000 172.35.0.10
