package com.nostyling.create.util.test.list;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class testDate {
    public static void main(String[] args) {
        Date date = new Date();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd HHmmss");
        SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat formatter3 = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat formatter4 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        String format = formatter.format(date);
        String format2 = formatter2.format(new Date());
        String format3 = formatter3.format(new Date());
        String format4 = formatter4.format(new Date());

        //将 Date 对象以指定格式字符串 输出
        System.out.println(format);
        System.out.println(format2);
        System.out.println(format3);
        System.out.println(format4);
        System.out.println();

        //6月14号
        String format01 = "20190614 203626";
        String format02 = "2019-06-14";
        String format03 = "2019/06/14";
        String format04 = "2019-06-14 20:36:26";
        Date parse;
        Date parse2;
        Date parse3;
        Date parse4;
        try {
            //将指定格式的 字符串 转换为 date 对象
            parse = formatter.parse(format01);
            parse2 = formatter2.parse(format02);
            parse3 = formatter3.parse(format03);
            parse4 = formatter4.parse(format04);

            System.out.println(parse.toString());
            System.out.println(parse2.toString());
            System.out.println(parse3.toString());
            System.out.println(parse4.toString());
            System.out.println();


        } catch (ParseException e) {
            e.printStackTrace();
        }


    }
}
