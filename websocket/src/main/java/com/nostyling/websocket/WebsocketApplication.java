package com.nostyling.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class WebsocketApplication {
    private final static Logger logger = LoggerFactory.getLogger(WebsocketApplication.class);


    /**
     * 打印 出配置中配置类的实际加载对象
     * @param platformTransactionManager
     * @return
     */
    @Bean
    public Object testBean(AmqpTemplate platformTransactionManager) {
        System.out.println(">>>>>>>>>>" + platformTransactionManager.getClass().getName());
        return new Object();
    }
    public static void main(String[] args) {

        SpringApplication.run(WebsocketApplication.class, args);
        logger.info("成功启动！");
    }

}
