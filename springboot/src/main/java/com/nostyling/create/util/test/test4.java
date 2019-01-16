package com.nostyling.create.util.test;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 11:40
 * @description: 演示： == 比较的是对象的句柄
 *
 **/
public class test4 {
    public static void main(String[] args) {
        int a = 1;
        int b = 1;
        System.out.println(a == b);
        String c = new String("A");
        String d = new String("B");

    }
}
