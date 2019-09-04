package com.nostyling.websocket.rabbitmq.publish;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:40
 * @description:
 **/
@Component
public class Publisher {

    AtomicInteger id = new AtomicInteger();

    @Autowired
    RabbitTemplate rabbitTemplate;

    /**
     * 普通消息
     */
    @Scheduled(fixedDelay = 5 * 1000)
    public void sendTestMessage() {
        rabbitTemplate.convertAndSend(RabbitMQConstant.DEFAULT_EXCHANGE, RabbitMQConstant.DEFAULT_KEY,
                new Date());
    }
}
