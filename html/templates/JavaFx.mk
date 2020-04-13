# JavaFX架构
JavaFX公共API下方是运行JavaFX代码的引擎。它由子组件组成，这些子组件包括JavaFX高性能图形引擎Prism；一个小型高效的窗口系统，称为Glass；媒体引擎和Web引擎。尽管这些组件没有公开公开，但是它们的描述可以帮助您更好地了解运行JavaFX应用程序的组件。
- Scene Graph 场景图
- Java Public APIs for JavaFX Features 用于JavaFX功能的Java公共API
- Graphics System 图形系统
- Glass Windowing Toolkit 玻璃窗工具包
- Media and Images 媒体和图片
- Web Component Web组件
- CSS CSS引擎
- UI Controls UI控件
- Layout 布局
- 2-D and 3-D Transformations 2D和3D转换
- Visual Effects 视觉效果

#### **JavaFX体系结构图**

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/jfxar_dt_001_arch-diag.png)

JavaFX体系结构图显示了堆栈。顶层显示在一个圆形的栗色框中，表示JavaFX公共API和JavaFX场景图。下一层是圆形的蓝色框中的Quantum Toolkit。第三层在一个圆形的蓝色框中具有称为Prism的图形管道，在一个方形的豌豆绿色框中具有一个玻璃窗口工具包（Glass），在一个方形的鲜绿色框中具有媒体引擎，在一个方形的棕色框中具有Web引擎。第四层由圆形的蓝色框中的Java 2D，OpenGL和Direct3D（D3D）组成。均以圆形蓝色框显示的Quantum Toolkit，Prism，Java 2D，OpenGL和D3D组成了JavaFX图形系统。最低层（以浅紫色显示）是Java虚拟机。Java虚拟机位于JavaFX图形系统，Glass Windowing Toolkit，媒体引擎和Web引擎的下面。
## Scene Graph 场景图
如图2-1的顶层所示，JavaFX场景图是构建JavaFX应用程序的起点。它是节点的分层树，代表应用程序用户界面的所有可视元素。它可以处理输入并可以呈现。

场景图中的单个元素称为节点。每个节点都有一个ID，样式类和边界量。除了场景图的根节点之外，场景图中的每个节点都有一个父级和零个或多个子级。它还可以具有以下内容：

- 效果，例如模糊和阴影
- 不透明度
- 变身
- 事件处理程序（例如鼠标，键和输入法）
- 特定于应用程序的状态

与Swing和Abstract Window Toolkit（AWT）不同，JavaFX场景图除了具有控件，布局容器，图像和媒体之外，还包括图形基元，例如矩形和文本。

对于大多数用途，场景图简化了使用UI的工作，尤其是在使用丰富的UI时。使用javafx.animation API可以快速完成对场景图中的各种图形进行动画处理，并且声明性方法（例如XML doc）也可以很好地工作。

该javafx.scene API允许创建和指定多种类型的内容，例如：

- 节点：形状（2-D和3-D），图像，媒体，嵌入式Web浏览器，文本，UI控件，图表，组和容器
- 状态：内容的变换（节点的位置和方向），视觉效果以及其他视觉状态
- 效果：更改场景图节点外观的简单对象，例如模糊，阴影和颜色调整

