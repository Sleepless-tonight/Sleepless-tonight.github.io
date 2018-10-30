package com.nostyling.create.util;

import java.util.HashMap;

/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018-10-25 11:04.
 * @ 类的描述：
 */
public class test2 {
    public static void main(String[] args) {
        HashMap<Object, Object> objectObjectHashMap = new HashMap <>();
        objectObjectHashMap.put("a", "A");
        String a = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        a(objectObjectHashMap);
        a(objectObjectHashMap);
        b(a);
        System.out.println(objectObjectHashMap.get("a"));

    }

    static void a(HashMap a) {
        a.put("a", "B");
    }
    static void b(String a) {
        a="BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
    }
}
