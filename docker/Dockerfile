FROM tarscloud/tars-node

RUN mkdir -p /root/autotest \
&& mkdir -p /root/autotest/CppServer \
&& mkdir -p /root/autotest/GoServer \
&& mkdir -p /root/autotest/JavaServer \
&& mkdir -p /root/autotest/NodejsServer \
&& mkdir -p /root/autotest/PhpServer \
&& mkdir -p /root/autotest/PythonTestCase \
&& mkdir -p /root/autotest/sql

COPY docker /root/autotest/docker
COPY CppServer /root/autotest/CppServer
COPY GoServer /root/autotest/GoServer
COPY JavaServer /root/autotest/JavaServer
COPY NodejsServer /root/autotest/NodejsServer
COPY PhpServer /root/autotest/PhpServer
COPY PythonTestCase /root/autotest/PythonTestCase
COPY sql /root/autotest/sql

RUN ls /root/autotest

RUN chmod 755 /root/autotest/docker/entrypoint.sh && chmod 755 /root/autotest/docker/run-test.sh

ENTRYPOINT [ "/root/autotest/docker/entrypoint.sh" ]

