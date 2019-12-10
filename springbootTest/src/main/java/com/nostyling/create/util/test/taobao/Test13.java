package com.nostyling.create.util.test.taobao;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-11-20 10:24
 * @description:
 **/
public class Test13 {
    public static void main(String[] args) {
        String address = "广东省^^^东莞市^^^ ^^^常平镇 世纪康城B28C";
        String[] split = address.split("\\^\\^\\^",4);
        String[] split2 = split[3].split(" ",2);
        System.out.println();
    }
}
