package com.nostyling.create.util.test.rabbitmq.util;

import com.rabbitmq.client.Channel;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;

import java.io.IOException;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-09-12 11:39
 * @description: 2、实现自定义消费者接口功能的公共抽象类
 * 当开启了手动ack之后，要求实际消费方实现 process 方法，并返回boolean，表示是否消费成功
 * 消费成功，则ack
 * 消费失败，则将消息重新丢回到队列
 * 若开启自动ack，则不需要关注
 * 每次消费一条消息之后，需要关注下是否关闭这个状态，从而实现mq的停止消费
 **/
public abstract class AbsMQConsumer implements IMqConsumer {
    private volatile boolean end = false;
    private SimpleMessageListenerContainer container;
    private boolean autoAck;

    @Override
    public void setContainer(SimpleMessageListenerContainer container) {
        this.container = container;
        autoAck = container.getAcknowledgeMode().isAutoAck();
    }

    @Override
    public void shutdown() {
        end = true;
    }

    /**
     *
     * @param message
     * @param channel
     * @param success
     * @throws IOException
     */
    protected void autoAck(Message message, Channel channel, boolean success) throws IOException {
        //判断是否开启手动消费，autoAck = false，开启手动消费，
        if (autoAck) {
            return;
        }

        if (success) {
            // 手动消息确认
            channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
        } else {
            // 拒绝一个或多个接收到的消息：multiple = true，拒绝所有消息，;false仅拒绝标签提供的内容；requeue = true，重新请求被拒绝的消息
            channel.basicNack(message.getMessageProperties().getDeliveryTag(), false, true);
        }
    }

    /**
     *
     * @param message
     * @param channel
     * @throws Exception
     */
    @Override
    public void onMessage(Message message, Channel channel) throws Exception {
        try {
            autoAck(message, channel, process(message, channel));
        } catch (Exception e) {
            autoAck(message, channel, false);
            throw e;
        } finally {
            if (end) {
                container.stop();
            }
        }
    }

    /**
     * 每个实际消费者，实现这个抽象类的 process 方法即可，在内部实现自己的消息消费逻辑，需要返回消费成功与否
     * @param message
     * @param channel
     * @return
     */
    public abstract boolean process(Message message, Channel channel);
}
