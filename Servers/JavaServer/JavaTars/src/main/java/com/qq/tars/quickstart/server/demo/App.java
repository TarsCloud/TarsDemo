package com.qq.tars.quickstart.server.demo;

import com.qq.tars.spring.annotation.EnableTarsServer;
import com.qq.tars.spring.annotation.TarsServant;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableTarsServer
public class App {
     
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);

    }
}
