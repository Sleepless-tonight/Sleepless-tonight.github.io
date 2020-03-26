package com.nostyling.create.util.test.file;


import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import org.bytedeco.opencv.opencv_core.Mat;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import static org.bytedeco.opencv.global.opencv_highgui.imshow;
import static org.bytedeco.opencv.global.opencv_highgui.waitKey;
import static org.bytedeco.opencv.global.opencv_imgcodecs.imread;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2020-03-24 14:11
 * @description:
 **/
public class FileManager {
    public static void main(String[] args) {
        String path = "C:\\Users\\shiliang\\Desktop\\IDEA\\1AE6E8C6-6BBA-4AD1-9011-A9D69483ADA8.JPG";
        String path3 = "C:\\Users\\shiliang\\OneDrive\\共享区\\其他\\桌面\\SAINT-LAURENT_FALL-19_NIKI-BAG_DESK.jpg";
        String path2 = "C:\\Users\\shiliang\\OneDrive\\共享区\\现代主义的真诚感动和后现代主义的冷漠戏谑之间正弦摆动.mp4";
        System.out.println(Arrays.toString(getRoot()));
        try {
            // getImageDirectories(path);
            // getImageDirectories(path2);
            getImage(path);
        } catch (ImageProcessingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 系统所有根目录
     * @return
     */
    public static File[] getRoot() {
        return File.listRoots();
    }

    /**
     * 获取图片详情信息
     *
     * @return
     */
    public static void getImageDirectories(String path) throws ImageProcessingException, IOException {

        File img = new File(path);
        System.out.println("File Name:" + img.getName());

        Metadata metadata = ImageMetadataReader.readMetadata(img);
        System.out.println("Directory Count: "+metadata.getDirectoryCount());
        System.out.println();

        //输出所有附加属性数据
        for (Directory directory : metadata.getDirectories()) {
            System.out.println("******\t" + directory.getName() + "\t******");
            for (Tag tag : directory.getTags()) {
                System.out.println(tag);
                System.out.println(tag.getTagName() + ":" + tag.getDescription());
            }
        }
    }
    /**
     * 展示图片
     *
     * @return
     */
    public static void getImage(String path) throws ImageProcessingException, IOException {

        //读取原始图片
        Mat image = imread(path);
        if (image.empty()) {
            System.err.println("加载图片出错，请检查图片路径！");
            return;
        }
        //显示图片
        imshow("显示原始图像", image);

        //无限等待按键按下
        waitKey(0);

    }
}
