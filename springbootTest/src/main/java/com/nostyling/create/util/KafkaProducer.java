package com.nostyling.create.util;

/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shili on 2018/9/26 12:02.
 * @ 类的描述：
 */

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.ListenableFuture;

import java.util.UUID;
import java.util.concurrent.CountDownLatch;

/**
 * 生产者
 * 使用@EnableScheduling注解开启定时任务
 */
@Component
@EnableScheduling
public class KafkaProducer {
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(KafkaProducer.class);

    @Autowired
    private KafkaTemplate kafkaTemplate;

    //private final CountDownLatch latch = new CountDownLatch(3);


    /**
     * 定时任务
     * 发送消息的方法
     */
    @Scheduled(cron = "0 00/1 * * * ?")
    public void send(){
        String message = UUID.randomUUID().toString();
        ListenableFuture future = kafkaTemplate.send("test3", message, message);
        future.addCallback(o -> System.out.println("send-消息发送成功：" + message), throwable -> System.out.println("消息发送失败：" + message));
    }

    /**
     * 监听test主题,有消息就读取
     * @param consumer
     */
    @KafkaListener(topics = "test3")
    public void receive(ConsumerRecord<?, ?> consumer) {
        logger.info("{} - {}:{}", consumer.topic(), consumer.key(), consumer.value());
    }


}
