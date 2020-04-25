FROM tarscloud/tars-env-full 

RUN yum -y install mysql epel-release \
    && yum -y install python36 \
    && pip3 install requests \
    && yum install -y flex bison \
    && yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm \
    && yum install -y git \
    && yum update -y git

RUN mkdir -p /root/Tars && cd /root/Tars \
    && git clone https://github.com/TarsCloud/TarsCpp cpp --recursive \
    && cd cpp \
    && mkdir build \
    && cd build \
    && cmake .. && make && make install

RUN cd /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build . \
    && mkdir -p /usr/local/go/bin \
    && chmod a+x /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go \
    && ln -s /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go /usr/local/go/bin/tars2go

RUN rm -rf /root/Tars \
    && yum clean all && rm -rf /var/cache/yum

RUN yum -y install maven

RUN mkdir -p /root/autotest

COPY autotest/* /root/autotest/
COPY PythonTestCase /root/autotest/PythonTestCase
COPY Servers /root/autotest/Servers
COPY sql /root/autotest/sql

RUN cd /root/autotest/Servers/JavaServer/JavaHttp && mvn package \
    && cd /root/autotest/Servers/JavaServer/JavaTars && mvn package \
    && npm install -g @tars/deploy \
    && cd /root/autotest/Servers/NodejsServer/NodejsHttp && npm install && tars-deploy NodejsHttp \
    && cd /root/autotest/Servers/NodejsServer/NodejsTars && npm install && tars-deploy NodejsTars

ENTRYPOINT [ "/root/autotest/entrypoint.sh" ]

