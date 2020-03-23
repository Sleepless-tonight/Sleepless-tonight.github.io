package com.nostyling.create.util.test.logsearch;

import com.alibaba.fastjson.JSONObject;

import java.io.*;
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


        String filepath = "C:\\Users\\shiliang\\Desktop\\淘宝-天猫发货失败.txt";

        // 文件编码
        String encoding = "utf-8";

        // 缓冲区大小
        int inputBufferSize = 10 * 1024 * 1024;
        File file = new File(filepath);
        BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file));
        BufferedReader reader = new BufferedReader(new InputStreamReader(fis, encoding), inputBufferSize);

        Long countLine = 0L;
        HashMap <String, String> success = new HashMap <>();

        String line = "";
        System.out.println("======开始=====");
        while ((line = reader.readLine()) != null) {
            countLine++;

            if (null != line) {
                String[] split = line.split(" ");
                success.put(split[1], split[3]);
            }


        }


        System.out.println("======================");
        System.out.println("文本总行数：" + countLine);
        System.out.println("共搜索到：" + success.size() + " 处。");
        System.out.println(JSONObject.toJSONString(success));
        System.out.println("======================");
        System.out.println("======结束=====");
        long end = System.currentTimeMillis();
        System.out.println("用时：" + ((end - start) / 1000.00) + " 秒");
    }

}
