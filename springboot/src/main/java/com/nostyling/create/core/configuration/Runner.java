package com.nostyling.create.core.configuration;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * @ outhor: by com.nostyling.create.core.configuration
 * @ Created by shiliang on 2018/8/23 20:49.
 * @ 类的描述：CommandLineRunner 接口的 Component 会在所有 Spring Beans 都初始化之后，SpringApplication.run() 之前执行，非常适合在应用程序启动之初进行一些数据初始化的工作。
 */
@Component
public class Runner implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        System.out.println("CommandLineRunner 接口的 Component 会在所有 Spring Beans 都初始化之后，SpringApplication.run() 之前执行，非常适合在应用程序启动之初进行一些数据初始化的工作");
    }
}
