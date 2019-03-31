package com.nostyling.create.util.test.document;

import java.io.File;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-03-28 11:27
 * @description:
 **/
public class SelectDocument {
    private static int FileSize = 0;
    private static int DocumentSize = 0;
    public static void main(String[] args) {
        String path = "C:\\";
        get(path);
    }

    public static void get(String path) {

        File file = new File(path);
        if (file.exists()) {
            if (file.isFile()) {
                FileSize++;
                System.out.println(FileSize+"、 文件 Path: " + file.getPath());
                System.out.println(FileSize+"、 文件 Name: " + file.getName());
            } else if (file.isDirectory()) {
                DocumentSize++;
                System.out.println(DocumentSize+"、 文件夹 Path: " + file.getPath());
                System.out.println(DocumentSize+"、 文件夹 Name: " + file.getName());
                File[] files = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    get(files[i].toString());
                }
            }
        }
    }
}
