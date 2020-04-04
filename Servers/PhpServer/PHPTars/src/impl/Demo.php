<?php

namespace PHPTars\impl;

use PHPTars\servant\Demo\PHPTars\HelloObj\HelloServant;

class Demo implements HelloServant
{
    public function ping()
    {
        return 'pong';
    }
}
