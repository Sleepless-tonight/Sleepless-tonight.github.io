package com.nostyling.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class WebsocketApplication {
    private final static Logger logger = LoggerFactory.getLogger(WebsocketApplication.class);
    public static void main(String[] args) {
        SpringApplication.run(WebsocketApplication.class, args);
        logger.info("成功启动！");
    }

}
