package com.nostyling.websocket.rabbitmq.config;

import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.listener.AsyncConsumerRestartedEvent;
import org.springframework.amqp.rabbit.listener.ListenerContainerConsumerFailedEvent;
import org.springframework.context.annotation.Profile;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:24
 * @description: 当消费者抛出异常和重启等情况，消费者容器发出context事件
 **/
@Component
@Slf4j
@Profile(SpringConstant.CONSUMER_LISTENER_PROFILE)
public class ConsumerEventListener {

    /**
     * 这里只是简单打印，有需要可以根据这个需求扩展
     *
     * @param event
     */
    @EventListener
    public void onFail(ListenerContainerConsumerFailedEvent event) {
        log.error("receive consumer error event, reason:{},fatal:{}", event.getReason(), event.isFatal(), event);
    }

    @EventListener
    public void onRestart(AsyncConsumerRestartedEvent event) {
        log.info("receive consumer restart event：{}", event.getSource());
    }
}
