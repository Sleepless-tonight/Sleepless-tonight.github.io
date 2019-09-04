package com.nostyling.websocket.rabbitmq.config;

import com.nostyling.websocket.rabbitmq.constant.SpringConstant;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.ShutdownSignalException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.connection.ChannelListener;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 18:25
 * @description: channel监听器，这里只是简单打印
 **/
@Component
@Profile(SpringConstant.CHANNEL_LISTENER_PROFILE)
@Slf4j
public class MyChannelListener implements ChannelListener {

    @Override
    public void onCreate(Channel channel, boolean transactional) {
        log.info("create channel:{channel = [" + channel + "], transactional = [" + transactional + "]} ");
    }

    @Override
    public void onShutDown(ShutdownSignalException signal) {
        log.info("channel is close,reason:{}", signal.getReason());
    }
}
