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
    private final static String QUEUE_NAME = "deliver_order_dts_test2";


    public static void main(String[] argv) throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername(USERNAME);
        factory.setPassword(PASSWORD);
        factory.setHost(HOST);
        factory.setPort(PORT);
        try (Connection connection = factory.newConnection();
             Channel channel = connection.createChannel()) {
            channel.queueDeclare(QUEUE_NAME, true, false, false, null);
            for (int i = 1; i < 2; i++) {
                String message = "{\"orderNo\":\"" + i +
                        "\",\"parentOrderNo\":\"" + i +
                        "\",\"platOrderNo\":\"" + i +
                        "\",\"senderName\":null,\"senderPhone\":null,\"senderAddress\":null,\"deliveryTime\":1547031043467,\"expressTypeName\":null,\"expressCompanyId\":\"a2df6374c53b4d56af3c569373970aa6\",\"expressCompanyName\":\"1\",\"expressType\":\"1\",\"expressNo\":\"1082952761904168962\",\"shopId\":\"6\",\"expressAmounts\":null,\"deliverGoodsDetailList\":[{\"subOrderNo\":\"999001\",\"goodsCount\":2},{\"subOrderNo\":\"999002\",\"goodsCount\":2}]}";
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