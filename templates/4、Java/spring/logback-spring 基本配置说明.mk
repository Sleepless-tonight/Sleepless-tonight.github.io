##### logback-spring 基本配置说明
```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <!-- 此xml在spring-boot-1.5.3.RELEASE.jar里 -->
    <include resource="org/springframework/boot/logging/logback/defaults.xml" />
    <include resource="org/springframework/boot/logging/logback/console-appender.xml" />
    <!-- 开启后可以通过jmx动态控制日志级别(springboot Admin的功能) -->
    <!--<jmxConfigurator/>-->

    <!-- RollingFileAppender：滚动记录文件，先将日志记录到指定文件，当符合某个条件时，将日志记录到其他文件 -->
    <!-- 以下的大概意思是：1.先按日期存日志，日期变了，将前一天的日志文件名重命名为XXX%日期%索引，新的日志仍然是demo.log -->
    <!--             2.如果日期没有发生变化，但是当前日志的文件大小超过10MB时，对当前日志进行分割 重命名-->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <File>${LOG_PATH}${LOG_FILE}</File>
        <encoder>
            <!-- pattern节点，用来设置日志的输入格式 -->
            <pattern>%date [%level] [%thread] %logger{60} [%file : %line] %msg%n</pattern>
            <!-- 记录日志的编码:此处设置字符集 - -->
            <charset>UTF-8</charset>
        </encoder>
        <!-- rollingPolicy:当发生滚动时，决定 RollingFileAppender 的行为，涉及文件移动和重命名。 -->
        <!-- TimeBasedRollingPolicy： 最常用的滚动策略，它根据时间来制定滚动策略，既负责滚动也负责出发滚动 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 添加.gz 历史日志会启用压缩 大大缩小日志文件所占空间 -->
            <!-- 文件名：logs/daily/guns.log.2017-12-05.0.gz -->
            <fileNamePattern>${LOG_PATH}daily/${LOG_FILE}.%d{yyyy-MM-dd}%i.gz</fileNamePattern>
            <maxHistory>30</maxHistory><!--  保留30天日志 -->
            <!--日志文件最大的大小-->  
	        <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
	        	<maxFileSize>10MB</maxFileSize>
      		</timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
    </appender>
    <!-- 指定项目中某个包，当有日志操作行为时的日志记录级别 -->
    <!-- com.liyan为根包，也就是只要是发生在这个根包下面的所有日志操作行为的权限都是DEBUG -->
    <!--<logger name="com.liyan" level="DEBUG">-->
        <!--<appender-ref ref="demolog" />-->
    <!--</logger>-->
    <!--<logger name="org.springframework" level="error"/>-->
    <!--<logger name="jdbc.connection" level="OFF"/>-->
    <!--<logger name="org.apache" level="error"/>-->
    <!--<logger name="com.alibaba" level="error"/>-->
    <!--<logger name="org.apache.kafka.clients.producer.ProducerConfig" level="warn"/>-->

    <!-- 控制台输出日志级别 -->
    <!-- 级别依次为【从高到低】：FATAL > ERROR > WARN > INFO > DEBUG > TRACE  -->
    <root level="INFO"><!-- 控制台输出日志级别 -->
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/><!-- 根logger的设置-->
    </root>
</configuration>
```
