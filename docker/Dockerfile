FROM centos/systemd

WORKDIR /root/

ENV WEB_HOST=http://127.0.0.1:3000
ENV INET=eth0
ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
# ENV MAVEN_HOME /usr/local/apache-maven-3.5.4

COPY centos7_base.repo /etc/yum.repos.d/

RUN	yum update -y \
	&& yum install -y mysql-devel \	
	&& yum install -y wget epel-release \
	&& yum install -y yum-utils \
	&& yum -y install psmisc net-tools wget unzip telnet zlib-devel git gcc gcc-c++ autoconf pcre-devel \
	&& yum -y install golang make iproute which glibc-devel ncurses-devel openssl-devel \
	&& yum -y install kde-l10n-Chinese glibc-common \
	&& yum -y install centos-release-scl \
	&& yum -y install devtoolset-7-gcc*
# Enable gcc 7
SHELL [ "/usr/bin/scl", "enable", "devtoolset-7"]

RUN mkdir -p /root/cpp/ \
	&& cd /root/cpp \
	&& wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/cmake-3.16.4.tar.gz  \
	&& tar xzf cmake-3.16.4.tar.gz \
	&& cd cmake-3.16.4 \
	&& ./configure  \
	&& make \
	&& make install
# Get and install nodejs
RUN	wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
	&& unzip v0.35.1.zip \
	&& cp -rf nvm-0.35.1 /root/.nvm \
	# && echo 'NVM_DIR="/root/.nvm";' >> /root/.bashrc; \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 \
	# tars nodejs 
	&& source /root/.bashrc \
	&& npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry \
	&& rm -rf v0.35.1.zip \
	&& rm -rf nvm-0.35.1
# Get and install JDK
RUN	mkdir -p /root/init \
	&& cd /root/init/ \
	&& wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/jdk-10.0.2_linux-x64_bin.rpm \
	&& rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm \
	&& rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc 
# Install PHP72
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	&& yum install -y yum-utils \
	&& yum-config-manager --enable remi-php72 \
	&& yum -y install php php-cli php-pear php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata \
	&& cd /root/ \
	# Install phptars extension
	&& git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	&& cd /tmp \
	&& curl -fsSL https://getcomposer.org/installer | php \
	&& chmod +x composer.phar \
	&& mv composer.phar /usr/local/bin/composer \
	&& cd /root/Tars/php/tars-extension/ \
	&& phpize --clean \
	&& phpize \
	&& ./configure --enable-phptars --with-php-config=/usr/bin/php-config \
	&& make \
	&& make install \
	&& echo "extension=phptars.so" > /etc/php.d/phptars.ini \
	&& mkdir -p /root/phptars \
	&& cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
	# Install swoole
	&& pecl install swoole \
	&& echo "extension=swoole.so" > /etc/php.d/swoole.ini 
# Install tars go
RUN go get github.com/TarsCloud/TarsGo/tars \
	&& cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
	&& go build . 
# Install python3 for test scripts
RUN yum -y install epel-release \
	&&yum -y install python36 \
	&& pip3 install requests

RUN	yum clean all \
	&& rm -rf /var/cache/yum

# Whether mount Tars process path to outside, default to false (support windows)
# ENV MOUNT_DATA false

# Network interface (if use --net=host, maybe network interface does not named eth0)
# ENV INET_NAME eth0

# VOLUME ["/data"]

# copy source
# COPY install.sh /root/init/
COPY entrypoint.sh /sbin/
# ADD confs /root/confs

# RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]

