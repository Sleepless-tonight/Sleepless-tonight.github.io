package com.nostyling.create.core.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * @ outhor: by com.nostyling.create.core.schedule
 * @ Created by shili on 2018/10/8 14:08.
 * @ 类的描述：
 */
public  class MyJob implements Job {

    public MyJob() {
    }

    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        System.out.println("************Hello World!  MyJob is executing.***************");
    }
}

