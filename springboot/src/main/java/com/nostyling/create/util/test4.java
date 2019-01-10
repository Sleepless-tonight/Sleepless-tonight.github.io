package com.nostyling.create.util;

public class test4 {
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
