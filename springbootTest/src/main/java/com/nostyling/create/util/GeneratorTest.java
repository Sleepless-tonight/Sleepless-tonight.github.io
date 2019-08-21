package com.nostyling.create.util;

import java.util.Scanner;

/**
 * @ outhor: by com.nostyling.create.modular.controller
 * @ Created by shili on 2018/9/17 18:20.
 * @ 类的描述：代码生成
 */
public class GeneratorTest {

    /**
     * <p>
     * 读取控制台内容
     * </p>
     */
    public static int scanner() {
        Scanner scanner = new Scanner(System.in);
        StringBuilder help = new StringBuilder();
        help.append(" ！！代码生成, 输入 0 表示使用 Velocity 引擎 ！！");
        help.append("\n对照表：");
        help.append("\n0 = Velocity 引擎");
        help.append("\n1 = Freemarker 引擎");
        help.append("\n请输入：");
        System.out.println(help.toString());
        int slt = 0;
        // 现在有输入数据
        if (scanner.hasNext()) {
            String ipt = scanner.next();
            if ("1".equals(ipt)) {
                slt = 1;
            }
        }
        return slt;
    }

    public static void main(String[] args) {
        String url = "140105002001";
        System.out.println(url.substring(0,2));
        System.out.println(url.substring(2,4));
    }
}
