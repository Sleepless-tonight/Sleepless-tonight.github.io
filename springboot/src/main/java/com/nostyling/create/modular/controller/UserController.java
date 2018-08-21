package com.nostyling.create.modular.controller;

import com.nostyling.create.modular.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/6/28 2:32.
 * @ 类的描述：
 */
@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private IUserService userService;

    @RequestMapping("/getUser")
    @ResponseBody
    public Object getUser() {
        HashMap <String, Object> entity = new HashMap <String, Object>();
        return userService.selectUsers(entity);
    }

    @RequestMapping("/hello2")
    public String hello2() {
        return "/index2.html";
    }
    @RequestMapping("/hello3")
    public String hello3() {
        return "/index";
    }
}