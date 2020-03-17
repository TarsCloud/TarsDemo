# coding: utf-8
from abc import ABCMeta, abstractmethod

PROJECT_ROOT = '../../'


# 项目基类
class Project(metaclass=ABCMeta, web_url=None, web_token=None):
    def __init__(self,web_url, web_token):
        if web_url is None:
            raise Exception('web_url is missing')
        if web_token is None:
            raise Exception('web_token is missing')

    @abstractmethod
    def deploy(self):
        pass

    @abstractmethod
    def ping_http(self):
        pass

    @abstractmethod
    def ping_tars(self):
        pass

