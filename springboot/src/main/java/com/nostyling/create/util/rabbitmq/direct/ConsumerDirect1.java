package com.nostyling.create.util.rabbitmq.direct;

import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * @ outhor: by com.example.demo.rabbitmq
 * @ Created by shiliang on 2018-11-12 14:01.
 * @ 类的描述：消息消费者
 */
public class ConsumerDirect1 {
    public static void main(String[] args) throws IOException, TimeoutException {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername("admin");
        factory.setPassword("5672");
        factory.setHost("192.168.100.220");
        factory.setPort(5672);
        //建立到代理服务器到连接
        Connection conn = factory.newConnection();
        //获得信道
        final Channel channel = conn.createChannel();
        //声明交换器
        String exchangeName = "hello-exchange";
        channel.exchangeDeclare(exchangeName, BuiltinExchangeType.DIRECT, true);
        //声明队列
        boolean durable = true; //永远不会丢失队列,需要声明它是持久的
        String queueName = channel.queueDeclare().getQueue();//创建一个非持久的，独占的自动删除队列：
        //channel.queueDeclare(queueName,durable,false,false,null);
        //路由键
        String routingKey = "green";
        //绑定队列，通过路由键 hola 将队列和交换器绑定起来;交换和队列之间的关系称为绑定。可以简单地理解为：队列对来自此交换的消息感兴趣。绑定可以采用额外的routingKey参数。为了避免与basic_publish参数混淆，我们将其称为:绑定密钥。扇出交换只是忽略了它的价值
        channel.queueBind(queueName, exchangeName, routingKey);
        //一次只接受一条未包含的消息
        channel.basicQos(1);
        while(true) {
            //消费消息
            boolean autoAck = false;
            String consumerTag = "";
            channel.basicConsume(queueName, autoAck, consumerTag, new DefaultConsumer(channel) {
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
            });
        }
    }

}
