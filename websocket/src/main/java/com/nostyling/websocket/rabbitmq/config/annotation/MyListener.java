package com.nostyling.websocket.rabbitmq.config.annotation;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Argument;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @program: mall
 * @author: shiliang
 * @Description: 没有声明queue，默认是自动删除，排他的队列
 * ignoreDeclarationExceptions表示允许声明的不一致
 * arguments声明参数信息,
 * 如果默认多出要用到则可以提取出来
 * @create: 2019-08-30 18:18
 * @description:
 **/
@Target({ElementType.TYPE, ElementType.METHOD, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@RabbitListener(
        bindings = @QueueBinding(
                value = @Queue,
                exchange = @Exchange(value = RabbitMQConstant.DEFAULT_EXCHANGE,type = ExchangeTypes.TOPIC,
                        durable = RabbitMQConstant.FALSE_CONSTANT, autoDelete = RabbitMQConstant.TRUE),
                key = RabbitMQConstant.DEFAULT_KEY,
                ignoreDeclarationExceptions = "true",
                arguments = @Argument(name = "x-message-ttl", value = "10000", type = "java.lang.Integer")
        )
)
public @interface MyListener {

}