#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# NodeJs test class
class NodeJsServant(Project):
    _app = 'Demo'
    _language = 'NodeJs'
    _http_port = 22004
    _tars_port = 22005
    _http_serv_name = 'NodejsHttp'
    _tars_serv_name = 'NodejsTars'
    _obj = "HelloObj"
    _pkg_ext = '.tgz'
    _http_pub_build_path = 'Servers/NodejsServer/NodejsHttp'
    _tars_pub_build_path = 'Servers/NodejsServer/NodejsTars'
    _server_type = 'tars_nodejs'
    _http_template_name = 'tars.nodejs.default'
    _tars_template_name = 'tars.nodejs.default'

    def test_http(self):
        self._ping_http("{0}/test/ping")

    def test_tars(self):
        self._ping_http("{0}/test/pingJs")
