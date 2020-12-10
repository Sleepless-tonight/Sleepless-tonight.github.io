# Spring Boot配置文件-多配置文件
### 1.properties多环境配置
1、第一种：利用@PropertySource注解既可以引入配置文件，需要引入多个时，可使用@PropertySources设置数组，引入多个文件。
```
@SpringBootApplication
@PropertySource(value= "classpath:application-my.properties",encoding="utf-8")
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
```
2、第二种：配置激活选项

我们将多个资源文件放入到resource目录下
```
application.properties
application-dev.properties
application-test.properties
application-master.properties
```
在 application.properties文件中做如下配置：

```
#激活哪一个环境的配置文件
spring.profiles.active=dev
#公共配置
spring.jackson.date-format=yyyy-MM-dd HH:mm:ss:
```

### 2.YAML多环境配置
注意：@PropertySource注解只支持properties文件。而不支持yml文件。

1、第一种：使用yml的配置文件，名称一定以application-开头，例如：application-dev.yml，application-pro.yml，application-redis.yml文件等你等。

我们将多个资源文件放入到resource目录下
```
application.yml
application-dev.yml
application-test.yml
application-master.yml
```
在 application.yml 文件中配置激活选项：

```
spring:
  profiles:
    # （这里只写application-之后的名称。多个之间用逗号分隔）
    active: dev
```
2、第二种：在配置文件添加三个英文状态下的短横线即可区分

例如：
```
---
spring:
   profiles: dev
```
在 application.yml 文件中配置激活选项：

```
#激活哪一个环境的配置文件
#公共配置
spring:
  profiles:
    active: prd
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
---
spring:
  profiles: dev
server:
  port: 8081
---
spring:
  profiles: test
server:
  port: 8082
---
spring:
  profiles: prd
server:
  port: 8083
```



---

从源代码中得知 @SpringBootApplication被@Configuration、@EnableAutoConfiguration、@ComponentScan 注解所修饰，换言之 Springboot 提供了统一的注解来替代以上三个注解。

如果使用@PropertySource(value="classpath:redis.properties")注解，并配合@Value注解@Value("${spring.redis.open}"),完成参数的注入，在未注解@SpringBootApplication时，一定要有@Configuration注解，不然不起作用。

@Configuration

@Configuration 是一个类级注释，指示对象是一个bean定义的源。@Configuration 类通过 @bean 注解的公共方法声明bean。

@Bean

@Bean 注释是用来表示一个方法实例化，配置和初始化是由 Spring IoC 容器管理的一个新的对象。

通俗的讲 @Configuration 一般与 @Bean 注解配合使用，用 @Configuration 注解类等价与 XML 中配置 beans，用 @Bean 注解方法等价于 XML 中配置 bean。举例说明：

@EnableAutoConfiguration

启用 Spring 应用程序上下文的自动配置，试图猜测和配置您可能需要的bean。自动配置类通常采用基于你的 classpath 和已经定义的 beans 对象进行应用。

被 @EnableAutoConfiguration 注解的类所在的包有特定的意义，并且作为默认配置使用。例如，当扫描 @Entity类的时候它将本使用。通常推荐将 @EnableAutoConfiguration 配置在 root 包下，这样所有的子包、类都可以被查找到。

@ComponentScan

为 @Configuration注解的类配置组件扫描指令。同时提供与 Spring XML’s 元素并行的支持。

通俗的讲，@ComponentScan 注解会自动扫描指定包下的全部标有 @Component注解 的类，并注册成bean，当然包括 @Component 下的子注解@Service、@Repository、@Controller。@ComponentScan 注解没有类似 、的属性。