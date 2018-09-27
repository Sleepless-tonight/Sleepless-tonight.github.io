package com.nostyling.create.modular.controller;

import com.nostyling.create.DemoApplication;
import com.nostyling.create.modular.service.IUserService;
import com.nostyling.create.util.RedisUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
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

    private static Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private IUserService userService;
    /*
     * Redis 操作服务
     * */
    @Autowired
    private RedisUtil redisUtil;

    @RequestMapping("/getUser")
    @ResponseBody
    public Object getUser() {

        redisUtil.set("Redis", "******  Redis is success!  *****",(long)5 * 60);
        logger.info(redisUtil.get("Redis").toString());

        HashMap <String, Object> entity = new HashMap <String, Object>();
        return userService.selectUsers(entity);
    }

    //@Autowired
    //private StringRedisTemplate template;
    //
    //@RequestMapping("/getUser")
    //@ResponseBody
    //public Object getUser() {
    //
    //    template.opsForValue().append("zs", "**********zs********");
    //    System.out.println(template.opsForValue().get("zs"));
    //
    //    HashMap <String, Object> entity = new HashMap <String, Object>();
    //    return userService.selectUsers(entity);
    //}

    //@RequestMapping("/hello2")
    //public String hello2() {
    //    return "/static/index2.html";
    //}

    @RequestMapping("/hello")
    public String hello3() {
        return "/index";
    }

    @RequestMapping("/kaptcha")
    public String kaptcha() {
        return "/kaptcha";
    }
}