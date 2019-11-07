package com.nostyling.create.util.string;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-09-09 11:37
 * @description:
 **/
public class StringToChar {
    public static void main(String[] args) {
        String up = "Sort = (Entity_),(-c,-1)";
        char[] chars = up.toCharArray();

        for (int i = 0; i < chars.length; i++) {
            char chr = chars[i];
            // 下划线
            if (chr == 95) {
                System.out.println();
            }
            // 空格
            if (chr == 32) {
                System.out.println();
            }
            // (
            if (chr == 40) {
                System.out.println();
            }
            // )
            if (chr == 41) {
                System.out.println();

            }
            // ,
            if (chr == 44) {
                System.out.println();

            }
            // =
            if (chr == 61) {
                System.out.println(chr);
            }
            // [0-9]
            if (chr > 47 && chr < 58) {
                System.out.println();

            }
            // [a-zA-Z]
            if (chr > 64 && chr < 123) {
                System.out.println();

            }

        }

    }
}
