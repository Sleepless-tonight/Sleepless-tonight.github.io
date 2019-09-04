package com.nostyling.websocket.rabbitmq.consumer;

import com.nostyling.websocket.rabbitmq.config.annotation.MyListener;
import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:57
 * @description: 测试私有队列的功能, 可以在RabbitMq管理平台看到spring.gen开头的队列，
 * 绑定到了{@link RabbitMQConstant#DEFAULT_EXCHANGE}，详见{@link MyListener}
 **/
@Slf4j
@Component
@Profile(SpringConstant.CONSUMER_EXCLUSIVE_PROFILE)
public class ExclusiveConsumer {

    @MyListener
    public void process(String message) {
        log.info("exclusive queue receive,id: {}, message:{}", message, message);
    }

    @MyListener
    public void process2(String message) {
        log.info("exclusive queue2 receive,id: {}, message:{}", message, message);
    }
}
