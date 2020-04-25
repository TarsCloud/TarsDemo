package com.qq.tars.quickstart.server.demo.impl;

import com.qq.tars.quickstart.server.demo.HelloServant;
import com.qq.tars.spring.annotation.TarsServant;

@TarsServant("HelloObj")
public class HelloServantImpl implements HelloServant {

    public String ping() {
        return "pong";
    }
}
