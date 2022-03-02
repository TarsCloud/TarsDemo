#!/bin/bash

trap 'exit' SIGTERM SIGINT

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

#exec sql
function exec_mysql_sql()
{
    LOG_DEBUG "mysql -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASS} -P${MYSQL_PORT} --default-character-set=utf8 -D$1 < $2"
    mysql -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASS} -P${MYSQL_PORT} --default-character-set=utf8 -D$1 < $2

    ret=$?

    return $ret
}

if (( $# < 2 ))
then
    echo $#
    echo "$0 WEB_HOST NODE_IP REBUILD_PROJECTS";
    exit 1
fi

# MYSQL_HOST=$1
# MYSQL_PORT=$2
# MYSQL_USER=$3
# MYSQL_PASS=$4
WEB_HOST=$1
NODE_IP=$2
REBUILD_PROJECTS=$3

TEST_PATH=$(cd $(dirname $0); pwd)

cd ${TEST_PATH}

#输出配置信息
LOG_DEBUG "===>print config info >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
LOG_DEBUG "PARAMS:           "$*
# LOG_DEBUG "MYSQL_HOST:       "$MYSQL_HOST 
# LOG_DEBUG "MYSQL_PORT:       "$MYSQL_PORT
# LOG_DEBUG "MYSQL_USER:       "$MYSQL_USER
# LOG_DEBUG "MYSQL_PASS:       "$MYSQL_PASS
LOG_DEBUG "WEB_HOST:         "$WEB_HOST
LOG_DEBUG "NODE_IP:          "$NODE_IP
LOG_DEBUG "TEST_PATH:        "$TEST_PATH
LOG_DEBUG "REBUILD_PROJECTS: "$REBUILD_PROJECTS
LOG_DEBUG "===<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< print config info finish.\n";

#-------------------------------------------

# ls -l

# cp -rf sql sql.tmp

# sed -i "s/localip.tars.com/$NODE_IP/g" `grep localip.tars.com -rl sql.tmp/tars-demo.sql`

# exec_mysql_sql db_tars sql.tmp/tars-demo.sql

# rm -rf sql.tmp

if [ $REBUILD_PROJECTS == "true" ]; then
	# ===============================build test projects=============================
	LOG_DEBUG "Building CPP"
	SERVERS_PATH=${TEST_PATH}/Servers
	# --------------------------------------cpp--------------------------------------
	rm -rf ${SERVERS_PATH}/CppServer/build
	mkdir -p ${SERVERS_PATH}/CppServer/build
	cd ${SERVERS_PATH}/CppServer/build
	cmake .. -DTARS_WEB_HOST=${WEB_HOST}
	make -j4
	make tar
	make upload

	#sleep 20000000
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

	# --------------------------------------golang--------------------------------------
	LOG_DEBUG "Building GoLang"
	cd ${SERVERS_PATH}/GoServer/GoHttp
	go mod vendor
	rm -rf *.tgz
	make tar
	cd ${SERVERS_PATH}/GoServer/GoTars
	go mod vendor
	rm -rf *.tgz
	make tar

	# --------------------------------------java--------------------------------------
	LOG_DEBUG "Building Java"
	cd ${SERVERS_PATH}/JavaServer/JavaHttp
	rm -rf ./target
	mvn package
	cd ${SERVERS_PATH}/JavaServer/JavaTars
	rm -rf ./target
	mvn package

	# --------------------------------------nodejs--------------------------------------
	LOG_DEBUG "Building Nodejs"
	source /root/.bashrc
	source /etc/profile
	npm install -g @tars/deploy
	cd ${SERVERS_PATH}/NodejsServer/NodejsHttp
	rm -rf *.tgz
	npm install
	tars-deploy NodejsHttp
	cd ${SERVERS_PATH}/NodejsServer/NodejsTars
	rm -rf *.tgz
	npm install
	tars-deploy NodejsTars
else
	LOG_DEBUG "Test directly using old packages"
fi

# ===============================run test=======================================
cd ${TEST_PATH}/PythonTestCase/
python3 run.py -u ${WEB_HOST} -n ${NODE_IP}
# python3 run.py -u ${WEB_HOST} -n ${NODE_IP}
