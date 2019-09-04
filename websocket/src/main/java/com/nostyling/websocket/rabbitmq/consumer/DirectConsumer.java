package com.nostyling.websocket.rabbitmq.consumer;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:56
 * @description:
 **/
@Component
@Slf4j
@Profile(SpringConstant.DIRECT_LISTENER_PROFILE)
public class DirectConsumer {

    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.DIRECT_EXCHANGE, type = ExchangeTypes.TOPIC,
                            durable = RabbitMQConstant.FALSE_CONSTANT, autoDelete = RabbitMQConstant.TRUE),
                    value = @Queue(value = RabbitMQConstant.DIRECT_QUEUE, durable = RabbitMQConstant.FALSE_CONSTANT,
                            autoDelete = RabbitMQConstant.TRUE),
                    key = RabbitMQConstant.DIRECT_KEY
            ),
            containerFactory = "directRabbitListenerContainerFactory"
    )
    public void process(String event) {
        log.info("direct container receive message:{} ", event);
    }
}
