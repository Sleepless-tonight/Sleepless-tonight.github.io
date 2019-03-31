package com.nostyling.create.util.test;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-03-12 15:39
 * @description:
 **/
public class FileTest2 {
    public static void main(String[] args) {
        String str = FileTest2.class.getResource("/markdownCss").getPath()+System.getProperty("file.separator");
        System.out.println(str);

        System.out.println(System.getProperties().getProperty("user.dir"));
    }
}
