package com.nostyling.create.modular.service;

import com.nostyling.create.modular.dao.UserMapper;
import com.nostyling.create.modular.entity.User;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/9/5 17:36.
 * @ 类的描述：
 */
@RunWith(SpringRunner.class)
//SpringBootTest 是springboot 用于测试的注解，可指定启动类或者测试环境等，这里直接默认。
@SpringBootTest
public class UserServiceTest {
    @Autowired
    private UserMapper userMapper;

    @Test
    public void getUser() {
        //System.out.println("User:"+ Arrays.toString(userMapper.selectUsers(new HashMap <>()).toArray()));
        System.out.println(("----- selectAll method Recv ------"));
        List<User> userList = userMapper.selectList(null);
        Assert.assertEquals(2, userList.size());
        userList.forEach(System.out::println);
        //System.out.println(Arrays.toString(userList.toArray()));

    }
}