有关更多信息，请参见使用[JavaFX场景图文档。](https://docs.oracle.com/javase/8/javafx/scene-graph-tutorial/scenegraph.htm#JFXSG107)

### SubScene 场景图
SubScene节点是场景图中内容的容器。它是用于场景分离的特殊节点。它可以用于使用其他相机渲染场景的一部分。如果要在布局中使3D对象的Y向上和2D UI对象的Y向下，则可以使用SubScene节点。

SubScene的一些可能用例是：

- UI控件的叠加层（需要静态相机）
- 背景参考底图（静态或更新频率较低）
- “抬头”显示
- 3D对象为Y向上，而2D UI为Y向下。

### Light 光
现在，光线也被定义为场景图中的一个节点。如果场景中包含的一组活动光源为空，则提供默认光源。每盏灯都包含一组受影响的节点。如果一组节点为空，则将影响场景（或子场景）上的所有节点。如果父节点位于该节点集中，则其所有子节点也会受到影响。

灯光与Shape3D对象的几何形状及其材质相互作用以提供渲染结果。当前，有两种类型的光源：

- AmbientLight -似乎来自各个方向的光源。
- PointLight -在空间中具有固定点并在远离自身的所有方向上均等地辐射光的光源。

类层次结构：
```
javafx.scene.Node
   javafx.scene.LightBase (abstract)
      javafx.scene.AmbientLight
      javafx.scene.PointLight
```

## 用于JavaFX功能的Java公共API

图2-1中所示的JavaFX体系结构的顶层提供了一组完整的Java公共API，它们支持富客户端应用程序开发。这些API为构建富客户端应用程序提供了无与伦比的自由度和灵活性。JavaFX平台将Java平台的最佳功能与全面的沉浸式媒体功能相结合，形成了直观，全面的一站式开发环境。这些用于JavaFX的Java API功能：

- 允许使用强大的Java功能，例如泛型，注释，多线程和Lamda表达式（在Java SE 8中引入）。
- 使Web开发人员更容易使用其他基于JVM的动态语言（例如Groovy和JavaScript）中的JavaFX。
- 允许Java开发人员使用其他系统语言（例如Groovy）来编写大型或复杂的JavaFX应用程序。
- 允许使用包括对高性能延迟绑定，绑定表达式，绑定序列表达式和部分绑定重新评估的支持的绑定。替代语言（例如Groovy）可以使用此绑定库来引入类似于JavaFX Script的绑定语法。
- 扩展Java集合库以包括可观察的列表和映射，这使应用程序可以将用户界面连接到数据模型，观察那些数据模型中的更改并相应地更新相应的UI控件。

JavaFX API和编程模型是JavaFX 1.x产品线的延续。大多数JavaFX API已直接移植到Java。根据从JavaFX 1.x版本的用户收到的反馈，对一些API（例如Layout和Media）以及许多其他详细信息进行了改进和简化。JavaFX更加依赖于Web标准，例如CSS用于样式控制，而ARIA用于可访问性规范。其他网络标准的使用也正在审查中。

## 图形系统
图2-1中以蓝色显示的JavaFX图形系统是JavaFX场景图形层下面的实现细节。它支持2-D和3-D场景图。当系统上的图形硬件不足以支持硬件加速渲染时，它将提供软件渲染。

JavaFX平台上实现了两个图形加速管道：

- **Prism**提供了流程渲染工作,它可以在包括3-D在内的硬件和软件渲染器上运行。它负责JavaFX场景的栅格化和渲染。根据所使用的设备，以下多个渲染路径是可能的：
    - Windows XP和Windows Vista上的DirectX 9
    - Windows 7上的DirectX 11
    - Mac，Linux，嵌入式上的OpenGL
    - 无法进行硬件加速时的软件渲染
    
    尽可能使用完全硬件加速的路径，但是当不可用时，将使用软件渲染路径，因为软件渲染路径已经在所有Java运行时环境（JRE）中分发。在处理3D场景时，这一点尤其重要。但是，使用硬件渲染路径时，性能会更好。
- **Quantum Toolkit**将Prism和Glass Windowing Toolkit捆绑在一起，并使它们可用于堆栈中位于其上方的JavaFX层。它还管理与渲染与事件处理相关的线程规则。

## 玻璃窗工具包
Glass Windowing Toolkit（图2-1中部以米色显示）是JavaFX图形堆栈中的最低级别。它的主要职责是提供本机操作服务，例如管理窗口，计时器和表面。它用作将JavaFX平台连接到本机操作系统的平台相关层。

Glass工具包还负责管理事件队列。与管理自己的事件队列的抽象窗口工具包（AWT）不同，Glass工具包使用本机操作系统的事件队列功能来调度线程使用。另外，与AWT不同，Glass工具箱与JavaFX应用程序在同一线程上运行。在AWT中，AWT的本机部分在一个线程上运行，而Java级别在另一个线程上运行。这引入了很多问题，其中许多问题是通过使用单一JavaFX应用程序线程方法在JavaFX中解决的。

#### Threads 线程数
系统在任何给定时间运行两个或多个以下线程
- **JavaFX应用程序线程** 这是JavaFX应用程序开发人员使用的主要线程。必须从此线程访问任何“实时”场景，该场景是窗口的一部分。可以在后台线程中创建和操作场景图，但是当其根节点连接到场景中的任何活动对象时，必须从JavaFX应用程序线程访问该场景图。这使开发人员可以在后台线程上创建复杂的场景图，同时保持“实时”场景上的动画流畅，快速。JavaFX应用程序线程是与Swing和AWT事件调度线程（EDT）不同的线程，因此在将JavaFX代码嵌入到Swing应用程序中时必须小心。
- **Prism渲染线程** 此线程与事件分发程序分开处理渲染。它允许在处理帧N +1时渲染帧N。执行并发处理的能力是一个很大的优势，特别是在具有多个处理器的现代系统上。Prism渲染线程可能还具有多个栅格化线程，这些线程可帮助卸载渲染​​中需要完成的工作。
- **媒体线程** 此线程在后台运行，并使用JavaFX应用程序线程通过场景图同步最新帧。
#### Pulse 脉冲
脉冲是一个事件，向JavaFX场景图指示是时候将该场景图上的元素的状态与Prism同步了。最多以每秒60帧（fps）的速度调节脉冲，并在场景图上运行动画时将其触发。即使动画没有运行，当场景图中的某些内容发生更改时，也会安排一个脉冲。例如，如果按钮的位置改变，则调度脉冲。

当发射脉冲时，场景图上元素的状态向下同步到渲染层。脉冲使应用程序开发人员可以异步处理事件。这一重要功能使系统可以批量处理和执行脉冲事件。

布局和CSS也与脉冲事件相关。场景图中的许多更改都可能导致多个布局或CSS更新，从而可能严重降低性能。系统每个脉冲自动执行一次CSS和布局遍历，以避免性能下降。应用程序开发人员还可以根据需要手动触发布局遍历，以便在脉冲之前进行测量。

Glass Windowing Toolkit 负责执行脉冲事件。它使用高分辨率的本地计时器进行执行。

## 媒体和图片
JavaFX媒体功能可通过javafx.scene.mediaAPI获得。JavaFX同时支持视觉和音频媒体。提供了对MP3，AIFF和WAV音频文件以及FLV视频文件的支持。JavaFX媒体功能是作为三个独立的组件提供的：Media对象代表媒体文件，MediaPlayer播放媒体文件，MediaView是显示媒体的节点。

Media Engine组件（在图2-1中以绿色显示）在设计时充分考虑了性能和稳定性，并提供跨平台的一致行为。有关更多信息，请阅读[将媒体资产合并到JavaFX Applications文档中。](https://docs.oracle.com/javase/8/javafx/media-tutorial/index.html)

## Web Component  Web组件
Web组件是基于Webkit的JavaFX UI控件，它通过其API提供Web查看器和完整的浏览功能。该Web引擎组件（基于图2-1中的橙色所示）基于WebKit，WebKit是一个开源Web浏览器引擎，支持HTML5，CSS，JavaScript，DOM和SVG。它使开发人员能够在其Java应用程序中实现以下功能：

- 从本地或远程URL呈现HTML内容
- 支持历史记录并提供前进和后退导航
- 重新加载内容
- 将效果应用于Web组件
- 编辑HTML内容
- 执行JavaScript命令
- 处理事件

该嵌入式浏览器组件由以下类组成：
- WebEngine 提供基本的网页浏览功能。
- WebView封装WebEngine对象，将HTML内容合并到应用程序的场景中，并提供用于应用效果和转换的字段和方法。它是Node类的扩展。
此外，可以通过JavaScript控制Java调用，反之亦然，以允许开发人员充分利用这两种环境。有关JavaFX嵌入式浏览器的更详细的概述，请参阅[向JavaFX应用程序中添加HTML内容文档。](https://docs.oracle.com/javase/8/javafx/embedded-browser-tutorial/overview.htm#JFXWV135)


## CSS
JavaFX级联样式表（CSS）能够将自定义样式应用于JavaFX应用程序的用户界面，而无需更改该应用程序的任何源代码。CSS可以应用于JavaFX场景图中的任何节点，并且可以异步地应用于节点。JavaFX CSS样式也可以在运行时轻松地分配给场景，从而允许应用程序的外观动态变化。

JavaFX CSS基于W3C CSS版本2.1规范，并且在当前版本3的基础上进行了一些补充。JavaFXCSS支持和扩展旨在允许任何兼容的CSS解析器（甚至是那些兼容的CSS解析器）对JavaFX CSS样式表进行干净的解析。不支持JavaFX扩展。这样可以将用于JavaFX和其他目的（例如HTML页面）的CSS样式混合到一个样式表中。所有JavaFX属性名称都以“ -fx-” 供应商扩展名作为前缀，包括那些似乎与标准HTML CSS兼容的名称，因为某些JavaFX值的语义略有不同。

有关JavaFX CSS的更多详细信息，请参阅[使用CSS设置JavaFX应用程序的外观文档。](https://docs.oracle.com/javase/8/javafx/user-interface-tutorial/css_tutorial.htm#JFXUI733)

## UI Controls UI控件
通过JavaFX API可用的JavaFX UI控件是通过使用场景图中的节点来构建的。它们可以充分利用JavaFX平台的视觉丰富功能，并且可以跨不同平台移植。JavaFX CSS允许UI控件的主题化和外观化。

图2-3显示了当前支持的一些UI控件。这些控件位于javafx.scene.control程序包中。

有关所有可用JavaFX UI控件的更多详细信息，请参阅[使用JavaFX UI控件](http://www.oracle.com/pls/topic/lookup?ctx=javase80&id=JFXUI) 和该包的[API文档](https://docs.oracle.com/javase/8/javafx/api/) javafx.scene.control。

## Layout 布局
布局容器或窗格可用于允许在JavaFX应用程序的场景图中灵活，动态地布置UI控件。JavaFX Layout API包含以下容器类，这些容器类可自动执行常见的布局模型：

- 本BorderPane类勾画出其内容节点上，下，左，右，或中心区域。
- 该HBox级水平排列其内容节点在单行。
- 所述VBox类垂直排列其内容节点在单个列中。
- 该StackPane班将它的内容节点在后到前的单堆。
- 本GridPane类允许开发人员创建的行和列的灵活的网格中，奠定了内容节点。
- 的FlowPane类排列在水平或垂直它的内容节点“流”，包裹在指定的宽度（对于水平）或高度（对于垂直）的边界。
- 该TilePane班将它的内容节点，大小均匀的布局单元格或瓷砖
- 在AnchorPane类允许开发人员创建锚节点的顶部，底部，左侧，或中心的布局。

为了实现所需的布局结构，可以在JavaFX应用程序中嵌套不同的容器。

要了解有关如何使用布局的更多信息，请参见 [在JavaFX中使用布局。](http://www.oracle.com/pls/topic/lookup?ctx=javase80&id=JFXLY) 有关JavaFX布局API的更多信息，请参阅该javafx.scene.layout包的API文档。

## 2-D and 3-D Transformations 2D和3D转换
可以使用以下javafx.scene.tranform类在xy坐标中转换JavaFX场景图中的每个节点：
- translate –相对于其初始位置，沿着x，y，z平面将节点从一个位置移动到另一个位置。
- scale –根据缩放比例，调整节点的大小以使其在x，y，z平面中显示更大或更小。
- shear–旋转一个轴，以使x轴和y轴不再垂直。节点的坐标将移动指定的乘数。
- rotate –围绕场景的指定枢轴点旋转节点。
- affine–执行从2-D / 3-D坐标到其他2-D / 3-D坐标的线性映射，同时保留直线的“直线”和“平行”属性。此类应用使用Translate，Scale，Rotate，或Shear变换，而不是直接使用的类。

要了解有关使用转换的更多信息，请参阅 [《在JavaFX中应用转换》](https://docs.oracle.com/javase/8/javafx/visual-effects-tutorial/transforms.htm#JFXTE139) 文档。有关javafx.scene.transformAPI类的更多信息，请参阅 [API文档。](https://docs.oracle.com/javase/8/javafx/api/) 

## Visual Effects 视觉效果
JavaFX场景图中富客户端接口的开发涉及使用Visual Effects或Effects来实时增强JavaFX应用程序的外观。JavaFX效果主要基于图像像素，因此，它们采用场景图中的节点集，将其渲染为图像，并对其应用指定的效果。

JavaFX中可用的某些视觉效果包括以下类的使用：

- Drop Shadow –在要应用效果的内容后面渲染给定内容的阴影。
- Reflection –在实际内容下方呈现内容的反射版本。
- Lighting –模拟照在给定内容上的光源，并且可以使平面对象具有更逼真的三维外观。

有关如何使用某些可用视觉效果的示例，请参见 [创建视觉效果](https://docs.oracle.com/javase/8/javafx/visual-effects-tutorial/visual_effects.htm#JFXTE191) 文档。有关所有可用视觉效果类的更多信息，请参见该包的API文档javafx.scene.effect。

