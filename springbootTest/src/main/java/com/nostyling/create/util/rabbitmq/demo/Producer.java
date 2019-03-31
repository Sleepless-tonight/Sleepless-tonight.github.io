package com.nostyling.create.util.rabbitmq.demo;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.MessageProperties;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @ outhor: by com.example.demo.rabbitmq
 * @ Created by shiliang on 2018-11-12 14:00.
 * @ 类的描述：消息生产者
 */
public class Producer {
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername("admin");
        factory.setPassword("5672");
        //设置 RabbitMQ 地址
        factory.setHost("192.168.100.220");
        factory.setPort(5672);
        //建立到代理服务器到连接
        Connection conn = factory.newConnection();
        //获得信道
        Channel channel = conn.createChannel();
        //声明交换器
        String exchangeName = "hello-exchange";
        channel.exchangeDeclare(exchangeName, "direct", true);
        //路由键
        String routingKey = "hola";
        //发布消息
        String quti = "发布消息：quit";
        byte[] messageBodyBytes = quti.getBytes();
        /**
         * 第一个参数是：交换的名称。空字符串表示默认或无名交换：消息被路由到具有routingKey（路由键）指定名称的队列（如果存在）。
         * 命名队列/路由键
         * 第三个参数是：将消息标记为持久性:MessageProperties.PERSISTENT_TEXT_PLAIN
         * 第三个参数是：消息
         */
        channel.basicPublish(exchangeName, routingKey, MessageProperties.PERSISTENT_TEXT_PLAIN, messageBodyBytes);

        //关闭通道和连接
        channel.close();
        conn.close();
    }

}
