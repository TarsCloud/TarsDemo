<?php

namespace PHPTars\impl;

use PHPTars\servant\Demo\PHPTars\HelloObj\Hello;

class Demo implements Hello
{
    public function ping()
    {
        return 'pong';
    }
}
