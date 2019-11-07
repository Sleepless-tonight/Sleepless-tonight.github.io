package com.nostyling.create.util.test.rabbitmq.util;

import lombok.Builder;
import lombok.Data;
import org.apache.commons.lang3.StringUtils;
import org.springframework.amqp.core.AcknowledgeMode;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Exchange;
import org.springframework.amqp.core.FanoutExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.beans.factory.FactoryBean;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-09-12 14:54
 * @description: 目标是给每个Consumer创建一个SimpleMessageListenerContainer 的 Bean交 给Spring 来托管，所以利用 Spring 的 FactoryBean 来实现
 **/
@Data
@Builder
public class MQContainerFactory implements FactoryBean <SimpleMessageListenerContainer> {
    private ExchangeType exchangeType;

    private String directExchange;
    private String topicExchange;
    private String fanoutExchange;

    private String queue;
    private String routingKey;


    private Boolean autoDeleted;
    private Boolean durable;
    private Boolean autoAck;

    private ConnectionFactory connectionFactory;
    private RabbitAdmin rabbitAdmin;
    //消费者数量
    private Integer concurrentNum;

    // 消费方
    private IMqConsumer consumer;


    private Exchange buildExchange() {
        if (directExchange != null) {
            exchangeType = ExchangeType.DIRECT;
            return new DirectExchange(directExchange);
        } else if (topicExchange != null) {
            exchangeType = ExchangeType.TOPIC;
            return new TopicExchange(topicExchange);
        } else if (fanoutExchange != null) {
            exchangeType = ExchangeType.FANOUT;
            return new FanoutExchange(fanoutExchange);
        } else {
            if (StringUtils.isEmpty(routingKey)) {
                throw new IllegalArgumentException("defaultExchange's routingKey should not be null!");
            }
            exchangeType = ExchangeType.DEFAULT;
            return new DirectExchange("");
        }
    }


    private Queue buildQueue() {
        if (StringUtils.isEmpty(queue)) {
            throw new IllegalArgumentException("queue name should not be null!");
        }

        return new Queue(queue, durable == null ? false : durable, false, autoDeleted == null ? true : autoDeleted);
    }


    private Binding bind(Queue queue, Exchange exchange) {
        return exchangeType.binding(queue, exchange, routingKey);
    }


    private void check() {
        if (rabbitAdmin == null || connectionFactory == null) {
            throw new IllegalArgumentException("rabbitAdmin and connectionFactory should not be null!");
        }
    }


    @Override
    public SimpleMessageListenerContainer getObject() throws Exception {
        check();

        Queue queue = buildQueue();
        Exchange exchange = buildExchange();
        Binding binding = bind(queue, exchange);

        rabbitAdmin.declareQueue(queue);
        rabbitAdmin.declareExchange(exchange);
        rabbitAdmin.declareBinding(binding);

        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setRabbitAdmin(rabbitAdmin);
        container.setConnectionFactory(connectionFactory);
        container.setQueues(queue);
        container.setPrefetchCount(20);
        container.setConcurrentConsumers(concurrentNum == null ? 1 : concurrentNum);
        container.setAcknowledgeMode(autoAck ? AcknowledgeMode.AUTO : AcknowledgeMode.MANUAL);


        if (consumer != null) {
            container.setMessageListener(consumer);
        }
        return container;
    }

    @Override
    public Class<?> getObjectType() {
        return SimpleMessageListenerContainer.class;
    }

}
