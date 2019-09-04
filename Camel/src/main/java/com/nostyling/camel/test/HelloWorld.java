package com.nostyling.camel.test;


import org.apache.camel.Exchange;
import org.apache.camel.ExchangePattern;
import org.apache.camel.Message;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.http.common.HttpMessage;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.ModelCamelContext;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-08-23 17:03
 * @description:
 **/
public class HelloWorld extends RouteBuilder {
    public static void main(String[] args) throws Exception {
        // 这是camel上下文对象，整个路由的驱动全靠它了。
        ModelCamelContext camelContext = new DefaultCamelContext();
        // 启动route
        camelContext.start();
        // 将我们编排的一个完整消息路由过程，加入到上下文中
        camelContext.addRoutes(new HelloWorld());
        /*
         * ==========================
         * 为什么我们先启动一个Camel服务
         * 再使用addRoutes添加编排好的路由呢？
         * 这是为了告诉各位读者，Apache Camel支持动态加载/卸载编排的路由
         * 这很重要，因为后续设计的Broker需要依赖这种能力
         * ==========================
         * */

        // 通用没有具体业务意义的代码，只是为了保证主线程不退出
        synchronized (HelloWorld.class) {
            HelloWorld.class.wait();
        }
    }
    @Override
    public void configure() throws Exception {
        // 在本代码段之下随后的说明中，会详细说明这个构造的含义
        from("jetty:http://0.0.0.0:8282/doHelloWorld")
        //        .process(new HttpProcessor())
        //        .to("log:helloworld?showExchangeId=true");

        // 主动向http URI描述的路径发出请求（http的URI笔者不需要再介绍了吧）
        //from("http://gw.api.taobao.com/router/rest?method=taobao.areas.get&env=2&format=json&fields=id,type,name&v=2.0&fields=id")
                .process(new HttpProcessor())
                // 将上一个路由元素上Message Out中消息作为请求内容，
                // 向http URI描述的路径发出请求
                // 注意，Message Out中的Body内容将作为数据流映射到Http Request Body中
                //.to("http://localhost:8080/dbk.manager.web/queryOrgDetailById");
                .to("log:helloworld?showExchangeId=true");
    }



    /**
     * 这个处理器用来完成输入的json格式的转换
     * 最主要的工作是进行业务数据格式的转换和中间数据的临时存储
     */
    public class HttpProcessor implements Processor {
        @Override
        public void process(Exchange exchange) throws Exception {
            // 因为很明确消息格式是http的，所以才使用这个类
            // 否则还是建议使用org.apache.camel.Message这个抽象接口
            HttpMessage message = (HttpMessage)exchange.getIn();
            InputStream bodyStream =  (InputStream)message.getBody();
            String inputContext = this.analysisMessage(bodyStream);
            //===============
            // 可以在这里进行数据格式转换
            // 并且将结果存储到out message中
            //===============
            bodyStream.close();
            // 存入到exchange的out区域
            if(exchange.getPattern() == ExchangePattern.InOut) {
                Message outMessage = exchange.getOut();
                outMessage.setBody(inputContext + " || out");
            }
        }

        /**
         * 从stream中分析字符串内容
         * @param bodyStream
         * @return
         */
        private String analysisMessage(InputStream bodyStream) throws IOException {
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();
            byte[] contextBytes = new byte[4096];
            int realLen;
            while((realLen = bodyStream.read(contextBytes , 0 ,4096)) != -1) {
                outStream.write(contextBytes, 0, realLen);
            }

            // 返回从Stream中读取的字串
            try {
                return new String(outStream.toByteArray() , "UTF-8");
            } finally {
                outStream.close();
            }
        }
    }


}
