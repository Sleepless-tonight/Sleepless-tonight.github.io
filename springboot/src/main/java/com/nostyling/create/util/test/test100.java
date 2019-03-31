package com.nostyling.create.util.test;

import java.io.File;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-03-16 22:07
 * @description:
 **/
public class test100 {
    public static void main(String[] args) {
        String s = "D:\\ProjectHub\\oms_api\\ManagerNodeDts\\target\\ManagerNodeDts-0.0.1-SNAPSHOT\\WEB-INF\\lib\\Tools-0.0.1-SNAPSHOT.jar!\\java\\config_process\\GetApiOrderCount.xml";
        String s2 = "file:/D:/ProjectHub/oms_api/ManagerNodeDts/target/ManagerNodeDts-0.0.1-SNAPSHOT/WEB-INF/lib/Tools-0.0.1-SNAPSHOT.jar!/java/\\";
        String[] split = s.split("jar");
        System.out.println(
                split[0]+ "jar"
        );

        int start = s.lastIndexOf(System.getProperty("file.separator"));
        int start2 = s.lastIndexOf(System.getProperty("file.separator"));
        int end = s.lastIndexOf(".");
        String substring = s.substring(start2 + 1, end);
        System.out.println("\\");
        System.out.println(System.getProperty("file.separator"));
        System.out.println("****1***"+s.substring(s.lastIndexOf(System.getProperty("file.separator")) + 1, s.lastIndexOf(".")));

    }
}
