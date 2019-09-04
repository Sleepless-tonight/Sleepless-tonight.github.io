package com.nostyling.create.util.rabbitmq.direct;

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
public class ProducerDirect {
    public static void main(String[] args) throws IOException, TimeoutException {
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername("admin");
        factory.setPassword("ca&e6I^Z@a!pfh");
        //设置 RabbitMQ 地址
        factory.setHost("dev-mq-vip.tae-tea.net");
        factory.setPort(5672);
        //建立到代理服务器到连接
        Connection conn = factory.newConnection();
        //获得信道
        Channel channel = conn.createChannel();
        //声明队列
        String exchangeName = "yestae.exchange";
        ////永远不会丢失队列,需要声明它是持久的
        boolean durable = true;
        channel.queueDeclare(exchangeName, durable, false, false, null);
        //路由键
        String routingKey = "OMS_Api_Send_Deliver_Order";
        //路由键
        String routingKey2 = "OMS_Api_Send_Deliver_Order";
        //发布消息
        String quti = "发布消息： ";

        /**
         * 第一个参数是：交换的名称。空字符串表示默认或无名交换：消息被路由到具有routingKey（路由键）指定名称的队列（如果存在）。
         * 命名队列/路由键
         * 第三个参数是：将消息标记为持久性:MessageProperties.PERSISTENT_TEXT_PLAIN
         * 第三个参数是：消息
         */

        for (int i = 1; i >= 0; i++) {
            if (i % 2 == 1) {
                channel.basicPublish(exchangeName, routingKey, MessageProperties.PERSISTENT_TEXT_PLAIN, ((i) + " " + quti + routingKey).getBytes());
                System.out.println("消费的消息体内容:" + (i) + " " +
                        "——>" + (quti + routingKey));

            } else {

                channel.basicPublish(exchangeName, routingKey2, MessageProperties.PERSISTENT_TEXT_PLAIN, ((i) + " " + quti + routingKey2).getBytes());
                System.out.println("消费的消息体内容:" + (i) + " " +
                        "——>" + (quti + routingKey2));
            }
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        //关闭通道和连接
        channel.close();
        conn.close();
    }

}
