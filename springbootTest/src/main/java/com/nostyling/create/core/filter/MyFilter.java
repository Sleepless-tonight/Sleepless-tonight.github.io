package com.nostyling.create.core.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import java.io.IOException;

/**
 * @ outhor: by com.nostyling.create.core.filter
 * @ Created by shili on 2018/8/14 15:13.
 * @ 类的描述：自定义过滤器
 *      添加 @Order 注解的实现类最先执行，并且@Order()里面的值越小启动越早。
 */
@WebFilter(filterName = "MyFilter",urlPatterns = "/*",
        initParams={
        @WebInitParam(name="encoding",value="UTF-8"),
        @WebInitParam(name = "forceEncoding", value = "true")
})
@Order(1)
public class MyFilter implements Filter {

    private Logger  logger = LoggerFactory.getLogger(MyFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("Filter初始化。");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        logger.info("doFilter 请求处理。");
        //对request、response进行一些预处理
        // 比如设置请求编码
        // request.setCharacterEncoding("UTF-8");
        // response.setCharacterEncoding("UTF-8");
        //TODO 进行业务逻辑
        //链路 直接传给下一个过滤器
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
