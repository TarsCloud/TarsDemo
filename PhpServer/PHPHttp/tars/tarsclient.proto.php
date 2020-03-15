<?php

return array(
    'appName' => 'Demo',
    'serverName' => 'PHPTars',
    'objName' => 'HelloObj',
    'withServant' => false, //决定是服务端,还是客户端的自动生成
    'tarsFiles' => array(
        './php.tars'
    ),
    'dstPath' => '../src/servant',
    'namespacePrefix' => 'PHPHttp\servant',
);
