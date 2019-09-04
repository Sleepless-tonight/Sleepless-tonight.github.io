package com.nostyling.websocket.rabbitmq.consumer;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitHandler;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:59
 * @description:
 **/
@Component
@Slf4j
@RabbitListener(
        bindings = @QueueBinding(
                exchange = @Exchange(value = RabbitMQConstant.MULTIPART_HANDLE_EXCHANGE, type = ExchangeTypes.TOPIC,
                        durable = RabbitMQConstant.FALSE_CONSTANT, autoDelete = RabbitMQConstant.TRUE),
                value = @Queue(value = RabbitMQConstant.MULTIPART_HANDLE_QUEUE, durable = RabbitMQConstant.FALSE_CONSTANT,
                        autoDelete = RabbitMQConstant.TRUE),
                key = RabbitMQConstant.MULTIPART_HANDLE_KEY
        )
)
@Profile(SpringConstant.MULTIPART_PROFILE)
public class MultipartConsumer {

    /**
     * RabbitHandler 用于有多个方法时但是参数类型不能一样，否则会报错
     *
     * @param msg
     */
    @RabbitHandler
    public void process(String msg) {
        log.info("param:{msg = [" + msg + "]} info:");
    }

    @RabbitHandler
    public void processMessage2(Date msg) {
        log.info("param:{msg2 = [" + msg + "]} info:");
    }

    /**
     * 下面的多个消费者，消费的类型不一样没事，不会被调用，但是如果缺了相应消息的处理Handler则会报错
     *
     * @param msg
     */
    @RabbitHandler
    public void processMessage3(Integer msg) {
        log.info("param:{msg3 = [" + msg + "]} info:");
    }


}
