package com.nostyling.create.util;

import com.google.common.io.Resources;

import java.util.Properties;

/**
 * @ outhor: by com.nostyling.create.util
 * @ Created by shiliang on 2018-11-15 18:39.
 * @ 类的描述：
 */
public class SystemPropert {
    public static void main(String[] args) {
        String file = Resources.getResource("banner.txt").getFile();
        Properties properties = System.getProperties();
        for (String s :properties.stringPropertyNames()
                ) {
            System.out.println(s+" -> " +properties.getProperty(s));
        }
        System.out.println("***************************************************");

        properties.stringPropertyNames().forEach(System.out::println);

        System.out.println("***************************************************");
        properties.list(System.out);
        Runtime rt = Runtime.getRuntime();
        System.out.println("Total Memory = "
                + rt.totalMemory()
                + " Free Memory = "
                + rt.freeMemory());
    }

}

