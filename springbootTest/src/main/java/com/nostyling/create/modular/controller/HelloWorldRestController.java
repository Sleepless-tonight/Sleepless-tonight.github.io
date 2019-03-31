package com.nostyling.create.modular.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/6/28 2:32.
 * @ 类的描述： zzController 试验类
 */
@RestController
public class HelloWorldRestController {

    @RequestMapping("/hello")
    public String index(HttpServletRequest request) {
        String ip=request.getRemoteAddr();
        return "Hello World!  IP:"+ip;
    }

}