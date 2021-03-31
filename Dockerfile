FROM ubuntu:20.04
#FROM centos/systemd

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
ENV DEBIAN_FRONTEND=noninteractive
ENV SWOOLE_VERSION=v4.4.16 
# Install
RUN apt update 

RUN apt install -y mysql-client git build-essential unzip make golang cmake flex bison \
    && apt install -y libprotobuf-dev libprotobuf-c-dev zlib1g-dev libssl-dev \
    && apt install -y curl wget net-tools iproute2

#intall php tars
RUN apt install -y php php-dev php-cli php-gd php-curl php-mysql \
    php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    build-essential libmcrypt-dev php-pear

# Clone Tars repo and init php submodule
RUN cd /root/ && git clone https://gitee.com/TarsCloud/Tars.git \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	#intall PHP Tars module
	&& cd /root/Tars/php/tars-extension/ && phpize \
	&& ./configure --enable-phptars && make && make install \
	&& echo "extension=phptars.so" > /etc/php/7.4/cli/conf.d/10-phptars.ini \
	# Install PHP swoole module
	&& cd /root && git clone https://github.com/swoole/swoole \
	&& cd /root/swoole && git checkout $SWOOLE_VERSION \
	&& cd /root/swoole \
	&& phpize && ./configure --with-php-config=/usr/bin/php-config \
	&& make \
	&& make install \
	&& echo "extension=swoole.so" > /etc/php/7.4/cli/conf.d/20-swoole.ini \
	# Do somethine clean
	&& cd /root && rm -rf swoole \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars 

#RUN mkdir -p /tmp/pear/cache \
#    && pecl channel-update pecl.php.net \
#    && pecl install swoole \
#    && echo 'extension=swoole.so' >> /etc/php/7.4/cli/conf.d/swoole.ini \
#    && pecl install mcrypt \
#    && echo 'extension=mcrypt.so' >> /etc/php/7.4/cli/conf.d/mcrypt.ini
    
#RUN cd /root/ \
#    && git clone git://github.com/TarsCloud/Tars \
#    && cd /root/Tars/ \
#    && git submodule update --init --recursive php  

#RUN cd /tmp \
#    && curl -fsSL https://getcomposer.org/installer | php \
#    && chmod +x composer.phar \
#    && mv composer.phar /usr/local/bin/composer \
#    && cd /root/Tars/php/tars-extension/ \
#    && phpize --clean \
#    && phpize \
#    && ./configure --enable-phptars --with-php-config=/usr/bin/php-config \
#    && make -j4\
#    && make install 

#RUN mkdir -p /etc/php.d/\
#    && echo "extension=phptars.so" > /etc/php.d/phptars.ini 

#    && mkdir -p /root/phptars \
#    && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
#    # Install PHP swoole module
#    && pecl install swoole \
#    && echo "extension=swoole.so" > /etc/php.d/swoole.ini 

# Install tars go
RUN go get github.com/TarsCloud/TarsGo/tars \
    && cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build . 

# Get and install nodejs
RUN apt install -y nodejs npm
RUN npm install -g npm pm2 

# Get and install JDK
RUN apt install -y openjdk-11-jdk

RUN apt install -y python3 python3-pip maven\
	&& pip3 install requests 
	
RUN mkdir -p /root/Tars && cd /root/Tars \
    && git clone https://github.com/TarsCloud/TarsCpp cpp --recursive \
    && cd cpp \
    && mkdir build \
    && cd build \
    && cmake .. && make -j4 && make install \
    && cd /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build . \
    && mkdir -p /usr/local/go/bin \
    && chmod a+x /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go \
    && ln -s /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go /usr/local/go/bin/tars2go \
    && rm -rf /root/Tars \
    && mkdir -p /root/autotest

COPY autotest/* /root/autotest/
COPY PythonTestCase /root/autotest/PythonTestCase
COPY Servers /root/autotest/Servers
COPY sql /root/autotest/sql

ENTRYPOINT [ "/root/autotest/entrypoint.sh" ]

