package com.nostyling.create.util.test.rabbitmq.util;

import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-09-12 11:43
 * @description: 动态消费者
 **/
public class DynamicConsumer {


    private static final Logger logger = LoggerFactory.getLogger(DynamicConsumer.class);
    private SimpleMessageListenerContainer container;

    public DynamicConsumer(MQContainerFactory fac, String name) throws Exception {
        SimpleMessageListenerContainer container = fac.getObject();
        container.setMessageListener(new AbsMQConsumer() {
            @Override
            public boolean process(Message message, Channel channel) {
                logger.info("DynamicConsumer,{},{}, {},name,fac.getQueue(),new String(message.getBody())");
                distributionConsumerMsg(message, channel);
                return true;
            }
        });
        this.container = container;
    }

    //启动消费者监听
    public void start() {
        container.start();
    }

    //消费者停止监听
    public void stop() {
        container.stop();
    }

    //消费者重启
    public void shutdown() {
        container.shutdown();
    }


    /**
     * 用户扩展处理消息
     */
    public void distributionConsumerMsg(Message message, Channel channel) {
        System.out.println("************************* " + message);
    }

}
