#!/bin/bash

trap 'exit' SIGTERM SIGINT

SERVERS_PATH=/data/src/Servers

#公共函数
function LOG_ERROR()
{
	if (( $# < 1 ))
	then
		echo -e "\033[33m usesage: LOG_ERROR msg \033[0m";
	fi
	
	local msg=$(date +%Y-%m-%d" "%H:%M:%S);

    msg="${msg} $@";

	echo -e "\033[31m $msg \033[0m";	
}

function LOG_WARNING()
{
	if (( $# < 1 ))
	then
		echo -e "\033[33m usesage: LOG_WARNING msg \033[0m";
	fi
	
	local msg=$(date +%Y-%m-%d" "%H:%M:%S);

    msg="${msg} $@";

	echo -e "\033[33m $msg \033[0m";	
}

function LOG_DEBUG()
{
	if (( $# < 1 ))
	then
		LOG_WARNING "Usage: LOG_DEBUG logmsg";
	fi
	
	local msg=$(date +%Y-%m-%d" "%H:%M:%S);

    msg="${msg} $@";

 	echo -e "\033[40;37m $msg \033[0m";	
}

function LOG_INFO()
{
	if (( $# < 1 ))
	then
		LOG_WARNING "Usage: LOG_INFO logmsg";
	fi
	
	local msg=$(date +%Y-%m-%d" "%H:%M:%S);
	
	for p in $@
	do
		msg=${msg}" "${p};
	done
	
	echo -e "\033[32m $msg \033[0m"  	
}


LOG_DEBUG "Building CPP"
# --------------------------------------cpp--------------------------------------
rm -rf ${SERVERS_PATH}/CppServer/build
mkdir -p ${SERVERS_PATH}/CppServer/build
cd ${SERVERS_PATH}/CppServer/build
cmake .. -DTARS_WEB_HOST=${WEB_HOST}
make -j4

cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.cppbase cpp Servers/CppServer/build/bin/CppHttp yaml/CppHttp.yaml latest true
exec-helm.sh yaml/CppHttp.yaml latest
exec-deploy.sh tars-dev demo-cpphttp-1.0.0.tgz

exec-build.sh tarscloud/tars.cppbase cpp Servers/CppServer/build/bin/CppTars yaml/CppTars.yaml latest true
exec-helm.sh yaml/CppTars.yaml latest
exec-deploy.sh tars-dev demo-cpptars-1.0.0.tgz


# --------------------------------------golang--------------------------------------
LOG_DEBUG "Building GoLang"
cd ${SERVERS_PATH}/GoServer/GoHttp
go mod vendor
make
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.cppbase go Servers/GoServer/GoHttp/GoHttp yaml/GoHttp.yaml latest true
exec-helm.sh yaml/GoHttp.yaml latest
exec-deploy.sh tars-dev demo-gohttp-1.0.0.tgz

cd ${SERVERS_PATH}/GoServer/GoTars
go mod vendor
make
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.cppbase go Servers/GoServer/GoTars/GoTars yaml/GoTars.yaml latest true
exec-helm.sh yaml/GoTars.yaml latest
exec-deploy.sh tars-dev demo-gotars-1.0.0.tgz

# --------------------------------------java--------------------------------------
LOG_DEBUG "Building Java"
cd ${SERVERS_PATH}/JavaServer/JavaHttp
rm -rf ./target
mvn package
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.javabase java Servers/JavaServer/JavaHttp/target/JavaHttp-1.0-SNAPSHOT.jar yaml/JavaHttp.yaml latest true
exec-helm.sh yaml/JavaHttp.yaml latest
exec-deploy.sh tars-dev demo-javahttp-1.0.0.tgz

cd ${SERVERS_PATH}/JavaServer/JavaTars
rm -rf ./target
mvn package
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.javabase java Servers/JavaServer/JavaTars/target/JavaTars-1.0-SNAPSHOT.jar yaml/JavaTars.yaml latest true
exec-helm.sh yaml/JavaTars.yaml latest
exec-deploy.sh tars-dev demo-javatars-1.0.0.tgz

# --------------------------------------nodejs--------------------------------------
LOG_DEBUG "Building Nodejs"
source /root/.bashrc
source /etc/profile
cd ${SERVERS_PATH}/NodejsServer/NodejsHttp
npm install
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.nodejsbase nodejs Servers/NodejsServer/NodejsHttp yaml/NodejsHttp.yaml latest true
exec-helm.sh yaml/NodejsHttp.yaml latest
exec-deploy.sh tars-dev demo-nodejshttp-1.0.0.tgz

cd ${SERVERS_PATH}/NodejsServer/NodejsTars
npm install
cd ${SERVERS_PATH}/..
exec-build.sh tarscloud/tars.nodejsbase nodejs Servers/NodejsServer/NodejsTars yaml/NodejsTars.yaml latest true
exec-helm.sh yaml/NodejsTars.yaml latest
exec-deploy.sh tars-dev demo-nodejstars-1.0.0.tgz


# --------------------------------------php--------------------------------------
LOG_DEBUG "Building PHP"
cd ${SERVERS_PATH}/PhpServer/PHPHttp/src
mkdir servant
composer install
cd ../scripts
./tars2php.sh
cd ../src
rm -rf *.tar.gz
composer run-script deploy
cd ${SERVERS_PATH}/PhpServer/PHPTars/src
mkdir servant
composer install
cd ../scripts
./tars2php.sh
cd ../src
rm -rf *.tar.gz
composer run-script deploy