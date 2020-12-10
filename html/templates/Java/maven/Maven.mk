

Maven生命周期
```
1、clean        ：清理上一次构建生成的所有文件；
2、validate
3、compile      ：编译项目的源代码；
4、test         ：运行测试代码；
5、package      ：打包成jar或者war或者其他格式的分发包；
6、verify
7、install      ：将打好的包安装到本地仓库，供其他项目使用；
8、site         ：生成项目的站点文档；
9、deploy       ：将打好的包安装到远程仓库，供其他项目使用；
```






```
1:Maven目录分析
    bin：含有mvn运行的脚本
    boot：含有plexus-classworlds类加载器框架
    conf：含有settings.xml配置文件
    lib：含有Maven运行时所需要的java类库
    Settings.xml 中默认的用户库: ${user.home}/.m2/repository[通过maven下载的jar包都会存储到指定的个人仓库中]
    Maven默认仓库下载地址在: maven的lib目录下maven-model-builder-3.0.4.jar的pom.xml中
2：创建目录结构：
　　Hello
 　　--src   
 　　-----main
 　　----------java       --用来存放Java文件
 　　----------resources   --用来存放资源文件
 　　-----test
 　　---------java        --用来存放测试的Java文件
 　　---------resources
 　　--target           --项目输出位置,编译完毕后自动生成
 　　--pom.xml        -- 项目对象模型的描述 ，它是maven配置的核心
3:建立pom.xml模板：
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <!-- 当前pom的版本号 -->
  <modelVersion>4.0.0</modelVersion>
  <!-- groupId: 当前jar所属的命名空间 -->
  <groupId>cn.bie.maven</groupId>
  <!-- 当前项目模块名称 -->
  <artifactId>Hello</artifactId>
  <!-- 当前项目的版本, SNAPSHOT镜像版 -->
  <version>0.0.1-SNAPSHOT</version>
    <!-- 当前模块需要依赖的相关jar包,也称为依赖管理, 所有被依赖的包都是通过"坐标"定位的 -->
    <dependencies>
        <!-- 需要依赖junit 通过 groupId+artifactId+version来查找,如果本地没有则到中央仓库下载 -->
        <dependency>
            <!-- 当前jar所属的命名空间 -->
            <groupId>junit</groupId>
            <!-- 依赖的项目模块的名称 -->
            <artifactId>junit</artifactId>
            <!-- 依赖的版本号 -->
            <version>4.9</version>
            <!-- 依赖的范围, 有 test compile privlege。test依赖的jar包的使用范围，当测试的时候使用该jar包，正式发布，删除这个 -->
            <scope>test</scope>
        </dependency>        
    </dependencies>
</project>

4：settings模板：

<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <!--本地仓库-->
    <localRepository>~/.m2/repository</localRepository>
    <!--Maven是否与用户交互,默认值为true-->
    <interactiveMode>true</interactiveMode>
    <!--离线模式,默认值为false-->
    <offline>false</offline>
    <!--插件组-->
    <pluginGroups></pluginGroups>
    <!--代理-->
    <proxies></proxies>
    <!--下载与部署仓库的认证信息-->
    <servers></servers>
    <!--仓库镜像-->
    <mirrors>
        <mirror>
            <id>bluebozRepo</id>
            <mirrorOf>central</mirrorOf>
            <name>Blueboz</name>
                <url>http://bluebozpc:8081/repository/maven-public/</url>
        </mirror>
    </mirrors>
    <!--Settings Profile-->s
    <profiles></profiles>
    <!--激活Profile-->
    <activeProfiles></activeProfile>
</settings>

5:Maven核心概念：
　　5.1：Maven插件
　　　　Maven的核心仅仅定义了抽象的生命周期，具体的任务都是交由插件完成的每个插件都能实现多个功能，每个功能就是一个插件目标
　　　　Maven的生命周期与插件目标相互绑定，以完成某个具体的构建任务, Maven的插件在: .m2\repository\org\apache\maven\plugins
　　5.2：Maven坐标
　　　　类似在平面几何中坐标（x,y）可以标识平面中唯一的一点, Maven世界拥有大量构建，我们需要找一个用来唯一标识一个构建的统一规范
　　　　拥有了统一规范，就可以把查找工作交给机器
　　　　　　groupId：定义当前Maven项目隶属项目  (实际对应JAVA的包的结构, 是main目录里java的目录结构)
　　　　　　artifactId：定义实际项目中的一个模块(项目的唯一的标识符,实际对应项目的名称,就是项目根目录的名称)
　　　　　　version：定义当前项目的当前版本
　　5.3：Maven仓库
　　　　何为Maven仓库：用来统一存储所有Maven共享构建的位置就是仓库
　　　　Maven配置jar包的路径为：groupId/artifactId/version/artifactId-version
　　　　本地仓库(~/.m2/repository/)：每个用户只有一个本地仓库
　　　　中央仓库(Maven默认的远程仓库)：Maven默认的远程仓库下载地址为：http://repo1.maven.org/maven2
　　　　私服：是一种特殊的远程仓库, 它是架设在局域网内的仓库, 主要是为了团队协作开发
　　　　镜像：用来替代中央仓库, 速度一般比中央仓库快
　　5.4：软件构建生命周期,maven软件构建的生命周期
　　　　　　清除--> 编译-->测试-->报告-->打包（jar\war）-->安装-->部署。
　　　　 maven生命周期命令插件（命令：mvn clean）：clean--compile--test--package--install-deploy。
　　　　 maven坐标：maven通过坐标的概念来唯一标识jar包或者war包
```
删除 Maven 下载的半成品

```
cd %userprofile%\.m2\repository
for /r %i in (*.lastUpdated) do del %i
```
