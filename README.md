[Read in English](README.en.md)

# TarsDemo

## 目标

完成框架的自动测试(>=2.4.0)

## 基本步骤

- TARS 框架部署
- 构建 docker: tars 的 tarsnode 运行环境以及各语言的运行环境
- 启动 docker
- docker 运行脚本 run-test.sh
- run-test.sh 自动完成各语言服务的编译, 发布运行以及调用测试

## docker 运行

- 运行 Mysql 镜像

  > - docker pull mysql:5.6
  > - 启动 mysql 镜像

- 构建并运行 TARS 镜像

  > - git clone https://github.com/TarsCloud/TarsDocker
  > - 构建 framework 镜像: ./build-docker.sh framework dev
  > - 运行镜像(注意设定 UPLOAD=true)

- 构建 TarsDemo 镜像
  > - git clone https://github.com/TarsCloud/TarsDemo
  > - ./build-docker.sh build dev
  > - 构建 demo 镜像: tarscloud/tarsdemo:dev
  > - 运行自动测试: ./build-docker.sh run dev WEB_HOST MYSQL_HOST

上述逻辑都实现在 autorun.sh 中, 直接运行即可:

## 当前进展

每次构建成 docker 来调试非常麻烦, 因此可以通过以下方式调试:

- 先运行一次 autorun.sh, 这样会搭建一套 mysql, tarsframework
- 在构建 tarsdemo 的 docker: ./build-docker.sh build dev
- 运行 docker: docker run --entrypoint=/root/autotest/debug-entrypoint.sh --rm --name node -e WEB_HOST=http://172.35.0.2:3000 -e MYSQL_HOST=172.35.0.200 --net=tarsdemo --ip 172.35.0.10 -p "22000-22020":"22000-22020" tarscloud/tarsdemo:dev
- 此时, 该 docker 变成了 tars 环境的节点
- 进入 docker: docker exec -it xxx bash
- 进入目录: cd /root/autotest
- 运行 run-test 调试:
  ./run-test.sh http://172.35.0.2:3000 172.35.0.10 false

# 关于 K8S 的测试

以上描述如何测试普通 TARS 环境, 本节描述如何测试部署在 K8S 上的 TARS 环境.

在安装有 docker, 且可以控制 K8S 集群的机器上(拥有 K8S 的 config), 启动 base-compiler 环境

注意在 TarsDemo 目录下, 进行以下操作:

```
docker run -it -v/var/run/docker.sock:/var/run/docker.sock -v`pwd`:/data/src -v ~/.kube:/root/.kube tarscloud/base-compiler bash

```

在容器中执行:

```
./autorun-for-k8s.sh
```

完成 Demo 服务的发布到 K8S, 注意生成的镜像依赖 yaml 中的 image 地址, 如果没有权限, 你需要改成自己的仓库地址!
