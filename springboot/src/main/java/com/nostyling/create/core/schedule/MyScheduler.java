package com.nostyling.create.core.schedule;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.Trigger;
import org.quartz.impl.StdSchedulerFactory;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * @ outhor: by com.nostyling.create.core.schedule
 * @ Created by shili on 2018/10/8 14:16.
 * @ 类的描述：调度任务
 */
public class MyScheduler {
    public static void main(String[] args) {
        try {
            //定义一个JobDetail
            JobDetail job = newJob(MyJob.class)//定义Job类为MyJob类，这是真正的执行逻辑所在
                    .withIdentity("job1", "group1")//定义name/group
                    .usingJobData("name", "quartz")//定义属性
                    .build();
            //定义一个Trigger
            Trigger trigger = newTrigger()
                    .withIdentity("trigger1", "group1")//定义name/group
                    .startNow()//一旦加入scheduler，立即生效
                    .withSchedule(simpleSchedule()//使用SimpleTrigger
                            .withIntervalInSeconds(5)//每隔40秒执行一次
                            .repeatForever())//一直执行，
                    .build();
            //创建scheduler
            Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
            //加入这个调度
            scheduler.scheduleJob(job, trigger);
            //启动
            scheduler.start();

            //运行一段时间后关闭
            Thread.sleep(10000);
            scheduler.shutdown(true);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
