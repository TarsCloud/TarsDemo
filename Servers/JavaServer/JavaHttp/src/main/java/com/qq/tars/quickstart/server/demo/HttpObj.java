package com.qq.tars.quickstart.server.demo;

import com.qq.tars.spring.annotation.TarsClient;
import com.qq.tars.spring.annotation.TarsHttpService;
import com.qq.tars.spring.annotation.TarsServant;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@TarsHttpService("HelloObj")
@RestController
public class HttpObj {

    @TarsClient(name = "Demo.JavaTars.HelloObj")
    HelloPrx helloPrx;

    HttpObj() {
        
    }
    
    @RequestMapping(path = "/test/ping", method = RequestMethod.GET)
    @ResponseBody
    public String ping() {
        return "pong";
    }

    @RequestMapping(path = "/test/pingJava", method = RequestMethod.GET)
    @ResponseBody
    public String pingJava() {
        return helloPrx.ping();
    }
}
