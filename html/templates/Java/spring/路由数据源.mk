
1、定义多个数据源，有不同的ID


```
    <!-- Druid -->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${dataSource.driverClassName}"/>
        <property name="url" value="${dataSource.url}"/>
        <property name="username" value="${dataSource.username}"/>
        <property name="password" value="${dataSource.password}"/>
        <property name="initialSize" value="${dataSource.initialSize}"/>
        <property name="maxIdle" value="${dataSource.maxIdle}"/>
        <property name="maxActive" value="${dataSource.maxActive}"/>
        <property name="maxWait" value="${dataSource.maxWait}"/>
        <property name="validationQuery" value="SELECT 1 FROM DUAL"/>
        <property name="testWhileIdle" value="true"/>
        <property name="testOnBorrow" value="false"/>
        <property name="testOnReturn" value="true"/>
    </bean>

    <bean id="dataSourceHanaJCZC" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${hana.driverClassName}"/>
        <property name="url" value="${hanaJCZC.url}"/>
        <property name="username" value="${hanaJCZC.username}"/>
        <property name="password" value="${hanaJCZC.password}"/>
    </bean>

    <bean id="dataSourceHanaSJCK" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${hana.driverClassName}"/>
        <property name="url" value="${hanaSJCK.url}"/>
        <property name="username" value="${hanaSJCK.username}"/>
        <property name="password" value="${hanaSJCK.password}"/>
    </bean>
```
2、配置路由器数据源


```
    <!-- 配置路由器数据源 -->
    <bean id="dataSourceRouter" class="com.pcitc.monitoring.common.DataSourceRouter">
        <!-- 使用键值对形式管理各个具体的数据源 -->
        <property name="targetDataSources">
            <map>
                <!-- key的指可以自行指定 -->
                <!-- value-ref引用一个具体的数据源 -->
                <entry key="DATASOURCE_MAIN" value-ref="dataSource"/>
                <entry key="DATASOURCE_HANA_JCZC" value-ref="dataSourceHanaJCZC"/>
                <entry key="DATASOURCE_HANA_SJCK" value-ref="dataSourceHanaSJCK"/>
                <entry key="DATASOURCE_HANA_SJFW" value-ref="dataSourceHanaSJFW"/>
                <entry key="DATASOURCE_HANA_XSBW" value-ref="dataSourceHanaXSBW"/>
                <entry key="DATASOURCE_HANA_HRBW" value-ref="dataSourceHanaHRBW"/>
                <entry key="DATASOURCE_DATA_SJFW" value-ref="dataSourceDataSJFW"/>
                <entry key="DATASOURCE_DATA_HQX" value-ref="dataSourceDataHQX"/>
                <entry key="DATASOURCE_HANA_XSJS" value-ref="dataSourceHanaXSJS"/>

            </map>
        </property>
        <!-- 在determineCurrentLookupKey()方法返回null时使用默认数据源 -->
        <property name="defaultTargetDataSource" ref="dataSource"/>
    </bean>
```

3、注册SqlSessionFactoryBean


```
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSourceRouter"/>
        <!-- 自动扫描mappers.xml文件 -->
        <property name="mapperLocations">
            <array>
                <value>classpath*:com/pcitc/monitoring/apply/dao/mapper/*.xml</value>
                <value>classpath*:com/pcitc/monitoring/business/dao/mapper/*.xml</value>
                <value>classpath*:com/pcitc/monitoring/interfaced/dao/mapper/*.xml</value>
                <value>classpath*:com/pcitc/monitoring/realtime/dao/mapper/*.xml</value>
                <value>classpath*:com/pcitc/monitoring/core/dao/mapper/*.xml</value>
            </array>
        </property>
        <property name="configLocation" value="classpath:mybatis-config.xml"></property>
    </bean>
```
4、第2步 class 属性的实现类


```
public class DataSourceRouter extends AbstractRoutingDataSource {

	@Override
	protected Object determineCurrentLookupKey() {
		
		//1.从当前线程上获取本次操作访问数据库需要的键
		String key = DataSourceKeyBinder.getKey();
		
		//2.将键的信息从当前线程上移除，避免对其它操作造成影响
		DataSourceKeyBinder.removeKey();
		
		//3.将1中获取到的键的信息返回用来决定到底使用哪个数据源
		return key;
	}

}
```

```
public class DataSourceKeyBinder {
	
	private static ThreadLocal<String> local = new ThreadLocal<>();
	
	public static void bindKey(String key) {
		local.set(key);
	}
	
	public static void removeKey() {
		local.remove();
	}
	
	public static String getKey() {
		return local.get();
	}

}
```

5、使用


```
    //应用监控DUMP异常信息
    @ResponseBody
    @RequestMapping(value = "/getDUMPChart")
    public List <Map> getDUMPChart() {
        DataSourceKeyBinder.bindKey(“DATASOURCE_HANA_JCZC”);
        return applyService.getDUMPChart();
    }
```
