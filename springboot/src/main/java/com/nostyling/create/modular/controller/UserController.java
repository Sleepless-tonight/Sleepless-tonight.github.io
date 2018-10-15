package com.nostyling.create.modular.controller;

import com.nostyling.create.DemoApplication;
import com.nostyling.create.modular.service.IUserService;
import com.nostyling.create.util.RedisUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
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
@Api(tags="用户API")
public class UserController {

    private static Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private IUserService userService;

    /**
     * Redis 操作服务
     */
    @Autowired
    private RedisUtil redisUtil;

    @RequestMapping("/getUser")
    @ResponseBody
    @ApiOperation(value="全用户列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "page", value = "当前页数1开始",  dataType = "int",paramType = "query"),
            @ApiImplicitParam(name = "pageSize", value = "每页的大小",  dataType = "int",paramType = "query"),
            @ApiImplicitParam(name = "userId", value = "当前登录的用户id", dataType = "int",paramType = "query")
    })
    public Object getUser() {

        redisUtil.set("Redis", "******  Redis is success!  *****",(long)5 * 60);
        logger.info(redisUtil.get("Redis").toString());

        HashMap <String, Object> entity = new HashMap <String, Object>();
        return userService.selectUsers(entity);
    }

    @RequestMapping("/hello")
    public String hello3() {
        return "/WEB-INF/view/index.jsp";
    }

    //验证码验证页面
    @RequestMapping("/kaptcha")
    @ApiOperation(value="验证码页面")
    public String kaptcha() {
        return "/WEB-INF/view/kaptcha.jsp";
    }
}