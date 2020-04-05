#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# NodeJs test class
class NodeJsServant(Project):
    _app = 'Demo'
    _language = 'NodeJs'
    _http_port = 22004

    def publish(self):
        self._deploy_tars()
        self._deploy_http()

    def _deploy_http(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'Servers/NodejsServer/NodejsHttp')
        try:
            self._upload_and_publish(
                app_name=self._app,
                module_name='NodejsHttp',
                pkg_dir=prj_dir,
                pkg_name_prefix='NodejsHttp',
                pkg_ext='.tgz'
            )
            self.total_test_cnt += 1
            self.succeed_tests.append('Deploy Http')
        except Exception as e:
            self.total_test_cnt += 1
            self.failed_tests.append('Deploy Http')
            self._print_err("{0}: Http deploy failed.".format(self._language))

    def _deploy_tars(self):
        prj_dir = os.path.join(PROJECT_ROOT, 'Servers/NodejsServer/NodejsTars')
        try:
            self._upload_and_publish(
                app_name=self._app,
                module_name='NodejsTars',
                pkg_dir=prj_dir,
                pkg_name_prefix='NodejsTars',
                pkg_ext='.tgz'
            )
            self.total_test_cnt += 1
            self.succeed_tests.append('Deploy Tars')
        except Exception as e:
            self.total_test_cnt += 1
            self.failed_tests.append('Deploy Tars')
            self._print_err("{0}: Tars deploy failed.".format(self._language))

    def run_test(self):
        self._print_info("{0}: Start testing... ".format(self._language))
        self.ping_http()
        self.ping_tars()

    def ping_http(self):
        self._ping_http("{0}/test/ping")

    def ping_tars(self):
        self._ping_http("{0}/test/pingJs")
