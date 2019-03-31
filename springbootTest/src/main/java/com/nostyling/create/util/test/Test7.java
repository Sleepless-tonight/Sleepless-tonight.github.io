package com.nostyling.create.util.test;

import java.util.HashMap;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-01-11 15:29
 * @description: hashmap value null 测试
 **/
public class Test7 {
    public static void main(String[] args) {
        HashMap <String, Object> objectObjectHashMap = new HashMap <>();
        objectObjectHashMap.put("1", null);
        objectObjectHashMap.put("2", null);
        objectObjectHashMap.put("3", null);
        objectObjectHashMap.entrySet().forEach(System.out::println);
    }
}
