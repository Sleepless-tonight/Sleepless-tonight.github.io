package com.nostyling.create.util.test;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 11:40
 * @description: 示例：异或运算交换整数值
 **/
public class Test5 {
    public static void main(String[] args) {
        int a = 1;//01
        int b = 2;//10
        a=a^b;//a=11
        System.out.println(a);
        b=b^a;//b=01
        System.out.println(b);
        a=a^b;//a=10
        System.out.println(a);
    }
}
