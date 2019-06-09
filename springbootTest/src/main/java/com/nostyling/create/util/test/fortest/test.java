package com.nostyling.create.util.test.fortest;

public class test {
    public static void main(String[] args) {
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 4; j++) {
                if (j == 2) {
                    break;//内部循环不再执行
                    //continue;//内部循环继续执行
                }
                System.out.print("i:"+i);
                System.out.println("    j:"+j);
            }
        }

    }
}
