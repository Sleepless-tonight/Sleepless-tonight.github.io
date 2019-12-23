package com.nostyling.create.util.test.logsearch;

import com.alibaba.fastjson.JSON;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-11-10 17:54
 * @description: 对 文本 文件查询是否包含某个字符串
 **/
public class LogSearch {
    public static void main(String[] args) throws Exception {
        long start = System.currentTimeMillis();
        // 被搜索的文本
        //String [] textToFind = {"1195269991111208961","1195269860609634306","1195246027999686658"};
        String[] textToFind = {"取消发货,请求URL"};
        //String [] textToFind = {"700580641688476236"};

        // 被搜索的文件
        String filepath = "C:\\Users\\shiliang\\Desktop\\root.log";
        //String filepath = "C:\\Users\\shiliang\\Desktop\\root.log";

        // 文件编码
        String encoding = "utf-8";

        // 缓冲区大小
        int inputBufferSize = 10 * 1024 * 1024;
        File file = new File(filepath);
        BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file));
        BufferedReader reader = new BufferedReader(new InputStreamReader(fis, encoding), inputBufferSize);

        Long countLine = 0L;
        ArrayList <HashMap> successList = new ArrayList <>();

        String line = "";
        System.out.println("======开始=====");
        while ((line = reader.readLine()) != null) {
            countLine++;
            for (String string : textToFind) {
                boolean contains = line.contains(string);
                if (contains) {
                    HashMap <String, String> success = new HashMap <>();

                    success.put("关键字", string);
                    success.put("内容", String.valueOf(countLine));
                    success.put("日志内容", line);
                    successList.add(success);
                }
            }

        }
        System.out.println("======================");
        System.out.println("文本总行数：" + countLine);
        System.out.println("共搜索到：" + successList.size() + " 处。");
        for (HashMap <String, String> success : successList) {

            System.out.println(JSON.toJSONString(success));
            System.out.println();
        }
        System.out.println("======================");
        System.out.println("======结束=====");
        long end = System.currentTimeMillis();
        System.out.println("用时：" + ((end - start) / 1000.00) + " 秒");
    }

}