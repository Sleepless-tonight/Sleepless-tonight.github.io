package com.nostyling.websocket.rabbitmq.consumer;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Argument;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.context.annotation.Profile;
import org.springframework.messaging.handler.annotation.Headers;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:55
 * @description:
 **/
@Component
@Profile(SpringConstant.DEAD_LETTER_PROFILE)
@Slf4j
public class DeadLetterConsumer {

    /**
     * 下面的在声明了一个队列，给了{@linkplain RabbitMQConstant#DEAD_LETTER_EXCHANGE 死信队列的交换器},并且给了一个
     * 消息的{@linkplain RabbitMQConstant#DEAD_LETTER_KEY RouteKey}.key默认是监听队列的名字，可以不提供，如果成功，
     * 可以在web控制台看到queue的Features有DLX(死信队列交换器)和DLK(死信队列绑定)。
     * 下面的消费者失败三次后发送nack，消息转入死信队列。
     * 这里要说一个我踩的坑，{@link Queue}中有个参数{@link Queue#arguments}，
     * 我当时把死信队列的参数设置到了{@link QueueBinding#arguments()}，所以导致绑定死信队列不成功。
     * 最后通过在web控制台观察发现的。
     *
     * @param headers
     * @param msg
     */
    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.DEFAULT_EXCHANGE, type = ExchangeTypes.TOPIC,
                            durable = RabbitMQConstant.FALSE_CONSTANT, autoDelete = RabbitMQConstant.TRUE),
                    value = @Queue(value = RabbitMQConstant.DEFAULT_QUEUE, durable = RabbitMQConstant.FALSE_CONSTANT,
                            autoDelete = RabbitMQConstant.TRUE, arguments = {
                            @Argument(name = RabbitMQConstant.DEAD_LETTER_EXCHANGE, value = RabbitMQConstant.DEAD_EXCHANGE),
                            @Argument(name = RabbitMQConstant.DEAD_LETTER_KEY, value = RabbitMQConstant.DEAD_KEY)
                    }),
                    key = RabbitMQConstant.DEFAULT_KEY
            ))
    @SneakyThrows
    public void process(@Headers Map <String, Object> headers, @Payload String msg) {
        log.info("retry consumer receive message:{headers = [" + headers + "], msg = [" + msg + "]}");
        throw new RuntimeException();
    }

    /**
     * 声明死信队列并监听,key采用了#，表示监听所有消息
     *
     * @param headers
     * @param msg
     */
    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.DEAD_EXCHANGE),
                    value = @Queue(value = RabbitMQConstant.DEAD_QUEUE, durable = RabbitMQConstant.TRUE),
                    key = "#"
            )
    )
    public void deadListener(@Headers Map <String, Object> headers, @Payload String msg) {
        log.info("dead consumer receive message:{headers = [" + headers + "], msg = [" + msg + "]}");
    }
}
