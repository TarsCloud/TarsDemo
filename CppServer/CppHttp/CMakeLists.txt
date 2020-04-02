cmake_minimum_required(VERSION 2.8)

project(Demo-CppHttp)

gen_server(Demo CppHttp)

add_dependencies(CppHttp CppTars)
#target_link_libraries(mysqlclient ssl crypto nghttp2-static)
