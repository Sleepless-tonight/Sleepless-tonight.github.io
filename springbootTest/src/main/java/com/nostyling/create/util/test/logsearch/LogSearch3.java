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
public class LogSearch3 {
    public static void main(String[] args) {
        try {

            //需要写入的文件的路径
            String filePath = "C:\\Users\\shiliang\\Desktop\\发货失败JSON.json";
            File file1 = new File(filePath);
            FileOutputStream fos = null;
            if (!file1.exists()) {
                file1.createNewFile();//如果文件不存在，就创建该文件
                fos = new FileOutputStream(file1);//首次写入获取
            } else {
                //如果文件已存在，那么就在文件末尾追加写入
                fos = new FileOutputStream(file1, true);//这里构造方法多了一个参数true,表示在文件末尾追加写入
            }

            OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");//指定以UTF-8格式写入文件

            // 被搜索的文件
            String filepath2 = "C:\\Users\\shiliang\\Desktop\\淘宝-天猫发货失败2.txt";

            // 文件编码
            String encoding = "utf-8";

            // 缓冲区大小
            int inputBufferSize = 10 * 1024 * 1024;
            File file2 = new File(filepath2);
            BufferedInputStream fis2 = new BufferedInputStream(new FileInputStream(file2));
            BufferedReader reader2 = new BufferedReader(new InputStreamReader(fis2, encoding), inputBufferSize);

            Long countLine2 = 0L;
            HashMap<String, String> success2 = new HashMap<>();

            String line2 = "";
            System.out.println("======开始=====");
            while ((line2 = reader2.readLine()) != null) {
                countLine2++;

                if (null != line2) {
                    String[] split = line2.split(" ");
                    success2.put(split[1], split[3]);
                }


            }

            StringBuffer stringBuffer = new StringBuffer();

            long start = System.currentTimeMillis();
            // 被搜索的文本
            //String [] textToFind = {"1195269991111208961","1195269860609634306","1195246027999686658"};
            String[] textToFind = {"发货,SendOrderVO="};
            //String [] textToFind = {"700580641688476236"};

            // 被搜索的文件
            String filepath = "C:\\Users\\shiliang\\Desktop\\sl2\\root.log";
            //String filepath = "C:\\Users\\shiliang\\Desktop\\root.log";


            File file = new File(filepath);
            BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file));
            BufferedReader reader = new BufferedReader(new InputStreamReader(fis, encoding), inputBufferSize);

            Long countLine = 0L;

            String line = "";
            System.out.println("======开始=====");
            while ((line = reader.readLine()) != null) {
                countLine++;
                for (String string : textToFind) {
                    boolean contains = line.contains(string);
                    if (contains) {

                        HashMap<String, String> success = new HashMap<>();

                        success.put("搜索关键字", string);
                        success.put("所在行数", String.valueOf(countLine));

                        /**
                         * 检查此 sendOrderVO 字段是否符合标准
                         */

                        stringBuffer.append(JSONObject.toJSONString(line));
                        stringBuffer.append("\n");
                        osw.write(JSONObject.toJSONString(line));
                        osw.write("\n");




                    }
                }

            }
            System.out.println("*********************************");
            System.out.println(stringBuffer.toString());
            System.out.println("*********************************");

            //写入完成关闭流
            osw.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
