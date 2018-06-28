package com.nostyling.create.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @ outhor: by com.nostyling.create.configuration
 * @ Created by shili on 2018/6/28 23:39.
 * @ 类的描述：
 */
@Configuration
public class MyWebAppConfigurer implements WebMvcConfigurer {
    /**
     * 自己定义的拦截器类
     * @return
     */
    @Bean
    MyInterceptor1 myInterceptor1() {
        return new MyInterceptor1();
    }
    @Bean
    MyInterceptor2 myInterceptor2() {
        return new MyInterceptor2();
    }
    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // 多个拦截器组成一个拦截器链

        // addPathPatterns 用于添加拦截规则

        // excludePathPatterns 用户排除拦截

        registry.addInterceptor(myInterceptor1()).addPathPatterns("/**");

        registry.addInterceptor(myInterceptor2()).addPathPatterns("/**");

    }



}
