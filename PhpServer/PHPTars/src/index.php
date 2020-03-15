<?php
/**
 * 框架启动的入口文件
 */
require_once __DIR__.'/vendor/autoload.php';

use \Tars\cmd\Command;

//php index.php  conf restart
$config_path = $argv[1];
$pos = strpos($config_path, '--config=');

$config_path = substr($config_path, $pos + 9);

$cmd = strtolower($argv[2]);

$class = new Command($cmd, $config_path);
$class->run();