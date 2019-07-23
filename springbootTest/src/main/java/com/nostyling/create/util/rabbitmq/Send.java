package com.nostyling.create.util.rabbitmq;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.MessageProperties;


public class Send {
    private final static String HOST = "dev-mq-vip.tae-tea.net";
    private final static Integer PORT = 5672;
    private final static String USERNAME = "admin";
    private final static String PASSWORD = "ca&e6I^Z@a!pfh";
    private final static String QUEUE_NAME = "OMS_Api_Send_Deliver_Order";


    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername(USERNAME);
        factory.setPassword(PASSWORD);
        factory.setHost(HOST);
        factory.setPort(PORT);
        try (Connection connection = factory.newConnection();
             Channel channel = connection.createChannel()) {
            channel.queueDeclare(QUEUE_NAME, true, false, false, null);
            for (int i = 1; i < 20; i++) {
                String message = "{\"attachments\":{},\"content\":{\"deliveryTime\":1563436758260,\"expressCompanyId\":\"6\",\"expressCompanyName\":\"中通快递\",\"expressCompanyNo\":\"JH_006\",\"expressNo\":\"73100617814018\",\"expressType\":\"200\",\"orderNo\":\"DD1907180000003\",\"platOrderNo\":\"1151321473862836225\",\"senderAddress\":\"iii\",\"senderName\":\"kk\",\"senderPhone\":\"12000000000\",\"shopId\":\"1\",\"storeOutCompleteFlag\":true,\"storeOutNo\":\"CK1907182100010\"},\"delayLevel\":\"TWO\",\"routingKey\":\"OMS_Api_Send_Deliver_Order\",\"sendCount\":0,\"topic\":false,\"type\":1}";

                channel.basicPublish("", QUEUE_NAME, null, message.getBytes("UTF-8"));
                System.out.println(" [x] Sent '" + message + "'");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                if (i > 1000) {
                    break;
                }
            }

        }
    }
}