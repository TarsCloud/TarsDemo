# coding: utf-8
from ProjectBase import Project, PROJECT_ROOT
import os


# PHP http test class
class PHPHttp(Project):
    def deploy(self):
        dirs = os.scandir(PROJECT_ROOT)
        print(dirs)

    def ping_http(self):
        print("ping http")

    def ping_tars(self):
        print("ping tars")

