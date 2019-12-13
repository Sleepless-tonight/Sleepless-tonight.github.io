package com.nostyling.create.util.test;

import com.nostyling.create.util.test.taobao.Test14;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 11:40
 * @description: 演示： == 比较的是对象的句柄
 *
 **/
public class test4 {
    public static final int[] a = { 1, 2, 3, 4, 5, 6 };
    public static void main(String[] args) {
        test4 test4 = new test4();
        test4 test42 = new test4();
        System.out.println(test4.a[0]);
        test4.a[0] = 100;
        System.out.println(test4.a[0]);

    }
}
