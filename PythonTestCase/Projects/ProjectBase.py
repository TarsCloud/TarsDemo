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
    def __init__(self, web_url, web_token):
        """The base Class of projects test case
        arguments
            web_url : the url of tars framework web
            web_token : the user token of tars framework web
        """
        if web_url is None:
            raise Exception('web_url is missing')
        if web_token is None:
            raise Exception('web_token is missing')
        self._web_url = web_url
        self._web_token = web_token
        self._total_test_cnt = 0
        self._succeed_tests = []
        self._failed_tests = []

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

    def _upload_and_publish(self, app_name, module_name, pkg_dir, pkg_name_prefix, pkg_ext):
        pkg_fname, pkg_name = self._get_pkg_fname(
            pkg_dir=pkg_dir,
            pkg_name_prefix=pkg_name_prefix,
            ext_len=len(pkg_ext))
        self._print_info("Publishing {0}.{1}".format(app_name, module_name))
        data = {
            "application": app_name,
            "module_name": module_name,
            "comment": "developer-auto-upload",
            "task_id": time.time(),
        }
        files = {'suse': (pkg_name, open(pkg_fname, "rb"))}
        headers = {
            "Content-Type": "multipart/form-data",
            'token': self._web_token
        }
        url = "{0}/api/upload_and_publish".format(self._web_url)
        result = requests.post(url=url, data=data, headers=headers, files=files)
        # TODO Deploy result check
        print(result)
        time.sleep(SERVANT_ACTIVATING_SECONDS)

    @staticmethod
    def _get_pkg_fname(pkg_dir, pkg_name_prefix, ext_len):
        pkg_name = ''
        with os.scandir(pkg_dir) as src_components:
            for src_component in src_components:
                if src_component.name.startswith(pkg_name_prefix):
                    pkg_name = src_component.name
        # pkg_name_prefix_timestamps.tar.gz len(.tar.gz) = 7
        if len(pkg_name) < len(pkg_name_prefix) + ext_len:
            raise Exception('Deploy package for {0} cannot be found.'.format(pkg_name_prefix))
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
        self._total_test_cnt += 1
        result = requests.get(test_case.format(self._web_url))
        if result != 'pong':
            self._failed_tests.append(test_case)
            self._print_err("request {0} failed".format(test_case))
        else:
            self._succeed_tests.append(test_case)
            self._print_succ("request {0} succeed".format(test_case))
