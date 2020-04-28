#!/usr/bin/python3
# coding: utf-8
from abc import ABCMeta, abstractmethod
import os
import time
import requests
import random
import json
from Utils import TestUtils

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))

# Project Base Class
class Project(metaclass=ABCMeta):
    # application name
    _app = 'Demo'
    # the language of test project
    _language = 'Base'
    # the port of http test servant
    _http_port = 80
    # the port of tars test servant
    _tars_port = 80
    # the server name of http test servant
    _http_serv_name = ''
    # the server name of tars test servant
    _tars_serv_name = ''
    # the obj name of test application
    _obj = "HelloObj"
    # the publish package extension name
    _pkg_ext = ''
    # the publish package directories
    _http_pub_build_path = ''
    _tars_pub_build_path = ''
    # the type of test servant. for example: tars_cpp, tars_java, tars_node, tars_php, tars_go
    _server_type = ''
    # the template name of each test servant
    _http_template_name = ''
    _tars_template_name = ''

    def __init__(self, web_url, node_ip):
        """The base Class of projects test case
        arguments
            web_url : the url of tars framework web
            node_ip : the ip of your tarsnode
        """
        if web_url is None:
            raise Exception('web_url is missing')
        self._web_url = web_url
        self._node_ip = node_ip
        self._node_http_url = "http://{0}:{1}".format(self._node_ip, self._http_port)
        self.total_test_cnt = 0
        self.succeed_tests = []
        self.failed_tests = []

    # deploy testing servers
    def deploy(self):
        self._deploy_tars()
        self._deploy_http()
    
    def _deploy_http(self):
        data = {
            "application":self._app,
            "server_name":self._http_serv_name,
            "node_name":self._node_ip,
            "server_type":self._server_type,
            "template_name":self._http_template_name,
            "enable_set": False,
            "set_name": "",
            "set_area": "",
            "set_group": "",
            "adapters": [
                {
                    "obj_name": self._obj,
                    "bind_ip": self._node_ip,
                    "port": self._http_port,
                    "port_type": "tcp",
                    "protocol": "not_tars",
                    "thread_num": 5,
                    "max_connections":2000,
                    "queuecap": 1000,
                    "queuetimeout": 60000,
                }
            ]
        }
        try:
            self._deploy_server(data)
        except BaseException as e:
            self._print_err("{0}: _deploy_http: {1}".format(self._language, e))

    def _deploy_tars(self):
        data = {
            "application":self._app,
            "server_name":self._tars_serv_name,
            "node_name":self._node_ip,
            "server_type":self._server_type,
            "template_name":self._tars_template_name,
            "enable_set": False,
            "set_name": "",
            "set_area": "",
            "set_group": "",
            "adapters": [
                {
                    "obj_name": self._obj,
                    "bind_ip": self._node_ip,
                    "port": self._tars_port,
                    "port_type": "tcp",
                    "protocol": "tars",
                    "thread_num": 5,
                    "max_connections":2000,
                    "queuecap": 1000,
                    "queuetimeout": 60000,
                }
            ]
        }
        try:
            self._deploy_server(data)
        except BaseException as e:
            self._print_err("{0}: _deploy_tars: {1}".format(self._language, e))

    def _deploy_server(self, server_conf):
        url = "{0}/api/deploy_server".format(self._web_url)
        headers = {
            "content-type": "application/json"
        }
        resp = requests.post(url, data=json.dumps(server_conf), headers=headers)
        resp.encoding = 'utf-8'

        if resp.ok is True and resp.status_code == 200 :
            return True
        else:
            self._print_err(resp.content)
            raise Exception('Deploy server failed.')

    # publish servers
    def publish(self):
        self._publish_tars()
        self._publish_http()

    # publish http server
    def _publish_http(self):
        prj_dir = os.path.join(PROJECT_ROOT, self._http_pub_build_path)
        try:
            self._upload_and_publish(
                app_name=self._app,
                module_name=self._http_serv_name,
                pkg_dir=prj_dir,
                pkg_name_prefix=self._http_serv_name,
                pkg_ext=self._pkg_ext
            )
            self.total_test_cnt += 1
            self.succeed_tests.append('Publish Http')
        except Exception as e:
            self.total_test_cnt += 1
            self.failed_tests.append('Publish Http')
            self._print_err("{0}: Http publish failed.".format(self._language))

    # publish tars server
    def _publish_tars(self):
        prj_dir = os.path.join(PROJECT_ROOT, self._tars_pub_build_path)
        try:
            self._upload_and_publish(
                app_name=self._app,
                module_name=self._tars_serv_name,
                pkg_dir=prj_dir,
                pkg_name_prefix=self._tars_serv_name,
                pkg_ext=self._pkg_ext
            )
            self.total_test_cnt += 1
            self.succeed_tests.append('Publish Tars')
        except Exception as e:
            self.total_test_cnt += 1
            self.failed_tests.append('Publish Tars')
            self._print_err("{0}: Tars publish failed.".format(self._language))

    @abstractmethod
    def test_http(self):
        pass

    @abstractmethod
    def test_tars(self):
        pass

    # run http and tars test after servers are activated
    def run_test(self):
        self._print_info("{0}: Start testing...".format(self._language))
        util = TestUtils(self._app, self._web_url)
        httpActived = False
        while httpActived is False :
            httpActived = util.is_server_activated(self._http_serv_name)
            if httpActived is False:
                self._print_info("Wait {0} activating...".format(self._http_serv_name))
            time.sleep(1)
        # wait 5 seconds incase service doesn't fully activated
        time.sleep(5)
        self.test_http()
        tarsActived = False
        while tarsActived is False :
            tarsActived = util.is_server_activated(self._tars_serv_name)
            time.sleep(1)
        self.test_tars()

    def deploy_publish_and_test(self):
        self.deploy()
        self.publish()
        self.run_test()
        return

    # upload build packages and publish server
    def _upload_and_publish(self, app_name, module_name, pkg_dir, pkg_name_prefix, pkg_ext):
        pkg_fname, pkg_name = self._get_pkg_fname(
            pkg_dir=pkg_dir,
            pkg_name_prefix=pkg_name_prefix,
            pkg_ext=pkg_ext)
        self._print_info("Publishing {0}.{1}".format(app_name, module_name))
        payload = {
            'application': app_name,
            'module_name': module_name,
            'comment': 'developer-auto-upload',
            'task_id': time.time()
        }
        files = {'suse': (pkg_name, open(pkg_fname,'rb'))}
        headers = {
            # 'Content-Type': 'multipart/form-data',
            # 'Cookie': 'dcache=true'
        }
        url = "{0}/pages/server/api/upload_and_publish".format(self._web_url)
        resp = requests.request("POST", url, headers=headers, data = payload, files = files)
        self._print_info("{0}: resp:\n{1}".format(self._language, resp.text))
        # TODO Deploy result check
        if resp.ok is not True:
            self._print_err("{0}: Deploy failed: {1}".format(self._language, str(resp.content())))
            raise Exception("{0}: Deploy failed: {1}".format(self._language, str(resp.content())))

    # search publish package under pkg_dir
    def _get_pkg_fname(self, pkg_dir, pkg_name_prefix, pkg_ext):
        pkg_name = ''
        ext_len = len(pkg_ext)
        with os.scandir(pkg_dir) as src_components:
            for src_component in src_components:
                if src_component.name.startswith(pkg_name_prefix) and src_component.name.endswith(pkg_ext):
                    pkg_name = src_component.name
        # pkg_name_prefix_timestamps.tar.gz len(.tar.gz) = 7
        if len(pkg_name) < len(pkg_name_prefix) + ext_len:
            self._print_err('{0}: Deploy package for {1} cannot be found.'.format(self._language, pkg_name_prefix))
            raise Exception('{0}: Deploy package for {1} cannot be found.'.format(self._language, pkg_name_prefix))
            
        pkg_fname = os.path.join(pkg_dir, pkg_name)
        self._print_info('{0}: Package found {1}.'.format(self._language, pkg_fname))
        return pkg_fname, pkg_name
    
    @staticmethod
    def _print_err(content):
        print("\033[31m{0} \033[0m".format(content))

    @staticmethod
    def _print_succ(content):
        print("\033[32m{0} \033[0m".format(content))

    @staticmethod
    def _print_info(content):
        # print("\033[34m{0} \033[0m".format(content))
        print(content)

    # ping specific path using http get
    def _ping_http(self, test_case):
        self.total_test_cnt += 1
        self._print_info("{0}: {1}".format(self._language, test_case.format(self._node_http_url)))
        try:
            resp = requests.get(test_case.format(self._node_http_url))
            self._print_info("{0}: {1}".format(self._language, resp.text))
            if resp.text == 'pong' and resp.ok is True:
                self.succeed_tests.append(test_case)
                self._print_succ("{0}: Request {1} succeed".format(self._language, test_case))
            else:
                self.failed_tests.append(test_case)
                self._print_err("{0}: Request {1} failed".format(self._language, test_case))
        except BaseException as e:
            self.failed_tests.append(test_case)
            self._print_err("{0}: Request {1} exception raised:{2}".format(self._language, test_case, e))
    
    # report test results
    def report(self):
        self._print_info("{0}: Total Cases Count: {1}".format(self._language, self.total_test_cnt))
        if len(self.succeed_tests) > 0:
            self._print_succ("{0}: Succeed Cases Count: {1}".format(self._language, len(self.succeed_tests)))
            self._print_succ("{0}: Succeed Cases: {1}".format(self._language, ", ".join(self.succeed_tests)))
        if len(self.failed_tests) > 0:
            self._print_err("{0}: Failed Cases Count: {1}".format(self._language, len(self.failed_tests)))
            self._print_err("{0}: Failed Cases: {1}".format(self._language, ", ".join(self.failed_tests)))
