package com.nostyling.create.core.Listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;

/**
 * @ outhor: by com.nostyling.create.core.Listener
 * @ Created by shili on 2018/9/3 16:03.
 * @ 类的描述：ServletRequest监听器
 */
@WebListener
public class Customlister implements ServletRequestListener {
    private static Logger logger = LoggerFactory.getLogger(Customlister.class);
    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        logger.info("监听器：销毁");
    }

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        logger.info("监听器：初始化");
    }

}
