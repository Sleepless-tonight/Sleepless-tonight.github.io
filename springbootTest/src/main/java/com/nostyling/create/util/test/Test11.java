package com.nostyling.create.util.test;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-16 14:55
 * @description: for 循环示例
 **/
public class Test11 {
    static int a = 10;

    public static void main(String[] args) {
        int a1 = 12;
        for (test(); test2(a1); test3(a1)) {
            System.out.print("语句  ");
            a1--;
            System.out.println("a1: "+a1);
        }
    }

    static void test() {
        System.out.println("初始表达式");
    }

    static boolean test2(int a1) {
        System.out.println("布尔表达式："+ (a1 > a));
        return a1 > a;
    }

    static void test3(int a1) {
        System.out.println("步进");
    }
}
