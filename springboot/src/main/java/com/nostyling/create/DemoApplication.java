package com.nostyling.create;

import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
//@PropertySource(value= "classpath:application-my.yml",encoding="utf-8")
@ComponentScan(basePackages = {"com.nostyling"})
@ServletComponentScan(value = "com.nostyling")
@MapperScan(basePackages = {"com.nostyling.create.modular.dao"})//将项目中对应的mapper类的路径加进来就可以了
public class DemoApplication {
    private static Logger logger = LoggerFactory.getLogger(DemoApplication.class);

	public static void main(String[] args) {

		SpringApplication.run(DemoApplication.class, args);
        logger.info("成功启动！");
	}
}
