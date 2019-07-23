package com.nostyling.create.util.test.list;


import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

/**
 * 集合排序
 */
public class CompareList {
    public static void main(String[] args) {

        Comparator <Users> comparator = new Comparator <Users>() {
            @Override
            public int compare(Users s1, Users s2) {
                //先排年龄
                System.out.println(s1.age.compareTo(s2.age));
                //return s1.age.compareTo(s2.age);//降序
                return s2.age.compareTo(s1.age);//升序

            }
        };
        Users stu1 = new Users(1,new Date(), "zhangsan");
        try {
            //暂停一会
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Users stu2 = new Users(2,new Date(), "lisi");
        try {
            //暂停一会
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Users stu3 = new Users(3,new Date(), "wangwu");
        try {
            //暂停一会
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Users stu4 = new Users(4,new Date(), "zhaoliu");
        try {
            //暂停一会
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Users stu5 = new Users(5,new Date(), "jiaoming");

        ArrayList <Users> list = new ArrayList <Users>();
        list.add(stu2);
        list.add(stu1);
        list.add(stu3);
        list.add(stu5);
        list.add(stu4);

        //这里就会自动根据规则进行排序
        Collections.sort(list, comparator);
        System.out.println(list.toString());

    }

    static class Users {
        int number;
        Date age;
        String name;

        public Users(int number, Date age, String name) {
            this.number = number;
            this.age = age;
            this.name = name;
        }

        public Users(Date age, String name) {
            this.age = age;
            this.name = name;
        }

        @Override
        public String toString() {
            return "Users{" +
                    "number=" + number +
                    ", age=" + age +
                    ", name='" + name + '\'' +
                    '}';
        }
    }
}
