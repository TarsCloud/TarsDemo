<?php

namespace PHPHttp\controller;

use PHPHttp\component\Controller;
use PHPHttp\servant\Demo\PHPTars\HelloObj\Hello;
use Tars\client\CommunicatorConfig;
use Tars\App;

class TestController extends Controller
{
    public function actionPing()
    {
        $this->sendRaw('pong');
    }

    public function actionPingPHP()
    {
        $config = new CommunicatorConfig();
        $config->setLocator(App::$tarsConfig['tars']['application']['client']['locator']);

        try {
            $servant = new Hello($config);
            $result = $servant->ping();
        } catch (\Exception $e) {
            $result = 'Exception raised while ping PHPTars:' . $e->getMessage();
        }

        $this->sendRaw($result);
    }
}
