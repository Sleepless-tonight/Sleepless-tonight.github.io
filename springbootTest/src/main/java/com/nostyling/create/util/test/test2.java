package com.nostyling.create.util.test;


import com.rabbitmq.client.BuiltinExchangeType;
import com.rabbitmq.client.MessageProperties;
import org.springframework.beans.BeanUtils;

import java.util.HashMap;

/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018-10-25 11:04.
 * @ 类的描述：
 */
public class test2 {

    public static void main(String[] args) {
        //User user = new User();
        //UserVo userVo = new UserVo();
        //user.setId("1");
        ////user.setName("name");
        //BeanUtils.copyProperties(user, userVo,new String[]{"name"});
        //System.out.println(userVo.toString());
        //System.out.println(        BuiltinExchangeType.DIRECT );
        double v = 7 / 3D;
        System.out.println(v);
        System.out.println(7 / 3);

    }


    private static void convertAll(User user, UserVo userVo) {
        BeanUtils.copyProperties(user, userVo);
    }

    static class User {
        String id;
        String name;


        @Override
        public String toString() {
            return "User{" +
                    "id='" + id + '\'' +
                    ", name='" + name + '\'' +
                    '}';
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    static class UserVo {
        String id;
        String name;
        String age;

        @Override
        public String toString() {
            return "UserVo{" +
                    "id='" + id + '\'' +
                    ", name='" + name + '\'' +
                    ", age='" + age + '\'' +
                    '}';
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getAge() {
            return age;
        }

        public void setAge(String age) {
            this.age = age;
        }
    }
}
