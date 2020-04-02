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
    deploy_php = td.Thread(target=php_serv.publish_and_test, args=())
    deploy_php.start()
    # deploy_golang = td.Thread(target=golang_serv.publish_and_test, args=())
    # deploy_golang.start()
    # deploy_nodejs = td.Thread(target=nodejs_serv.publish_and_test, args=())
    # deploy_nodejs.start()
    # deploy_java = td.Thread(target=java_serv.publish_and_test, args=())
    # deploy_java.start()
    # deploy_cpp = td.Thread(target=cpp_serv.publish_and_test, args=())
    # deploy_cpp.start()

    # wait
    deploy_php.join()
    # deploy_golang.join()
    # deploy_nodejs.join()
    # deploy_java.join()
    # deploy_cpp.join()


# get runtime parameters
url, nodeip = get_web_url_and_token()

# initialize languages test cases
php_serv = PHPServant(url, nodeip)
# golang_serv = GoLangServant(url, token)
# nodejs_serv = NodeJsServant(url, token)
# java_serv = JavaServant(url, token)
# cpp_serv = CppServant(url, token)

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
    # golang_serv.report()
    # nodejs_serv.report()
    # java_serv.report()
    # cpp_serv.report()

    failed_total = 0
    failed_total += len(php_serv.failed_tests)
    # failed_total += len(golang_serv.failed_tests)
    # failed_total += len(nodejs_serv.failed_tests)
    # failed_total += len(java_serv.failed_tests)
    # failed_total += len(cpp_serv.failed_tests)

    t2 = time.time()
    duration = t2 - t1
    print("Duration: {0} seconds".format(duration))

    if failed_total > 0:
        exit(255)
