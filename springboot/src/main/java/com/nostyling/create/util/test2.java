package com.nostyling.create.util;


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
        for (int i = 1; i >= 0; i++) {
            System.out.println(i % 2);

            if (i % 2 == 1) {
            }
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

        }
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
