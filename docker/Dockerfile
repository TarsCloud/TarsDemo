FROM tarscloud/tars-node

RUN mkdir -p /root/autotest

COPY CppServer GoServer JavaServer NodejsServer PhpServer PythonTestCase sql run-test.sh /root/autotest/

COPY docker/entrypoint.sh /root/autotest/
COPY docker/run-test.sh /root/autotest/

RUN chmod 755 /root/autotest/entrypoint.sh && chmod 755 /root/autotest/run-test.sh

ENTRYPOINT [ "/root-autotest/entrypoint.sh" ]

