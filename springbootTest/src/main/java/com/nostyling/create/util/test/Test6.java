package com.nostyling.create.util.test;

import java.util.Random;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 11:50
 * @description: 演示：移位运算符
 **/
public class Test6 {
    public static void main(String[] args) {
        int i = -1;
        i >>>= 10;
        System.out.println(i);
        long l = -1;
        l >>>= 10;
        System.out.println(l);
        short s = -1;
        s >>>= 10;
        System.out.println(s);
        byte b = -1;
        b >>>= 10;
        System.out.println(b);
        System.out.println();
    }

}
