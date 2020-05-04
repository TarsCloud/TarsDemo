#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# GoLang test class
class GoLangServant(Project):
    _app = 'Demo'
    _language = 'Golang'
    _http_port = 22006
    _tars_port = 22007
    _http_serv_name = 'GoHttp'
    _tars_serv_name = 'GoTars'
    _obj = "HelloObj"
    _pkg_ext = '.tgz'
    _http_pub_build_path = 'Servers/GoServer/GoHttp'
    _tars_pub_build_path = 'Servers/GoServer/GoTars'
    _server_type = 'tars_go'
    _http_template_name = 'tars.default'
    _tars_template_name = 'tars.default'
    # wait specific seconds after service published 
    _wait_start_sec = 5

    def test_http(self):
        self._ping_http("{0}/test/ping")

    def test_tars(self):
        self._ping_http("{0}/test/pingGo")
