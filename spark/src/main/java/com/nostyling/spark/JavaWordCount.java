package com.nostyling.spark;

import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.sql.SparkSession;
import scala.Tuple2;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-08-15 23:29
 * @description:
 **/
public class JavaWordCount {
    private static final Pattern SPACE = Pattern.compile(" ");

    public static void main(String[] args) throws Exception {
        String fail = "D:\\GitHub\\Sleepless-tonight.github.io\\html\\technology\\MyBatis3.txt";
        //if (args.length < 1) {
        //    System.err.println("Usage: JavaWordCount <file>");
        //    System.exit(1);
        //}

        SparkSession spark = SparkSession
                .builder()
                .appName("JavaWordCount")
                .getOrCreate();
        args[0] = fail;
        JavaRDD <String> lines = spark.read().textFile(args[0]).javaRDD();

        JavaRDD<String> words = lines.flatMap(s -> Arrays.asList(SPACE.split(s)).iterator());

        JavaPairRDD <String, Integer> ones = words.mapToPair(s -> new Tuple2 <>(s, 1));

        JavaPairRDD<String, Integer> counts = ones.reduceByKey((i1, i2) -> i1 + i2);

        List <Tuple2<String, Integer>> output = counts.collect();
        for (Tuple2<?,?> tuple : output) {
            System.out.println(tuple._1() + ": " + tuple._2());
        }
        spark.stop();
    }
}
