# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os

TARGET_LANGUAGE = 'NodeJs'
APP_NAME = 'Demo'


# NodeJs test class
class NodeJsServant(Project):
    def publish(self):
        self._deploy_http()
        self._deploy_tars()

    def _deploy_http(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'NodejsServer/NodejsHttp')
        self._upload_and_publish(
            app_name=APP_NAME,
            module_name='NodejsHttp',
            pkg_dir=prj_dir,
            pkg_name_prefix='NodejsHttp',
            pkg_ext='.tgz'
        )

    def _deploy_tars(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'NodejsServer/NodejsTars')
        self._upload_and_publish(
            app_name=APP_NAME,
            module_name='NodejsTars',
            pkg_dir=prj_dir,
            pkg_name_prefix='NodejsTars',
            pkg_ext='.tgz'
        )

    def run_test(self):
        self._print_info("Start testing {0}".format(TARGET_LANGUAGE))
        self.ping_http()
        self.ping_tars()

    def ping_http(self):
        self._test_http_get("{0}/test/ping")

    def ping_tars(self):
        self._test_http_get("{0}/test/pingJs")

    def report(self):
        self._print_info("Language Name: {0}".format(TARGET_LANGUAGE))
        self._print_info("Total Cases: {0}".format(self._total_test_cnt))
        self._print_info("Succeed Cases: {0}".format(", ".join(self._succeed_tests)))
        self._print_info("Failed Cases: {0}".format(", ".join(self._failed_tests)))
