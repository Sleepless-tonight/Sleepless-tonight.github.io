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
import org.springframework.messaging.handler.annotation.Headers;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 19:10
 * @description:
 **/
@Component
@Profile(SpringConstant.REPLY_PROFILE)
@Slf4j
public class ReplyConsumer {

    public static final String REPLY = "reply";
    public static final String REPLY_QUEUE = "queue.reply.s";

    /**
     * 只在收到的消息没有reply-to属性时使用，
     * sendTo里面的格式 exchange/routingKey 下面四种：
     *
     * <li>foo/bar： 指定的交换器和key</li>
     * <li>foo/： 指定的交换器，key为空</li>
     * <li>bar或者/bar： 到空交换器</li>
     * <li>/或者空：空的交换器和空的key</li>
     *
     *
     * <p>
     * 因为默认所有的队列都会绑定到空交换器，并且以队列名字作为Routekey，
     * 所以{@link SendTo}里面可以直接填写队列名字机会发送到相应的队列.如日志队列
     * </p>
     */
    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.REPLY_EXCHANGE, type = ExchangeTypes.TOPIC,
                            durable = RabbitMQConstant.FALSE_CONSTANT, autoDelete = RabbitMQConstant.TRUE),
                    value = @Queue(value = RabbitMQConstant.REPLY_QUEUE, durable = RabbitMQConstant.FALSE_CONSTANT,
                            autoDelete = RabbitMQConstant.TRUE),
                    key = RabbitMQConstant.REPLY_KEY
            )
    )
    @SendTo(REPLY_QUEUE)
    public String log(String event) {
        log.info("log receive message:O{}", event);
        return new String("log result");
    }

    /**
     * rpc模式，客户端采用{@link RabbitTemplate#convertSendAndReceive}系列方法
     *
     * @param headers
     * @param msg
     *
     * @return
     */
    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.RPC_EXCHANGE, type = ExchangeTypes.TOPIC),
                    value = @Queue(value = RabbitMQConstant.RPC_QUEUE, durable = RabbitMQConstant.TRUE),
                    key = RabbitMQConstant.RPC_KEY
            )
    )
    public String receive(@Headers Map <String, Object> headers, @Payload String msg) {
        log.info("reply to consumer param:{headers = [" + headers + "], msg = [" + msg + "]} info:");
        return REPLY;
    }

    /**
     * 为声明绑定，默认绑定到默认交换器，以队列名字为routeKey
     *
     * @param event
     */
    @RabbitListener(queuesToDeclare = @Queue(name = ReplyConsumer.REPLY_QUEUE))
    public void logResult(String event) {
        log.info("log receive message:O{}", event);
    }
}
