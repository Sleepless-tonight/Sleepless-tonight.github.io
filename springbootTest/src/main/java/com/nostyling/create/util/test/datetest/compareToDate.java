package com.nostyling.create.util.test.datetest;

import java.util.Date;

public class compareToDate {
    public static void main(String[] args) {
        //时间 a
        Date a = new Date();
        try {
            //暂停一会
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        Date b = new Date();

        int i = a.compareTo(b);
        int x = b.compareTo(a);
        System.out.println("较早时间 a compareTo 较晚时间 b："+i);
        System.out.println("较晚时间 b compareTo 较早时间 a "+x);
    }
}
