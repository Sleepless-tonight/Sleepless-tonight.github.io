package com.nostyling.websocket.rabbitmq.constant;

/**
 * @program: mall
 * @author: shiliang
 * @create: 2019-08-30 14:36
 * @description: 消息队列的常量类
 **/
public abstract class RabbitMQConstant {

    public static final String TRUE = "true";

    public static final String FALSE = "false";

    /**
     * rabbitmq前缀名
     */
    public static final String RABBITMQ_PREFIX = "rabbitmq";
    /**
     * rabbit注解一些布尔值采用了字符串所以定义了常量以免弄错
     */
    public static final String TRUE_CONSTANT = TRUE;
    public static final String FALSE_CONSTANT = FALSE;

    /**
     * 默认交换器名字
     */
    public static final String DEFAULT_EXCHANGE = "yestae.exchange";
    public static final String DEFAULT_QUEUE = "OMS_Api_Send_Deliver_Order";
    public static final String DEFAULT_KEY = "key.default";

    /**
     * 需要消费者确认的队列
     */
    public static final String CONFIRM_EXCHANGE = "exchange.confirm";
    public static final String CONFIRM_QUEUE = "queue.confirm";
    public static final String CONFIRM_KEY = "key.confirm";

    /**
     * 自动确认的队列
     */
    public static final String NONE_EXCHANGE = "exchange.none";
    public static final String NONE_QUEUE = "queue.none";
    public static final String NONE_KEY = "key.none";
    /**
     * 死信队列
     */
    public static final String DEAD_EXCHANGE = "exchange.dead";
    public static final String DEAD_QUEUE = "queue.dead";
    public static final String DEAD_KEY = "key.dead";
    /**
     * 显示声明的队列名字
     */
    public static final String PROGRAMMATICALLY_QUEUE = "queue.programmatically";
    public static final String PROGRAMMATICALLY_EXCHANGE = "exchange.programmatically";
    public final static String PROGRAMMATICALLY_KEY = "key.programmatically";
    /**
     * 多个监听器
     */
    public static final String MULTIPART_HANDLE_EXCHANGE = "exchange.multipart";
    public static final String MULTIPART_HANDLE_QUEUE = "queue.multipart";
    public static final String MULTIPART_HANDLE_KEY = "key.multipart";

    public static final String MANDATORY_KEY = "key.mandatory";
    public static final String MULTIPART_QUEUE = "queue.multipart";
    /**
     * 测试direct容器
     */
    public static final String DIRECT_QUEUE = "queue.direct";
    public static final String DIRECT_EXCHANGE = "exchange.direct";
    public static final String DIRECT_KEY = "key.direct";

    /**
     * 默认交换器名字
     */
    public static final String REPLY_EXCHANGE = "exchange.reply";
    public static final String REPLY_QUEUE = "queue.reply";
    public static final String REPLY_KEY = "key.reply";
    /**
     * RPC模式
     */
    public static final String RPC_EXCHANGE = "exchange.rpc";
    public static final String RPC_QUEUE = "queue.rpc";
    public static final String RPC_KEY = "key.rpc";
    /**
     * 死信队列参数
     */
    public static final String DEAD_LETTER_EXCHANGE = "x-dead-letter-exchange";
    public static final String DEAD_LETTER_KEY = "x-dead-letter-routing-key";




    public static final String TO_OMS_EXCHANGE = "OrderMsgExchange";

    public static final String FROM_OMS_EXCHANGE = "yestae.exchange";
    public static final String FROM_OMS_DELIVER_ORDER_KEY = "OMS_Api_Send_Deliver_Order";


    /**
     * 如果要将 交换 声明为非持久的，则为false。
     */
    public static final String DEFAULT_EXCHANGE_DURABLE = TRUE;
    /**
     * 如果要将 交换 声明为自动删除，则为true。
     */
    public static final String DEFAULT_EXCHANGE_AUTO_DELETE = FALSE;


    /**
     * 如果要将 队列 声明为非持久的，则为false。
     */
    public static final String DEFAULT_QUEUE_DURABLE = TRUE;

    /**
     * 如果要将 队列 声明为自动删除，则为true。
     */
    public static final String DEFAULT_QUEUE_AUTO_DELETE = FALSE;
}
