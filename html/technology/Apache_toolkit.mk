toolkit 工具包

##### commons-validator（通用验证系统）
    验证体系对付用户界面的用户千变万化的输入可能。

##### Apache ShardingSphere（分布式数据库中间件）
    一套开源的分布式数据库中间件解决方案组成的生态圈，它由Sharding-JDBC、Sharding-Proxy和Sharding-Sidecar（规划中）这3款相互独立，却又能够混合部署配合使用的产品组成。它们均提供标准化的数据分片、分布式事务和数据库治理功能，可适用于如Java同构、异构语言、云原生等各种多样化的应用场景。

##### Apache Tika
    Apache Tika™工具箱可从一千多种不同的文件类型（例如PPT，XLS和PDF）中检测并提取元数据和文本。所有这些文件类型都可以通过一个界面进行解析，从而使Tika可用于搜索引擎索引，内容分析，翻译等等。
		
##### Apache Nutch
    Nutch是基于Lucene实现的搜索引擎。包括全文搜索和Web爬虫

##### Apache PDFBox® 
    在Apache PDFBox的®库是与PDF文档工作的一个开源的Java工具。该项目允许创建新的PDF文档，处理现有文档以及从文档中提
    取内容的能力。Apache PDFBox还包含几个命令行工具。Apache PDFBox在Apache许可证2.0版下发布。		

##### ImageMagick®
    使用ImageMagick的®创建，编辑，撰写，或转换位图图像。它可以读取和写入各种格式的图像（超过200种），包括PNG，JPEG，GIF，
    HEIC，TIFF，DPX，EXR，WebP，Postscript，PDF和SVG。使用ImageMagick调整，翻转，镜像，旋转，扭曲，剪切和变换图像，调整图像颜色，
    应用各种特殊效果，或绘制文本，线条，多边形，椭圆和贝塞尔曲线。

##### Batik
    是一个基于Java技术的SVG(可扩展矢量图)工具包。

##### FOP 
    FOP是由James Tauber发起的一个开源项目，原先的版本是利用xsl-fo将xml文件转换成pdf文件。
    但最新的版本它可以将xml文件转换成pdf，mif，pcl，txt等多种格式以及直接输出到打印机，并且支持使用SVG描述图形。
	
##### XML Graphics 
    XML Graphics：发展 XML 与图形进行转换的计划项目

##### axis2c 
    Axis2/c是一个用C语言实现的Web服务引擎，它服从可扩展的，灵活的Axis架构。Axis2/C可以用来提供web服务，
    也可以作为web服务的客户端。它可以很方便的嵌入到其他软件中，从而使该软件具有web功能。
	
##### WSS4J 
    WSS4J 是 Web服务安全规范 (OASIS Web Service Security , WS-Security) 的 Java 实现。WSS4J 是一个 Java 的类库用来
    对 SOAP 消息进行签名和校验，使用 Apache Axis 和 Apache XML-Security 项目。	

##### Apache Forrest 
    Apache Forrest是一个把来自各种不同的输入数据源转换成用一种或多种输出格式(比如HTML,PDF等)来统一显示的发布系统。它
	基于Apache Cocoon并分离了内容与内容结构,不仅可以生成静态的文档也可以当作一个动态的服务器。

##### Xalan 
    xalan是一套xslt处理器（有C和JAVA语言两种版本），用来将XML文件转换为HTML,TEXT和XML等其他类型文件格式。	
	
##### Anakia 
    Anakia 是一个XML的转化工具，它使用 JDOM 和 Velocity 来将XML文档转换成你所需要的文档格式。
    支持在 Ant 中设置转换任务以及使用 XSL 进行XML文件处理。	
	
##### Roller
    是一个全功能的多用户博客平台。采用Java语言开发		
		
##### Commons-Net 
    Commons项目中封装了各种网络协议的客户端		
	
##### Sanselan 
    是一个纯 Java 的图形库，可以读写各种格式的图像文件，包括快速解析图片信息例如大小/颜色/icc以及元数据等

##### jsoup: 
    Java的HTML解析器
    jsoup是一个用于处理真实世界HTML的Java库。它提供了一个非常方便的API来提取和操作数据，使用最好的DOM，CSS和类似jquery的方法。
	
	
	
##### Quartz: 
    Java的任务调度框架
    Quartz 具有诸如 JTA 事务和集群等功能，可用于企业级应用程序的支持。

##### Ok HTTP：
    HTTP 通讯框架

##### Joda Time：
    作为 Java 中日期和时间类的一个很好的替代品。


##### XStream
	将对象序列化到 XML 中

##### Apache OpenNLP
    Apache OpenNLP软件支持最常见的NLP任务，例如标记化，句子分段，词性标记，命名实体提取，分块，解析和共指解析。这些任务通常是构建更高级的文本处理服务所必需的。OpenNLP还包括最大熵和基于感知器的机器学习。


##### Apache Camel
    骆驼是 开源集成框架 使您能够快速轻松地集成使用或生成数据的各种系统。
    装满 数百个组件用于访问数据库，消息队列，API或基本上在阳光下的任何东西。帮助您与一切集成。

	
		

```
kail_linux：
	更新源：
	 vi /etc/apt/sources.list
		 #中科大
		deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
		deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

		#阿里云
		#deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
		#deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib

		#清华大学
		#deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
		#deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

		#浙大
		#deb http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free
		#deb-src http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free

		#东软大学
		#deb http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib
		#deb-src http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib

		#官方源
		#deb http://http.kali.org/kali kali-rolling main non-free contrib
		#deb-src http://http.kali.org/kali kali-rolling main non-free contrib

		#重庆大学
		#deb http://http.kali.org/kali kali-rolling main non-free contrib
		#deb-src http://http.kali.org/kali kali-rolling main non-free contrib
		
	保存后之后回到命令行下执行命令：
		apt-get update && apt-get upgrade && apt-get dist-upgrade

		apt-get clean #删除以下载的包

		reboot #重新启动

	或者
		apt-get clean    //清除缓存索引
		apt-get update    //更新索引文件
		apt-get upgrade    //更新实际的软件包文件
		apt-get dist-upgrade    //根据依赖关系更新

	备注：
		apt-get常用命令:
		update – 取回更新的软件包列表信息
		upgrade – 进行一次升级
		install – 安装新的软件包(注：软件包名称是 libc6 而非 libc6.deb)
		remove – 卸载软件包
		purge – 卸载并清除软件包的配置
		autoremove – 卸载所有自动安装且不再使用的软件包
		dist-upgrade – 发布版升级，见 apt-get(8)
		dselect-upgrade – 根据 dselect 的选择来进行升级
		build-dep – 为源码包配置所需的编译依赖关系
		clean – 删除所有已下载的包文件
		autoclean – 删除已下载的旧包文件
		check – 核对以确认系统的依赖关系的完整性
		source – 下载源码包文件
		download – 下载指定的二进制包到当前目录
		changelog – 下载指定软件包，并显示其changelog	

```
	
	
	
	
	
	
	
	
	
 