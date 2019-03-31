package com.nostyling.create.modular.controller;


import com.nostyling.create.core.configuration.My;
import com.nostyling.create.modular.service.IUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/9/5 18:09.
 * @ 类的描述：自定义配置文件 配置文件自定义属性
 */

@RestController
public class DemoController {

    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(DemoController.class);

    @Value("${blog.address}")
    String address;

    @Value("${blog.author}")
    String author;

    @Value("${blog.desc}")
    String desc;

    @GetMapping("/mock")
    public String demo(String msg) {
        return msg;
    }

    /**
     * 配置文件自定义属性
     * @param msg
     * @return
     */
    @GetMapping("/blog")
    public String blog(String msg) {
        return "    address:"+address+"    author:"+author+"    desc:"+desc;
    }

    /**
     * 自定义配置文件 配置文件自定义属性
     * @param msg
     * @return
     */
    @Value("${my.code}")
    String code;

    @Value("${my.name}")
    String name;

    @Value("${my.hobby}")
    List<String> hobby;

    @GetMapping("/my")
    public String my(String msg) {
        return "    code:"+code+"    name:"+name+"    hobby:"+ Arrays.toString(hobby.toArray());
    }

    @Autowired
    private My my;
    @GetMapping("/my2")
    public String my2(String msg) {
        return "    code:"+my.getCode()+"    name:"+my.getName()+"    hobby:"+ Arrays.toString(my.getHobby().toArray());
    }


}

