FROM tarscloud/tars-env-full 

RUN yum -y install mysql epel-release \
    && yum -y install python36 \
    && pip3 install requests \
    && yum install -y flex bison

RUN mkdir -p /root/Tars && cd /root/Tars \
    && git clone https://github.com/TarsCloud/TarsCpp cpp --recursive \
    && cd cpp \
    && mkdir build \
    && cd build \
    && cmake .. && make && make install

RUN rm -rf /root/Tars \
    && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /root/autotest

COPY entrypoint.sh run-test.sh /root/autotest/
COPY PythonTestCase /root/autotest/PythonTestCase
COPY Servers /root/autotest/Servers
COPY sql /root/autotest/sql

ENTRYPOINT [ "/root/autotest/entrypoint.sh" ]

