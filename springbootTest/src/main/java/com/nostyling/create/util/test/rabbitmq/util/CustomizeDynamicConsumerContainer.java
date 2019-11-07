package com.nostyling.create.util.test.rabbitmq.util;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-09-12 11:35
 * @description: 存放全局消费者
 **/
@Component
public class CustomizeDynamicConsumerContainer {
    /**
     * 用于存放全局消费者
     */
    public final Map <String, DynamicConsumer> customizeDynamicConsumerContainer = new ConcurrentHashMap <String, DynamicConsumer>();
}
