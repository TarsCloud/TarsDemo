# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os
import requests
import time

TARGET_LANGUAGE = 'PHP'
APP_NAME = 'Demo'


# PHP test class
class PHPServant(Project):
    def deploy(self):
        self._deploy_http()
        self._deploy_tars()

    def _deploy_http(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'PhpServer/PHPHttp')
        pkg_dir = os.path.join(prj_dir, 'src')
        self._upload_and_publish(
            app_name=APP_NAME,
            module_name='PHPHttp',
            pkg_dir=pkg_dir,
            pkg_name_prefix='PHPHttp',
            pkg_ext='.tar.gz'
        )

    def _deploy_tars(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'PhpServer/PHPTars')
        pkg_dir = os.path.join(prj_dir, 'src')
        self._upload_and_publish(
            app_name=APP_NAME,
            module_name='PHPTars',
            pkg_dir=pkg_dir,
            pkg_name_prefix='PHPTars',
            pkg_ext='.tar.gz'
        )

    def run_test(self):
        self.ping_http()
        self.ping_tars()

    def ping_http(self):
        self._test_http_get("{0}/test/ping")

    def ping_tars(self):
        self._test_http_get("{0}/test/pingPHP")

    def report(self):
        self._print_info("Language Name: {0}".format(TARGET_LANGUAGE))
        self._print_info("Total Cases: {0}".format(self._total_test_cnt))
        self._print_info("Succeed Cases: {0}".format(", ".join(self._succeed_tests)))
        self._print_info("Failed Cases: {0}".format(", ".join(self._failed_tests)))
