package com.nostyling.create.util.test.multithread;

import java.util.concurrent.CountDownLatch;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2019-11-16 11:39
 * @description:
 **/
public class MultiThread {
    public static void main(String[] args) {
        int count = 20;
        //与countDownLatch.await();实现运行完所有线程之后才执行后面的操作
        final CountDownLatch cdl = new CountDownLatch(count);
        //final CyclicBarrier barrier = new CyclicBarrier(count);  //与barrier.await() 实现并发;
        int j = 0;
        for (int i = 0; i < count; i++) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    cdl.countDown();
                    try {
                        //这一步是为了将全部线程任务执行完以后，开始执行后面的任务（计算时间，数量）
                        cdl.await();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    try {
                        long currentTimeMillis = System.currentTimeMillis();
                        System.out.println(currentTimeMillis + Thread.currentThread().toString() + "、");
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();

        }
        System.out.println("************************");
    }
}
