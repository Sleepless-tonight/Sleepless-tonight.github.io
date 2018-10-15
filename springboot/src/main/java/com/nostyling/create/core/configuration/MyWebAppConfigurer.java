package com.nostyling.create.core.configuration;

import com.nostyling.create.core.Interceptor.MyInterceptor1;
import com.nostyling.create.core.Interceptor.MyInterceptor2;
import com.nostyling.create.core.filter.MyFilter2;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.servlet.Filter;

/**
 * @ outhor: by com.nostyling.create.core.configuration
 * @ Created by shili on 2018/6/28 23:39.
 * @ 类的描述：
 */
@Configuration
public class MyWebAppConfigurer implements WebMvcConfigurer {
    /**
     * 自己定义的过滤器
     * @return
     */
    //@Bean
    //public filter customFilter1() {
    //    return new MyFilter();
    //}
    @Bean
    public Filter customFilter() {
        return new MyFilter2();
    }
    @Bean
    public FilterRegistrationBean myFilter2(){
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        //当过滤器有注入其他bean类时，可直接通过@bean的方式进行实体类过滤器，这样不可自动注入过滤器使用的其他bean类。
        //当然，若无其他bean需要获取时，可直接new CustomFilter()，也可使用getBean的方式。
        registrationBean.setFilter(customFilter());
        //registrationBean.setFilter(new MyFilter2());

        //过滤器名称
        registrationBean.setName("MyFilter2");
        //拦截路径
        registrationBean.addUrlPatterns("/*");
        //添加不需要忽略的格式信息.
        registrationBean.addInitParameter("exclusions", "/static/*,*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid,/druid/*");
        //设置顺序
        registrationBean.setOrder(2);
        return registrationBean;
    }




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

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");

        registry.addResourceHandler("swagger-ui.html")
                .addResourceLocations("classpath:/META-INF/resources/");

        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

    }


}
