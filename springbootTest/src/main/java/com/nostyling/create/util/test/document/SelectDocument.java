package com.nostyling.create.util.test.document;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-03-28 11:27
 * @description:
 **/
public class SelectDocument {
    private final static Logger logger = LoggerFactory.getLogger(SelectDocument.class);

    private static int FileSize = 0;
    private static int DocumentSize = 0;
    private static int DontReadDocumentSize = 0;

    public static void main(String[] args) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        System.out.println("开始时间：" + format.format(new Date()));

        //String path = "C:\\";
        String path = "C:\\Users\\shiliang\\AppData\\Local\\Packages\\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\\LocalState\\Assets";
        get(path);
        System.out.println("文件数：" + FileSize);
        System.out.println("文件夹数：" + DocumentSize);
        System.out.println("不能读文件夹数：" + DontReadDocumentSize);
        System.out.println("结束时间：" + format.format(new Date()));


    }

    public static void get(String path) {

        File file = new File(path);
        if (file.exists()) {
            if (file.isFile()) {
                FileSize++;
                //System.out.print(FileSize + "、 文件 Path: " + file.getPath() + "  --->  ");
                System.out.print("文件 Name: " + file.getName() + "  --->  ");
                System.out.println("文件大小 : " + file.length());
            } else if (file.isDirectory()) {
                if (file.canRead()) {
                    DocumentSize++;
                    //System.out.print(DocumentSize + "、 文件夹 Path: " + file.getPath() + "  --->  ");
                    //System.out.print("文件夹 Name: " + file.getName() + "  --->  ");
                    //System.out.println("文件大小 : " + file.length());
                    File[] files = file.listFiles();
                    if (null != files) {
                        for (int i = 0; i < files.length; i++) {
                            get(files[i].toString());
                        }
                    }
                } else {
                    DontReadDocumentSize++;
                    //System.out.print(DontReadDocumentSize + "、 不能读的文件夹 Path: " + file.getPath());
                    //System.out.print(DontReadDocumentSize + "、 不能读的文件夹 Name: " + file.getName());
                }

            }
        }


    }
}
