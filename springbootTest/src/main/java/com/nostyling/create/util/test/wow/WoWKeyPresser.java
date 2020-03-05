package com.nostyling.create.util.test.wow;

import java.awt.*;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @ outhor: by PACKAGE_NAME
 * @ Created by shiliang on 2018/9/28 14:25.
 * @ 类的描述：自动按键工具
 */
public class WoWKeyPresser {
    public static void main(String[] args) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        System.out.println(sdf.format(new Date()));
        System.out.println();
        int num = 0;
        //软件坐标
        int x3 = 632;
        int y3 = 1059;

        //输入框坐标
        int x = 1073;
        int y = 536;

        //确认框坐标
        int x2 = 1021;
        int y2 = 794;

        Robot robot = null;
        try {
            robot = new Robot();
        } catch (AWTException e) {
            e.printStackTrace();
        }
        //鼠标左击——选中软件
        robot.mouseMove(x3, y3);
        robot.delay(100);
        robot.mousePress(InputEvent.BUTTON1_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
        robot.delay(100);
        String[] strings = {"1", "2", "3"};
        doit(x, y, robot, "1");

        for (int i = 1; i > 0; i++) {
            //ENTER
            robot.keyPress(Event.ENTER);
            robot.keyRelease(Event.ENTER);
            String s = i + "";
            for (char ss : s.toCharArray()) {
                doit(x, y, robot, ss + "");
                System.out.println(ss + "");
            }
            //ENTER
            robot.keyPress(Event.ENTER);
            robot.keyRelease(Event.ENTER);
            try {
                Thread.sleep(1000 * 60 * 1);
            } catch (InterruptedException e) {

            }
        }


        //设置Robot产生一个动作后的休眠时间,否则执行过快
        //robot.setAutoDelay(500);
        //获取屏幕分辨率
        //Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
        //System.out.println(d);
        //robot.mouseMove(0,0);
        //robot.delay(3000);


        //鼠标左击——点击更新
        //robot.mouseMove(481,136);
        //robot.delay(2000);
        //robot.mousePress(InputEvent.BUTTON1_MASK);
        //robot.mouseRelease(InputEvent.BUTTON1_MASK);
        //robot.delay(3000);

        //CapsLock
        //robot.keyPress(KeyEvent.VK_CAPS_LOCK);
        //robot.keyRelease(KeyEvent.VK_CAPS_LOCK);

        //shift
        //robot.keyPress(KeyEvent.VK_SHIFT);
        //robot.keyRelease(KeyEvent.VK_SHIFT);


    }

    public static void doit(int x, int y, Robot robot, String args) {
        char[] pring = args.toCharArray();
        for (int i = 0; i < pring.length; i++) {
            switch (pring[i]) {

                case 'S':
                    //S
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_S);
                    robot.keyRelease(KeyEvent.VK_S);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 's':
                    //s
                    robot.keyPress(KeyEvent.VK_S);
                    robot.keyRelease(KeyEvent.VK_S);
                    robot.delay(5);
                    break;
                case 'L':
                    //L
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_L);
                    robot.keyRelease(KeyEvent.VK_L);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'l':
                    //l
                    robot.keyPress(KeyEvent.VK_L);
                    robot.keyRelease(KeyEvent.VK_L);
                    robot.delay(5);
                    break;
                case 'h':
                    //h
                    robot.keyPress(KeyEvent.VK_H);
                    robot.keyRelease(KeyEvent.VK_H);
                    robot.delay(5);
                    break;
                case 'H':
                    //h
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_H);
                    robot.keyRelease(KeyEvent.VK_H);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'i':
                    //i;
                    robot.keyPress(KeyEvent.VK_I);
                    robot.keyRelease(KeyEvent.VK_I);
                    robot.delay(5);
                    break;
                case 'I':
                    //i;
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_I);
                    robot.keyRelease(KeyEvent.VK_I);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'a':
                    //a
                    robot.keyPress(KeyEvent.VK_A);
                    robot.keyRelease(KeyEvent.VK_A);
                    robot.delay(5);
                    break;
                case 'A':
                    //a
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_A);
                    robot.keyRelease(KeyEvent.VK_A);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'n':
                    //n
                    robot.keyPress(KeyEvent.VK_N);
                    robot.keyRelease(KeyEvent.VK_N);
                    robot.delay(5);
                    break;
                case 'N':
                    //n
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_N);
                    robot.keyRelease(KeyEvent.VK_N);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'g':
                    //g
                    robot.keyPress(KeyEvent.VK_G);
                    robot.keyRelease(KeyEvent.VK_G);
                    robot.delay(5);
                    break;
                case 'G':
                    //g
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_G);
                    robot.keyRelease(KeyEvent.VK_G);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case 'j':
                    //j
                    robot.keyPress(KeyEvent.VK_J);
                    robot.keyRelease(KeyEvent.VK_J);
                    robot.delay(5);
                    break;
                case 'J':
                    //j
                    robot.keyPress(KeyEvent.VK_SHIFT);
                    robot.keyPress(KeyEvent.VK_J);
                    robot.keyRelease(KeyEvent.VK_J);
                    robot.keyRelease(KeyEvent.VK_SHIFT);
                    robot.delay(5);
                    break;
                case '.':
                    robot.keyPress(KeyEvent.VK_PERIOD);
                    robot.keyRelease(KeyEvent.VK_PERIOD);
                    robot.delay(5);
                    break;
                case '0':
                    robot.keyPress(KeyEvent.VK_0);
                    robot.keyRelease(KeyEvent.VK_0);
                    robot.delay(5);
                    break;
                case '1':
                    robot.keyPress(KeyEvent.VK_1);
                    robot.keyRelease(KeyEvent.VK_1);
                    robot.delay(1);
                    break;
                case '2':
                    robot.keyPress(KeyEvent.VK_2);
                    robot.keyRelease(KeyEvent.VK_2);
                    robot.delay(5);
                    break;
                case '3':
                    robot.keyPress(KeyEvent.VK_3);
                    robot.keyRelease(KeyEvent.VK_3);
                    robot.delay(5);
                    break;
                case '4':
                    robot.keyPress(KeyEvent.VK_4);
                    robot.keyRelease(KeyEvent.VK_4);
                    robot.delay(5);
                    break;
                case '5':
                    robot.keyPress(KeyEvent.VK_5);
                    robot.keyRelease(KeyEvent.VK_5);
                    robot.delay(5);
                    break;
                case '6':
                    robot.keyPress(KeyEvent.VK_6);
                    robot.keyRelease(KeyEvent.VK_6);
                    robot.delay(5);
                    break;
                case '7':
                    robot.keyPress(KeyEvent.VK_7);
                    robot.keyRelease(KeyEvent.VK_7);
                    robot.delay(5);
                    break;
                case '8':
                    robot.keyPress(KeyEvent.VK_8);
                    robot.keyRelease(KeyEvent.VK_8);
                    robot.delay(5);
                    break;
                case '9':
                    robot.keyPress(KeyEvent.VK_9);
                    robot.keyRelease(KeyEvent.VK_9);
                    robot.delay(5);
                    break;
                default:
                    break;
            }
        }

    }

}
