# TarsDemo

## 目标

完成框架的自动测试(>=2.4.0)

## 基本步骤

- TARS框架部署
- 构建docker: tars的tarsnode运行环境以及各语言的运行环境
- 启动docker
- docker运行脚本run-test.sh
- run-test.sh自动完成各语言服务的编译, 发布运行以及调用测试

## docker运行

- 运行Mysql镜像
>- docker pull mysql:5.6
>- 启动mysql镜像

- 构建并运行TARS镜像
>- git clone https://github.com/TarsCloud/TarsDocker
>- ./build-docker.sh framework dev
>- 构建framework镜像 tarscloud/framework:dev  
>- 运行镜像(注意设定UPLOAD=true)

- 构建TarsDemo镜像
>- git clone https://github.com/TarsCloud/TarsDemo
>- ./build-docker.sh build dev
>- 构建demo镜像: tarscloud/tarsdemo:dev
>- 运行自动测试: ./build-docker.sh run dev WEB_HOST MYSQL_HOST

上述逻辑都实现在autorun.sh中, 直接运行即可:


## 当前进展

每次构建成docker来调试非常麻烦, 因此可以通过以下方式调试:
- 先运行一次autorun.sh, 这样会搭建一套mysql, tarsframework
- 在构建tarsdemo的docker: ./build-docker.sh build dev
- 运行docker
docker run --rm \
                --name node \
                -e WEB_HOST=http://172.35.0.2:3000 \
                -e MYSQL_HOST=172.35.0.200 \
                --net=tarsdemo \
                --ip 172.35.0.10 \
                -p "22000-22020":"22000-22020" \
                tarscloud/tarsdemo:dev \
                /root/autotest/debug-entrypoint.sh


- 此时, 该docker变成了tars环境的节点
- 进入docker: docker exec -it xxx bash
- 进入目录: cd /root/autotest
- 运行run-test调试: 

./run-test.sh 127.0.0.1 3306 root xxxx http://127.0.0.1:3000 192.168.50.42 315002464fa8924ef9e0a445e19a233d9b710b1d6820c5536adf7704bab1afdd
