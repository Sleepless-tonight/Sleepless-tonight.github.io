package com.nostyling.create.util.test.rabbitmq.util;

import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.api.ChannelAwareMessageListener;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-09-12 11:38
 * @description:  1、消费接口定义:公共的消费者接口，主要用来接收并处理消息
 * 对于ChannelAwareMessageListener前面就以及用到，当有消息后，触发的监听器，这里我们增加了两个方法，其实主要就是干一件事情，优雅的关闭消费
 *
 * 当应用需要停止或者重启时，我们希望先优雅的关闭消息消费，那么就会用到 org.springframework.amqp.rabbit.listener.AbstractMessageListenerContainer#stop()
 **/
public interface IMqConsumer extends ChannelAwareMessageListener {

    void setContainer(SimpleMessageListenerContainer container);

    default void shutdown() {}

}
