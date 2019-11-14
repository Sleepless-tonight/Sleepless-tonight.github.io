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
        String [] textToFind = {"700580641688476236","573246796901275013","573248652222417611","700620034098654231","700593313087497233","700688643405181838","574142804915670861","567019749012350391"};
        //String [] textToFind = {"error_response"};
        //String [] textToFind = {"700580641688476236"};

        // 被搜索的文件
        String filepath = "C:\\Users\\shiliang\\Desktop\\root_.2019-11-09-1.log";
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

                    success.put("text", string);
                    success.put("countLine", String.valueOf(countLine));
                    success.put("line", line);
                    successList.add(success);
                }
            }

        }
        System.out.println("======================");
        System.out.println("文本总行数：" + countLine);
        System.out.println("搜索到的：" + JSON.toJSONString(successList));
        System.out.println("======================");
        System.out.println("======结束=====");
        long end = System.currentTimeMillis();
        System.out.println("用时：" + ((end - start) / 1000.00) + " 秒");
    }

}
