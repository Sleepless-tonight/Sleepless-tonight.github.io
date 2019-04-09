package com.nostyling.websocket.controller;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/9/5 18:09.
 * @ 类的描述：自定义配置文件 配置文件自定义属性
 */

@Controller
@RequestMapping("/router")
public class DemoController {

    /**
     * Logger
     */
    private static final Logger logger = LoggerFactory.getLogger(DemoController.class);

    /**
     * 配置文件自定义属性
     *
     * @param
     * @return
     */
    @RequestMapping("/rest")
    @ResponseBody
    public Boolean test(HttpServletRequest request, HttpServletResponse response) {
        Map <String, String[]> parameterMap = request.getParameterMap();
        for (String s : parameterMap.keySet()) {
            System.out.println(s + " -> " + parameterMap.get(s)[0]);
        }
        return true;
    }
}

