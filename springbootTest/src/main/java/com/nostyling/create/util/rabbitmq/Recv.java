package com.nostyling.create.util.rabbitmq;

import com.rabbitmq.client.*;

import java.io.IOException;

public class Recv {

    private final static String HOST = "192.168.100.220";
    private final static Integer PORT = 5672;
    private final static String USERNAME = "admin";
    private final static String PASSWORD = "5672";
    private final static String QUEUE_NAME = "deliver_order_dts_test2";

    public static void main(String[] argv) throws Exception  {

        String s = "";
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername(USERNAME);
        factory.setPassword(PASSWORD);
        factory.setHost(HOST);
        factory.setPort(PORT);
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.queueDeclare(QUEUE_NAME, true, false, false, null);

        System.out.println(" [*] Waiting for messages. To exit press CTRL+C");

        //一次只接受一条未包含的消息
        channel.basicQos(1);
        while(true) {
            //消费消息
            boolean autoAck = false;
            String consumerTag = "";
            //创建队列消费者
            DefaultConsumer defaultConsumer = new DefaultConsumer(channel) {

                @Override
                public void handleDelivery(String consumerTag,
                                           Envelope envelope,
                                           AMQP.BasicProperties properties,
                                           byte[] body) throws IOException {
                    String routingKey = envelope.getRoutingKey();
                    String contentType = properties.getContentType();
                    System.out.println("消费的路由键：" + routingKey);
                    System.out.println("消费的内容类型：" + contentType);
                    long deliveryTag = envelope.getDeliveryTag();
                    //手动消息确认
                    channel.basicAck(deliveryTag, false);
                    System.out.print("消费的消息体内容：");
                    String bodyStr = new String(body, "UTF-8");
                    System.out.println(bodyStr);
                }
            };

            channel.basicConsume(QUEUE_NAME, autoAck, consumerTag, defaultConsumer);
        }
    }


}
