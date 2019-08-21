//package com.nostyling.spark;
//
//import org.apache.spark.sql.Dataset;
//import org.apache.spark.sql.SparkSession;
//
///**
// * @program: Sleepless-tonight.github.io
// * @author: shiliang
// * @create: 2019-08-15 22:35
// * @description: 一个非常简单的Spark应用程序
// **/
//public class SimpleApp {
//    public static void main(String[] args) {
//        String logFile = "D:\\GitHub\\Sleepless-tonight.github.io\\html\\templates\\Thinking-In-Java.mk"; // Should be some file on your system
//        SparkSession spark = SparkSession.builder().appName("Simple Application").getOrCreate();
//        Dataset <String> logData = spark.read().textFile(logFile).cache();
//
//        long numAs = logData.filter(s -> s.contains("a")).count();
//        long numBs = logData.filter(s -> s.contains("b")).count();
//
//        System.out.println("Lines with a: " + numAs + ", lines with b: " + numBs);
//
//        spark.stop();
//    }
//}
