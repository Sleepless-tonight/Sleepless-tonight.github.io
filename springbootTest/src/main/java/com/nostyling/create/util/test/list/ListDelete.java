package com.nostyling.create.util.test.list;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class ListDelete {
    public static void main(String[] args) {


        Users stu1 = new Users(1, "zhangsan");
        Users stu2 = new Users(2, "lisi");
        Users stu3 = new Users(3, "wangwu");
        Users stu4 = new Users(4, "zhaoliu");
        Users stu5 = new Users(5, "jiaoming");
        Users stu6 = new Users(6, "zhangsan");
        Users stu7 = new Users(7, "jiaoming2");

        ArrayList <Users> list1 = new ArrayList <Users>();
        ArrayList <Users> list2 = new ArrayList <Users>();
        list1.add(stu2);
        list1.add(stu1);
        list1.add(stu3);
        list1.add(stu5);
        list1.add(stu4);

        list2.add(stu6);
        list2.add(stu7);

        for (Users users : list1) {
            for (Users users1 : list2) {
                if (users1.name.equals(users.name)) {
                    list2.remove(users1);
                }
            }
        }



        list1.forEach((k)->System.out.println("Item : " + k));

        list1.forEach((k)->{
            System.out.println("Item : " + k );
            if("E".equals(k)){
                System.out.println("Hello E");
            }
        });

        //这里就会自动根据规则进行排序
        System.out.println(list1.toString());
        System.out.println(list1.toString());

    }

    static class Users {
        int age;
        String name;

        public Users(int age, String name) {
            this.age = age;
            this.name = name;
        }

        @Override
        public String toString() {
            return "Users{" +
                    "age=" + age +
                    ", name='" + name + '\'' +
                    '}';
        }
    }
}
