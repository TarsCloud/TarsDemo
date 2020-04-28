#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# PHP test class
class PHPServant(Project):
    _app = 'Demo'
    _language = 'PHP'
    _http_port = 22008
    _tars_port = 22009
    _http_serv_name = 'PHPHttp'
    _tars_serv_name = 'PHPTars'
    _obj = "HelloObj"
    _pkg_ext = '.tar.gz'
    _http_pub_build_path = 'Servers/PhpServer/PHPHttp/src'
    _tars_pub_build_path = 'Servers/PhpServer/PHPTars/src'
    _server_type = 'tars_php'
    _http_template_name = 'tars.tarsphp.default'
    _tars_template_name = 'tars.tarsphp.default'
    def test_http(self):
        self._ping_http("{0}/test/ping")

    def test_tars(self):
        self._ping_http("{0}/test/pingPHP")

