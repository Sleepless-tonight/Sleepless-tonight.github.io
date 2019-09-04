package com.nostyling.websocket.rabbitmq.util;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Argument;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-29 16:19
 * @description: ignoreDeclarationExceptions表示允许声明的不一致,
 * arguments声明参数信息,
 **/
@Component
public class MyRabbitMQUtil {
    private final static Logger logger = LoggerFactory.getLogger(MyRabbitMQUtil.class);

    @Autowired
    private AmqpAdmin amqpAdmin;
    @Autowired
    private AmqpTemplate amqpTemplate;

    @RabbitListener(
            bindings = @QueueBinding(
                    exchange = @Exchange(value = RabbitMQConstant.FROM_OMS_EXCHANGE, type = ExchangeTypes.DIRECT,
                            durable = RabbitMQConstant.DEFAULT_EXCHANGE_DURABLE, autoDelete = RabbitMQConstant.DEFAULT_EXCHANGE_AUTO_DELETE),
                    value = @Queue(value = RabbitMQConstant.FROM_OMS_DELIVER_ORDER_KEY, durable = RabbitMQConstant.DEFAULT_QUEUE_DURABLE,
                            autoDelete = RabbitMQConstant.DEFAULT_QUEUE_AUTO_DELETE),
                    key = RabbitMQConstant.FROM_OMS_DELIVER_ORDER_KEY,
                    ignoreDeclarationExceptions = "true",
                    arguments = @Argument(name = "x-message-ttl", value = "10000", type = "java.lang.Integer")

            ),
            //手动指明消费者的监听容器，默认Spring为自动生成一个SimpleMessageListenerContainer
            //containerFactory = "container",
            //指定消费者的线程数量,一个线程会打开一个Channel，一个队列上的消息只会被消费一次（不考虑消息重新入队列的情况）,下面的表示至少开启5个线程，最多10个。线程的数目需要根据你的任务来决定，如果是计算密集型，线程的数目就应该少一些
            concurrency = "5-10"
    )
    public void processMessage(Channel channel, long deliveryTag,
                               @Header("amqp_redelivered") boolean redelivered, String content) {
        try {
            //int i = 3 / 0;

            System.out.println(content);
            channel.basicAck(deliveryTag, false);
        } catch (IOException e) {
            e.printStackTrace();
            logger.error("consume confirm error!", e);
            //这一步千万不要忘记，不会会导致消息未确认，消息到达连接的qos之后便不能再接收新消息
            //一般重试肯定的有次数，这里简单的根据是否已经重发过来来决定重发。第二个参数表示是否重新分发
            try {
                channel.basicReject(deliveryTag, !redelivered);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            //这个方法我知道的是比上面多一个批量确认的参数
            // channel.basicNack(deliveryTag, false,!redelivered);
        }
    }


}
