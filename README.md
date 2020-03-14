# TarsDemo

## 目标

完成框架的自动测试(>=2.1.0)

## 基本步骤

- TARS框架部署
- 进入web, 打开用户中心, 生成Token
- 构建docker: tars的tarsnode运行环境以及各语言的运行环境
- 启动docker
- docker运行脚本run-test.sh
- run-test.sh自动完成各语言服务的编译, 发布运行以及调用测试


## 当前进展

运行run-test.sh, 完成了Cpp服务的编译和自动部署(还有待改进)

./run-test.sh 127.0.0.1 3306 root xxxx http://127.0.0.1:3000 192.168.50.42 315002464fa8924ef9e0a445e19a233d9b710b1d6820c5536adf7704bab1afdd