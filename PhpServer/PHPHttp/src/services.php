<?php
return [
    'HelloObj' => [
        'namespaceName' => 'PHPHttp\\',
        'saveTarsConfigFileDir' => 'src/conf/',
        'saveTarsConfigFileName' => ['',],
        'monitorStoreConf' => [
            //使用redis缓存主调上报信息
            //'className' => Tars\monitor\cache\RedisStoreCache::class,
            //'config' => [
            // 'host' => '127.0.0.1',
            // 'port' => 6379,
            // 'password' => ':'
            //],
            //使用swoole_table缓存主调上报信息（默认）
            'className' => Tars\monitor\cache\SwooleTableStoreCache::class,
            'config' => [
                'size' => 40960
            ]
        ],
        'registryStoreConf' => [
            'className' => Tars\registry\RouteTable::class,
            'config' => [
                'size' => 200
            ]
        ],
        'protocolName' => 'http',
        'serverType' => 'http',
    ],
];
