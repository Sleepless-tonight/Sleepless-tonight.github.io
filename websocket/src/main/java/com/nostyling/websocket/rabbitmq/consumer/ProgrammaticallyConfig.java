package com.nostyling.websocket.rabbitmq.consumer;

import com.nostyling.websocket.rabbitmq.constant.RabbitMQConstant;
import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;
import org.springframework.amqp.rabbit.listener.api.ChannelAwareMessageListener;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

//import org.springframework.amqp.rabbit.core.ChannelAwareMessageListener;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 19:02
 * @description: 显式声明消费者的例子
 **/
@Slf4j
@Configuration
@Profile(SpringConstant.PROGRAMMATICALLY_CONFIG_PROFILE)
public class ProgrammaticallyConfig {

    @Autowired
    RabbitTemplate rabbitTemplate;

    @Bean
    @Qualifier(RabbitMQConstant.PROGRAMMATICALLY_QUEUE)
    Queue queue() {
        return new Queue(RabbitMQConstant.PROGRAMMATICALLY_QUEUE, false, false, true);
    }

    /**
     * 消费者和生产者都可以声明，交换器这种一般经常创建，可以手动创建。需要注意对于没有路由到队列的消息会被丢弃。
     *
     * @return
     */
    @Bean
    @Qualifier(RabbitMQConstant.PROGRAMMATICALLY_EXCHANGE)
    TopicExchange exchange() {
        return new TopicExchange(RabbitMQConstant.PROGRAMMATICALLY_EXCHANGE, false, true);
    }

    @Bean
    Binding binding(@Qualifier(RabbitMQConstant.PROGRAMMATICALLY_EXCHANGE) TopicExchange exchange,
                    @Qualifier(RabbitMQConstant.PROGRAMMATICALLY_QUEUE) Queue queue) {
        return BindingBuilder.bind(queue).to(exchange).with(RabbitMQConstant.PROGRAMMATICALLY_KEY);
    }

    /**
     * 声明简单的消费者，接收到的都是原始的{@link Message}
     *
     * @param connectionFactory
     *
     * @return
     */
    @Bean
    SimpleMessageListenerContainer simpleContainer(ConnectionFactory connectionFactory) {
        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setMessageListener(message -> log.info("simple receiver,message:{}", message));
        container.setQueueNames(RabbitMQConstant.PROGRAMMATICALLY_QUEUE);
        return container;
    }

    /**
     * 声明带Channel的消费者,比如要手动确认消息时就会用到这个
     * ChannelAwareMessageListener 消息侦听器，它知道接收消息的通道。
     * @param connectionFactory
     *
     * @return
     */
    @Bean
    SimpleMessageListenerContainer simpleContainer2(ConnectionFactory connectionFactory) {
        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setMessageListener((ChannelAwareMessageListener) (message, channel) -> {
            log.info("channel receiver,message:{}", message);
        });
        container.setQueueNames(RabbitMQConstant.PROGRAMMATICALLY_QUEUE);
        return container;
    }

    /**
     * 声明采用MessageListenerAdapter的消费者，Convert在MessageListenerAdapter中设置
     *
     * @param connectionFactory
     *
     * @return
     */
    @Bean
    SimpleMessageListenerContainer adaptContainer(ConnectionFactory connectionFactory, MessageListenerAdapter messageConverter) {
        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setMessageListener(messageConverter);
        container.setQueueNames(RabbitMQConstant.PROGRAMMATICALLY_QUEUE);
        return container;
    }

    @Bean
    MessageListenerAdapter listenerAdapter(MessageConverter messageConverter, Receiver receiver) {
        final MessageListenerAdapter process = new MessageListenerAdapter(receiver, "process");
        //注意显示声明时，MessageConvert不是在Container中声明的
        process.setMessageConverter(messageConverter);
        return process;
    }

    @Component
    public static class Receiver {

        public void process(String message) {
            log.info("adapter receive param:{message = [" + message + "]} info:");
        }
    }
}
