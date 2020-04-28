#!/usr/bin/python3
# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os
import time
from Utils import TestUtils

# Java test class
class JavaServant(Project):
    _app = 'Demo'
    _language = 'Java'
    _http_port = 22002
    _tars_port = 22003
    _http_serv_name = 'JavaHttp'
    _tars_serv_name = 'JavaTars'
    _obj = "HelloObj"
    _pkg_ext = '.jar'
    _http_pub_build_path = 'Servers/JavaServer/JavaHttp/target'
    _tars_pub_build_path = 'Servers/JavaServer/JavaTars/target'
    _server_type = 'tars_java'
    _http_template_name = 'tars.springboot'
    _tars_template_name = 'tars.springboot'

    def test_http(self):
        self._ping_http("{0}/test/ping")

    def test_tars(self):
        self._ping_http("{0}/test/pingJava")

