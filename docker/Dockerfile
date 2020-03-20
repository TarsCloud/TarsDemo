FROM centos/systemd

WORKDIR /root/

ENV WEB_HOST=http://127.0.0.1:3000
ENV INET=eth0
ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
# ENV MAVEN_HOME /usr/local/apache-maven-3.5.4

COPY centos7_base.repo /etc/yum.repos.d/
RUN	yum makecache fast \
	yum install -y mysql-devel \	
  	&& yum install -y wget epel-release \
  	&& yum install -y yum-utils \
	&& yum -y install psmisc net-tools wget unzip telnet zlib-devel git gcc gcc-c++ \
	&& yum -y install golang make iproute which glibc-devel ncurses-devel openssl-devel \
	&& yum -y install kde-l10n-Chinese glibc-common 

RUN mkdir -p /root/cpp/ && cd /root/cpp \
	&& wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/cmake-3.16.4.tar.gz  \
	&& tar xzf cmake-3.16.4.tar.gz && cd cmake-3.16.4 && ./configure  && make && make install

	# Get and install nodejs
RUN	wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip && unzip v0.35.1.zip && cp -rf nvm-0.35.1 /root/.nvm \
	# && echo 'NVM_DIR="/root/.nvm";' >> /root/.bashrc; \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 \
	#tars nodejs 
	&& source /root/.bashrc && npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry 
	# Get and install JDK
RUN	mkdir -p /root/init && cd /root/init/ \
	&& wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/jdk-10.0.2_linux-x64_bin.rpm \
	&& rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm && rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc 

RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
  	&& yum install -y yum-utils \
  	&& yum-config-manager --enable remi-php72 \
	&& yum -y install php php-cli php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata
	
RUN	mkdir -p /root/Tars && cd /root/Tars && git clone https://github.com/TarsPHP/TarsPHP php --recursive php \
	#intall php
	&& cd /tmp && curl -fsSL https://getcomposer.org/installer | php \
	&& chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
	&& cd /root/Tars/php/tars-extension/ && phpize --clean && phpize \
	&& ./configure --enable-phptars --with-php-config=/usr/bin/php-config && make && make install \
	&& echo "extension=phptars.so" > /etc/php.d/phptars.ini \
	# Install PHP swoole module
	&& cd /root && wget -c -t 0 https://github.com/swoole/swoole-src/archive/v2.2.0.tar.gz \
	&& tar zxf v2.2.0.tar.gz && cd swoole-src-2.2.0 && phpize && ./configure && make && make install \
	&& echo "extension=swoole.so" > /etc/php.d/swoole.ini \
	&& cd /root && rm -rf v2.2.0.tar.gz swoole-src-2.2.0 \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
	# Install tars go
	&& go get github.com/TarsCloud/TarsGo/tars \
	&& cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go && go build . 

RUN	yum clean all && rm -rf /var/cache/yum

# Whether mount Tars process path to outside, default to false (support windows)
# ENV MOUNT_DATA false

# Network interface (if use --net=host, maybe network interface does not named eth0)
# ENV INET_NAME eth0

# VOLUME ["/data"]

# copy source
# COPY install.sh /root/init/
COPY entrypoint.sh /sbin/
COPY CppServer GoServer JavaServer NodejsServer PhpServer PythonTestCase sql run-test.sh /root/
# ADD confs /root/confs

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]

