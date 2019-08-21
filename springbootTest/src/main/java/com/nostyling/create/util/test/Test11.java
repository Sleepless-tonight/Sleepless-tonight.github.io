package com.nostyling.create.util.test;

import com.taobao.api.internal.tmc.Message;
import com.taobao.api.internal.tmc.MessageHandler;
import com.taobao.api.internal.tmc.MessageStatus;
import com.taobao.api.internal.tmc.TmcClient;
import com.taobao.api.internal.toplink.LinkException;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-16 14:55
 * @description: 通过 淘宝消息服务 获取订单变更信息
 **/
public class Test11 {

    public static void main(String[] args) {
        TmcClient client = new TmcClient("25782838", "4946ff27732f470234db684441ea1ede", "default"); // 关于default参考消息分组说明
        client.setMessageHandler(new MessageHandler() {
            @Override
            public void onMessage(Message message, MessageStatus status) {
                try {
                    System.out.println("Content: " + message.getContent());
                    System.out.println("Topic: " + message.getTopic());
                    //System.out.println(message.getRaw().toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    status.fail(); // 消息处理失败回滚，服务端需要重发
                    // 重试注意：不是所有的异常都需要系统重试。
                    // 对于字段不全、主键冲突问题，导致写DB异常，不可重试，否则消息会一直重发
                    // 对于，由于网络问题，权限问题导致的失败，可重试。
                    // 重试时间 5分钟不等，不要滥用，否则会引起雪崩
                }
            }
        });
        try {
            //正式环境服务地址：ws://mc.api.taobao.com/
            //沙箱环境服务地址：ws://mc.api.tbsandbox.com/
            client.connect("ws://mc.api.taobao.com/");
        } catch (LinkException e) {
            e.printStackTrace();
        }
        try {
            Thread.sleep(100000000000000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


}
