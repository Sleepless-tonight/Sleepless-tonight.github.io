package com.nostyling.create.modular.controller;

import com.nostyling.create.modular.entity.User;
import com.nostyling.create.modular.service.IUserService;
import com.nostyling.create.util.RedisUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
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


    /**
     * @Cacheable和@CacheEvict.第一个注解代表从缓存中查询指定的key,如果有,从缓存中取,不再执行方法.如果没有则执
     * 行方法, 并且将方法的返回值和指定的key关联起来, 放入到缓存中.而@CacheEvict则是从缓存中清除指定的key对应的数据.
     * @return
     */
    @ApiOperation(value="全用户列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "page", value = "当前页数1开始",  dataType = "int",paramType = "query"),
            @ApiImplicitParam(name = "pageSize", value = "每页的大小",  dataType = "int",paramType = "query"),
            @ApiImplicitParam(name = "userId", value = "当前登录的用户id", dataType = "int",paramType = "query")
    })
    @RequestMapping("/getUser")
    @ResponseBody
    @Cacheable(value="thisredis", key="'users_'+#id")
    public Object getUser(User entity) {

        redisUtil.set("Redis", "******  Redis is success!  *****",(long)5 * 60);
        logger.info(redisUtil.get("Redis").toString());

        return userService.selectUsers(entity);
    }

    @RequestMapping("/Center")
    @ResponseBody
    public Object Center(HttpServletRequest request, HttpServletResponse response) {
        BufferedReader br = null;
        StringBuilder sb = new StringBuilder("");
        try {
            br = request.getReader();
            String str;
            while ((str = br.readLine()) != null) {
                sb.append(str);
            }
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (null != br) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        System.out.println(sb);
        return sb.toString();

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