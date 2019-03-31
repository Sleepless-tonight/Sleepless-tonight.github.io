package com.nostyling.create.util.markdown2html;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.file.FileWriter;

import java.io.IOException;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-02-18 14:42
 * @description: markdown to html
 **/
public class Markdown2Html {
    public static void main(String[] args) {
        String file = "C:\\Users\\shiliang\\Desktop\\高低版本MySQL数据库的 springboot 配置.md";
        String file2 = "C:\\Users\\shiliang\\Desktop\\高低版本MySQL数据库的 springboot 配置.html";
        MarkdownEntity html = null;
        try {
            html = MarkDown2HtmlWrapper.ofFile(file);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(html.toString());
        new FileWriter(file2).append(html.toString());
    }
}
