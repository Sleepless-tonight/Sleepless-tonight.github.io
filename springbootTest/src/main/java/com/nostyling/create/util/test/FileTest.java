package com.nostyling.create.util.test;

import cn.hutool.core.io.FileUtil;

import java.io.IOException;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-02-18 18:40
 * @description:
 **/
public class FileTest {
    public static void main(String[] args) {
        // C:\temp\file.txt - 绝对路径，也是规范路径
        // .\file.txt - 相对路径
        // C:\temp\myapp\bin\..\..\file.txt 这是一个绝对路径，但不是规范路径

        System.out.println(FileUtil.file("markdownCss/github-markdown.css").toString());
        System.out.println(FileUtil.file("markdownCss/github-markdown.css").getAbsolutePath());//得到的是全路径
        try {
            System.out.println(FileUtil.file("markdownCss/github-markdown.css").getCanonicalPath());//方法返回 规范路径名 de 绝对路径
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(FileUtil.file("markdownCss/github-markdown.css").getName());
        System.out.println(FileUtil.file("markdownCss/github-markdown.css").getPath());//构造file的时候的路径。

    }
}
