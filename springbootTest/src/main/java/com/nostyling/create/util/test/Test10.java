package com.nostyling.create.util.test;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 19:11
 * @description: 一个菱形
 **/
public class Test10 {
    public static void main(String[] args) {
        //System.out.println("   *  ");
        //System.out.println("  ***  ");
        //System.out.println(" *****    ");
        //System.out.println("*******");
        //System.out.println(" *****    ");
        //System.out.println("  ***  ");
        //System.out.println("   *  ");
        int x = 15;//决定有多少行
        int y = x * 2 - 1;//决定有多少列
        for (int i = 0; i < x; i++) {
            for (int j = 0; j < y; j++) {
                if (i < x / 2) {
                    if (j < y / 2 - i || j > (y / 2 + i)) {
                        System.out.print("-");
                    } else {
                        System.out.print("*");
                    }
                } else {
                    if (j < i+1 || j > (y - i)-2) {
                        System.out.print("-");
                    } else {
                        System.out.print("*");
                    }
                }

            }
            System.out.println();
        }


    }
}
