### 1、使用方法：



```
  datasource:
    hikari:
      minimum-idle: 5
      maximum-pool-size: 15
      auto-commit: true
      idle-timeout: 30000
      pool-name: test
      max-lifetime: 1800000
      connection-timeout: 30000
      connection-test-query: select 1
      driver-class-name: com.mysql.jdbc.Driver
      jdbc-url: jdbc:mysql://192.168.2.100:3306/test?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true
      username: admin
      password: d12h.Po(_f
```


```
HikariConfig config = new HikariConfig();
config.setMaximumPoolSize(100);
config.setDataSourceClassName("com.mysql.jdbc.jdbc2.optional.MysqlDataSource");
config.addDataSourceProperty("serverName", "localhost");
config.addDataSourceProperty("port", "3306");
config.addDataSourceProperty("databaseName", "mydb");
config.addDataSourceProperty("user", "bart");
config.addDataSourceProperty("password", "51mp50n");
 
HikariDataSource ds = new HikariDataSource(config);

```
### 或者


```
/**
connectionTestQuery=SELECT 1
dataSourceClassName=org.postgresql.ds.PGSimpleDataSource
dataSource.user=test
dataSource.password=test
dataSource.databaseName=mydb
dataSource.serverName=localhost
*/
 
HikariConfig config = new HikariConfig("some/path/hikari.properties");
HikariDataSource ds = new HikariDataSource(config);

```

### 或者


```
<!-- Hikari Datasource -->
 <bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource"  destroy-method="shutdown">
  <property name="driverClassName" value="${jdbc.driver}" />  <!-- 无需指定，除非系统无法自动识别 -->
  <property name="jdbcUrl" value="${jdbc.url}" />
  <property name="username" value="${jdbc.username}" />
  <property name="password" value="${jdbc.password}" />
   <!-- 连接只读数据库时配置为true， 保证安全 -->
  <property name="readOnly" value="false" />
  <!-- 等待连接池分配连接的最大时长（毫秒），超过这个时长还没可用的连接则发生SQLException， 缺省:30秒 -->
  <property name="connectionTimeout" value="30000" />
  <!-- 一个连接idle状态的最大时长（毫秒），超时则被释放（retired），缺省:10分钟 -->
  <property name="idleTimeout" value="600000" />
  <!-- 一个连接的生命时长（毫秒），超时而且没被使用则被释放（retired），缺省:30分钟，建议设置比数据库超时时长少30秒，参考MySQL wait_timeout参数（show variables like '%timeout%';） -->
  <property name="maxLifetime" value="1800000" />
  <!-- 连接池中允许的最大连接数。缺省值：10；推荐的公式：((core_count * 2) + effective_spindle_count) -->
  <property name="maximumPoolSize" value="15" />
 </bean>

```
### 阿里巴巴连接池设置


```
  datasource:
    name: test
    type: com.alibaba.druid.pool.DruidDataSource
    #druid相关配置
    druid:
      #监控统计拦截的filters
      filters: stat
      driver-class-name: com.mysql.jdbc.Driver
      #基本属性
      url: jdbc:mysql://192.168.2.100:3306/test?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true
      username: admin
      password: d12h.Po(_f
      #配置初始化大小/最小/最大
      initial-size: 1
      min-idle: 1
      max-active: 20
      #获取连接等待超时时间
      max-wait: 60000
      #间隔多久进行一次检测，检测需要关闭的空闲连接
      time-between-eviction-runs-millis: 60000
      #一个连接在池中最小生存的时间
      min-evictable-idle-time-millis: 300000
      validation-query: SELECT 'x'
      test-while-idle: true
      test-on-borrow: false
      test-on-return: false
      #打开PSCache，并指定每个连接上PSCache的大小。oracle设为true，mysql设为false。分库分表较多推荐设置为false
      pool-prepared-statements: false
      max-pool-prepared-statement-per-connection-size: 20
```
