package com.nostyling.create.core.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import java.io.IOException;

/**
 * @ outhor: by com.nostyling.create.core.filter
 * @ Created by shili on 2018/8/14 15:13.
 * @ 类的描述：自定义过滤器
 *
 */

public class MyFilter2 implements Filter {

    private Logger  logger = LoggerFactory.getLogger(MyFilter2.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("filter 2 初始化。");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        logger.info("doFilter 2  请求处理。");
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
