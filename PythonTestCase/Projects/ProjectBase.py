#!/usr/bin/python3
# coding: utf-8
from abc import ABCMeta, abstractmethod
import os
import time
import requests

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
# sleep specific time after service publishing to wait for service activating
SERVANT_ACTIVATING_SECONDS = 30


# Project Base Class
class Project(metaclass=ABCMeta):
    _app = 'Demo'
    _language = 'Base'
    _http_port = 80

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

    @abstractmethod
    def publish(self):
        pass

    @abstractmethod
    def ping_http(self):
        pass

    @abstractmethod
    def ping_tars(self):
        pass

    @abstractmethod
    def report(self):
        pass

    @abstractmethod
    def run_test(self):
        pass

    def publish_and_test(self):
        self.publish()
        self.run_test()
        return

    def _upload_and_publish(self, app_name, module_name, pkg_dir, pkg_name_prefix, pkg_ext):
        pkg_fname, pkg_name = self._get_pkg_fname(
            pkg_dir=pkg_dir,
            pkg_name_prefix=pkg_name_prefix,
            ext_len=len(pkg_ext))
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
            raise Exception("{0}: Deploy failed: {1}".format(self._language, str(resp.content())))
        time.sleep(SERVANT_ACTIVATING_SECONDS)

    def _get_pkg_fname(self, pkg_dir, pkg_name_prefix, ext_len):
        pkg_name = ''
        with os.scandir(pkg_dir) as src_components:
            for src_component in src_components:
                if src_component.name.startswith(pkg_name_prefix):
                    pkg_name = src_component.name
        # pkg_name_prefix_timestamps.tar.gz len(.tar.gz) = 7
        if len(pkg_name) < len(pkg_name_prefix) + ext_len:
            raise Exception('{0}: Deploy package for {1} cannot be found.'.format(self._language, pkg_name_prefix))
        pkg_fname = os.path.join(pkg_dir, pkg_name)
        return pkg_fname, pkg_name

    @staticmethod
    def _print_err(content):
        print("\033[31m{0} \033[0m".format(content))

    @staticmethod
    def _print_succ(content):
        print("\033[32m{0} \033[0m".format(content))

    @staticmethod
    def _print_info(content):
        print("\033[34m{0} \033[0m".format(content))

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
        except BaseException:
            self.failed_tests.append(test_case)
            self._print_err("{0}: Request {1} exception raised".format(self._language, test_case))
    
    def report(self):
        self._print_info("{0}: Total Cases Count: {1}".format(self._language, self.total_test_cnt))
        self._print_succ("{0}: Succeed Cases Count: {1}".format(self._language, len(self.succeed_tests)))
        self._print_succ("{0}: Succeed Cases: {1}".format(self._language, ", ".join(self.succeed_tests)))
        self._print_err("{0}: Failed Cases Count: {1}".format(self._language, len(self.failed_tests)))
        self._print_err("{0}: Failed Cases: {1}".format(self._language, ", ".join(self.failed_tests)))
