#!/usr/bin/python3
# coding: utf-8

from Projects.PHP import PHPServant
from Projects.GoLang import GoLangServant
from Projects.NodeJs import NodeJsServant
from Projects.Java import JavaServant
from Projects.Cpp import CppServant
import threading as td
import time
import optparse
import sys
import importlib

importlib.reload(sys)

# get web url and user token from runtime parameters
def get_web_url_and_token():
    usage = "python %prog -u/--url <the url of framework web> -n/--nodeip <the ip of your application node> -t/--target <the target application to test>"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option('-u', '--url', dest='url', type='string', help='the url of framework web', default='')
    parser.add_option('-n', '--nodeip', dest='nodeip', type='string', help='the ip of your application node')
    options, _ = parser.parse_args()
    if options.url is None:
        parser.print_help()
        exit(1)
    if options.nodeip is None:
        parser.print_help()
        exit(1)
    return options.url, options.nodeip


# publish and test servants in multi-threading
def publish_and_test_servants():
    # publish
    php_testcase = td.Thread(target=php_serv.deploy_publish_and_test, args=())
    php_testcase.start()

    golang_testcase = td.Thread(target=golang_serv.deploy_publish_and_test, args=())
    golang_testcase.start()

    nodejs_testcase = td.Thread(target=nodejs_serv.deploy_publish_and_test, args=())
    nodejs_testcase.start()

    java_testcase = td.Thread(target=java_serv.deploy_publish_and_test, args=())
    java_testcase.start()

    cpp_testcase = td.Thread(target=cpp_serv.deploy_publish_and_test, args=())
    cpp_testcase.start()

    # wait
    php_testcase.join()
    golang_testcase.join()
    nodejs_testcase.join()
    java_testcase.join()
    cpp_testcase.join()


# get runtime parameters
url, nodeip = get_web_url_and_token()

# initialize languages test cases
php_serv = PHPServant(url, nodeip)
golang_serv = GoLangServant(url, nodeip)
nodejs_serv = NodeJsServant(url, nodeip)
java_serv = JavaServant(url, nodeip)
cpp_serv = CppServant(url, nodeip)

t1 = time.time()

if __name__ == '__main__':
    print("=====================================Publishing And Testing======================================")
    # deploy servant
    publish = td.Thread(target=publish_and_test_servants)
    publish.start()
    publish.join()

    # report
    print("============================================Reporting============================================")
    php_serv.report()
    golang_serv.report()
    nodejs_serv.report()
    java_serv.report()
    cpp_serv.report()

    failed_total = 0
    failed_total += len(php_serv.failed_tests)
    failed_total += len(golang_serv.failed_tests)
    failed_total += len(nodejs_serv.failed_tests)
    failed_total += len(java_serv.failed_tests)
    failed_total += len(cpp_serv.failed_tests)

    t2 = time.time()
    duration = t2 - t1
    print("Duration: {0} seconds".format(duration))

    if failed_total > 0:
        exit(255)

    exit(0)