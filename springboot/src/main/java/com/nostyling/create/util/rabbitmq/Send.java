package com.nostyling.create.util.rabbitmq;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.MessageProperties;


public class Send {
    private final static String HOST = "192.168.100.220";
    private final static Integer PORT = 5672;
    private final static String USERNAME = "admin";
    private final static String PASSWORD = "5672";
    private final static String QUEUE_NAME = "deliver_order_dts";


    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername(USERNAME);
        factory.setPassword(PASSWORD);
        factory.setHost(HOST);
        factory.setPort(PORT);
        try (Connection connection = factory.newConnection();
             Channel channel = connection.createChannel()) {
            channel.queueDeclare(QUEUE_NAME, true, false, false, null);
            for (int i = 1; i >= 0; i++) {
                String message = "Hello World!" + " ->  " + i;
                channel.basicPublish("", QUEUE_NAME, null, message.getBytes("UTF-8"));
                System.out.println(" [x] Sent '" + message + "'");
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                if (i > 10000) {
                    break;
                }
            }

        }
    }
}