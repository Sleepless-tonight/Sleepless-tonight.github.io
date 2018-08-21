package com.nostyling.create.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @ outhor: by com.nostyling.create.controller
 * @ Created by shili on 2018/6/28 2:32.
 * @ 类的描述：
 */
@RestController
public class HelloWorldController {
    @RequestMapping("/hello")
    public String index() {
        return "Hello World";
    }
}