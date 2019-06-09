package com.nostyling.create.util.system;

import com.nostyling.create.util.FileUtils;
//import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class InsertWinSystem {
    private final static Logger logger = LoggerFactory.getLogger(InsertWinSystem.class);

    private static int FileSize = 0;
    private static int DocumentSize = 0;
    private static int DontReadDocumentSize = 0;

    public static void main(String[] args) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        System.out.println("开始时间：" + format.format(new Date()));

        //String path = "C:\\";8aonWSdXFaSj2T15dMaPYw
        String path = "C:\\Users\\shiliang\\AppData\\Local\\Packages\\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\\LocalState\\Assets";
        String path2 = "C:\\Users\\shiliang\\Desktop\\新建文件夹";
        String fileType = "jpg";

        boolean b = FileUtils.copyDir(path, path2);

    }

}
