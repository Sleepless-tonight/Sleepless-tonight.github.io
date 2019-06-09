package com.nostyling.create.util.test.list;

import lombok.Data;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class ListCopy {
    public static void main(String[] args) {


        Users stu1 = new Users(1, "zhangsan");
        Users stu2 = new Users(2, "lisi");
        Users stu3 = new Users(3, "wangwu");
        Users stu4 = new Users(4, "zhaoliu");
        Users stu5 = new Users(5, "jiaoming");
        Users stu6 = new Users(6, "zhangsan");
        Users stu7 = new Users(7, "jiaoming2");

        ArrayList <Users> list1 = new ArrayList <Users>();
        ArrayList <Users> list2 = null;
        list1.add(stu2);
        list1.add(stu1);
        list1.add(stu3);
        list1.add(stu5);
        list1.add(stu4);

        list2 = list1;


        //这里就会自动根据规则进行排序
        System.out.println(list1.toString());
        System.out.println( list1.stream().map(Users::getAge).collect(Collectors.toList()));
        System.out.println();
        System.out.println(list2.toString());

    }

    @Data
    static class Users {
        int age;
        String name;

        public Users(int age, String name) {
            this.age = age;
            this.name = name;
        }


    }
}
