#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# Cpp test class
class CppServant(Project):
    _app = 'Demo'
    _language = 'Cpp'
    _http_port = 22000
    _tars_port = 22001
    _http_serv_name = 'CppHttp'
    _tars_serv_name = 'CppTars'
    _obj = "HelloObj"
    _pkg_ext = '.tgz'
    _http_pub_build_path = 'Servers/CppServer/build'
    _tars_pub_build_path = 'Servers/CppServer/build'
    _server_type = 'tars_cpp'
    _http_template_name = 'tars.cpp.default'
    _tars_template_name = 'tars.cpp.default'
    # wait specific seconds after service published 
    _wait_start_sec = 5

    def test_http(self):
        self._ping_http("{0}/test/ping")

    def test_tars(self):
        self._ping_http("{0}/test/pingCpp")
