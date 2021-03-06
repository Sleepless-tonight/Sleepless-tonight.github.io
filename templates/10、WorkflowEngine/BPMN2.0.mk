## BPMN 2.0

### 3.1. BPMN 2.0是什么呢？

业务流程模型注解（Business Process Modeling Notation - BPMN）是 业务流程模型的⼀种标准图形注解。这个标准 是由对象管理组（Object Management Group - OMG）维护的。

基本上，BPMN规范定义了任务看起来怎样的，哪些结构可以 与其他进⾏连接，等等。这就意味着 意思不会被误解。

标准的早期版本（1.2版以及之前）仅仅限制在模型上， ⽬标是在所有的利益相关者之间形成通⽤的理解， 在⽂档，讨论和实现业务流程之上。 BPMN标准证明了它⾃⼰，现在市场上许多建模⼯具 都使⽤了BPMN标准中的元素和结构。实际上，现在的jPDL设计器也使⽤了 BPMN元素。


BPMN规范的2.0版本，当前已经处于最终阶段了， 已经计划不就就会完成，允许添加精确的技术细节 在BPMN的图形和元素中， 同时制定BPMN元素的执行语法。 通过使用XML语言来指定业务流程的可执行语法， BPMN规范已经演变为业务流程的语言， 可以执行在任何兼容BPMN2的流程引擎中， 同时依然可以使用强大的图形注解。

### 3.2. 历史和目标

jBPM BPMN2的实现是在jBPM 4.0发布之后 在2009年8月，在与社区进行了紧密协作之后启动的。 而后，我们决定了第一个发布版（比如，文档/QA） 涉及一部分BPMN2规范，将在jBPM 4.3发布。

我们的目标是建立一个原生BPMN2运行引擎 （或者说实现'可执行的BPMN2'）基于流程虚拟机 （Process Virtual Machine - PVM）。 注意，这个版本的主要目标是原生可执行， 不是图形注解 - 但是我们清楚 对于未来的版本是很重要的。

如果用户已经了解了jBPM，就会发现

- 配置结构保持不变
- API与已经存在的完全一样或者很类似
- 测试BPMN2流程也可以使用常用的java测试框架
- 数据库表结构保持不变

所以，总体来说，我们的主要目标是保持所有在jBPM上好的事情， 加强它们，使用一个标准的流程语言。

### 3.3. JPDL vs BPMN 2.0
第一个问题可能是，很正当的，映入脑海的是， 为什么已经有了jPDL还要实现BPMN2。它们两个语言 的目标都是定义可执行的业务流程。从高层次来看， 两个语言是等效的。主要的区别是 BPMN2是“厂商中立”的，你可以使用标准， 而jPDL是绑定在jBPM上的（虽然会有一些争论 绑定在开源语言厂商比如jPDL 和绑定在闭源产品）。

在jBPM中，两个语言实现都是建立在jBPM流程虚拟机上的 （PVM）。这意味着两个语言共享通用功能 （持久化，事务，配置，也有基本流程结构，等等）。 结果就是，对jBPM核心的优化 会对两个语言有益。依靠PVM，BPMN2实现 建立在基础上，已经在过去证明了它自己， 并拥有了很大的最终用户社区。

当执行语言，把它们相互比较的时候， 下面几点必须纳入考虑：

- BPMN2是基于被BPM工业接受的一个标准。
- BPMN2是与实现无关的。这一点的缺点是集成java技术 jPDL总会更早。 所以，从java开发者的角度，jPDL更简单，感觉更自然 （一些BPEL/WSDL的“层次”也在BPMN中）。
- jPDL的一个目标是XML可读，BPMN2流程在 一定程度上也是可读的，但是工具和更多规范的细节 会要求实现同等级的 生产力。
- java开发者可以很快学会jPDL，因为他们很了解jPDL语言， 会发现实用工具有时候很麻烦， 语言本身也过于复杂了。
- BPMN2包含一个很大的描述结构的集合，在规范中。 然而，对接口代码的绑定在规范中是开放的 （与XPDL相比），即使WSDL通常会被默认使用。 这意味着流程的可移植性丧失了， 当我们把流程移植到一个引擎上，而这个引擎不支持同样的绑定机制。 比如，调用java类通常是jBPM的默认实现 的绑定方式。

很自然的，因为政治原因，BPMN2规范发展的会比较慢。 jPDL就可以快速变化，和新技术进行集成， 当他们发布的时候， 与BPMN2相比可以加快步伐进行演化。 当然，因为两个都建立在同一个PVM上，jPDL中的逻辑 也可以一直到BPMN2上， 作为一个扩展，不会出现很多麻烦。

### 3.4. Bpmn 2.0 执行
BPMN2规范定义了非常丰富的语言，为建模和执行业务流程。 然而，也意味着它非常困难总览BPMN2可能是怎样 为了简化这种情况，我们决定把 BPMN2结构分为三个等级。 区分的方式主要基于Bruce Silver写的 'BPMN method and Style'这本书(http://www.bpmnstyle.com/)， Dr. Jim Arlow的培训资料( http://www.slideshare.net/jimarlow/introductiontobpmn005)， 'How much BPMN do you need'( http://www.bpm-research.com/2008/03/03/how-much-bpmn-do-you-need/)， 和我们自己的经验。

我们定义了三种BPMN2结构分类：

- **基本**：这个分类的结构很直接 并且容易了解。这个分类的结构可以用来为 简单的业务流程建模。
- **高级**：包含更强大或更复杂的结构， 这些都提高了建模和执行语法的学习曲线。 业务流程的主要目标是使用这个 和之前的分类来实现结构。
- **复杂**：这个分类的结构用来实现罕见的情况， 或者它们的语法难以理解。

### 3.5. 配置

### 3.6. 实例
### 3.7. 流程根元素


### 3.8. 基本结构
#### 3.8.1. 事件（Events）
与活动和网关一起，事件用来在实际的每个业务流程中。 事件让业务建模工具用很自然的方式描述业务流程，比如 '当我接收到客户的订单，这个流程就启动'， '如果两天内任务没结束，就终止流程' 或者'当我收到一封取消邮件，当流程在运行时， 使用子流程处理邮件'。注意典型的业务 通常使用这种事件驱动的方式。人们不会硬编码顺序创建， 但是他们倾向于使用在他们的环境中发生的事情（比如，事件）。 在BPMN规范中，描述了很多事件类型，为了覆盖可能的事情， 在业务环境中可能出现的情况。
> 总结：   
> 事件用来表明流程的生命周期中发生了什么事。   
> 例如 流程的开始 或者 流程的结束  
> 比如：开始事件、时间开始事件、边界消息事件、  
> 比如：结束事件、消息结束事件、错误结束事件、  

#### 3.8.2. 事件：空启动事件
一个启动事件说明了流程的开始（或子流程）。图形形式，它看起来 是一个圆（可能）内部有一个小图标。图标指定了事件的实际类型 会在流程实例创建时被触发。

空启动事件画出来是一个圆，内部没有图标，意思是 这个触发器是未知或者未指定的。

#### 3.8.3. 事件：空结束事件
结束事件指定了流程实例中一个流程路径的结束。 图形上，它看起来就是一个圆 拥有厚边框（可能） 内部有小图标。 图标指定了结束的时候 会执行哪种操作。

空结束事件画出来是一个圆，拥有厚边框，内部没有图标， 这意味着当流程到达事件时，不会抛出任何信号。

下面的例子显示了只使用空开始和结束事件的流程：

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.none.start.end.event.png)

#### 3.8.4. 事件：终止结束事件
终止和空结束事件的区别是 实际中流程的路径是如何处理的（或者使用BPMN 2.0的术语叫做token）。 终止结束事件会结束整个流程实例，而空结束事件只会结束当前流程路径。 他们都不会抛出任何事情 当到达结束事件的时候。

终止结束事件被描绘成结束事件一样（圆，厚边框）， 内部图标时一个完整的圆。在下面的例子中，完成task1 会结束流程实例，当完成task2时只会结束到达结束事件 的流程路径，只剩下task1打开。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.terminate.end.event.example.png)

#### 3.8.5. 顺序流
顺序流是事件，活动和网关之间的连线，显示为一条实线 带有箭头，在BPMN图形中（jPDL中等效的是transition）。 每个顺序流都有一个源头和一个 目标引用，包含了 活动，事件或网关的id。

与jPDL的一个重要区别是多外向顺序流的行为。 在jPDL中，只有一个转移会成为外向转移，除非活动是fork （或自定义活动拥有fork行为）。然而，在BPMN中， 多外向顺序流的默认行为是切分进入的token（jBPM中术语叫做execution） 分成token集合，每个顺序流一个。在下面情况中， 在完成第一个任务，就会激活三个任务。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.sequence.flow.png)

为了避免使用一个顺序流，必须添加condition条件到顺序流中。 在运行时，只有当condition条件结果为true， 顺序流才会被执行。

为了给顺序流添加condition条件，添加一个conditionExpression 元素到顺序流中。条件可以放在 ${}中。

注意，当前必须把 xsi:type="tFormalExpression"添加到 conditionExpression中。一个条件性的顺序流可以看到一个小菱形图片 在顺序流的起点。记住表达式一直可以定义在顺序流上， 但是一些结构不会解释它（比如，并行网关）。

活动（比如用户任务）和网关（比如唯一网关）可以用户默认顺序流。 默认顺序流只会在活动或网关的 所有其他外向顺序流的condition条件为false时才会使用。 默认顺序流图形像是顺序流多了一个斜线标记。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.default.sequence.flow.png)

默认顺序流通过指定活动或网关的 'default' 属性 来使用。

也要注意，默认顺序流上的表达式会被忽略。

#### 3.8.6. 网关

BPMN中的网关是用来控制流程中的流向的。更确切的是， 当一个token（BPMN 2.0中 execution 的概念注解）到达一个网关， 它会根据网关的类型进行合并或切分。

网关描绘成一个菱形，使用一个内部图标来指定类型 （唯一，广泛，其他）。

所有网关类型，都可以设置gatewayDirection。 下面的值可以使用：

- unspecificed (默认)：网关可能拥有多个 进入和外出顺序流。
- mixed：网关必须拥有多个 进入和外出顺序流。
- converging：网关必须拥有多个进入顺序流， 但是只能有一个外出顺序流。
- diverging：网关必须拥有一个进入顺序流， 和多个外出顺序流。

注意：gatewayDirection属性根据规范是可选的。 这意味着我们不能通过这个属性来 在运行时知道一个网关的行为（比如，一个并行网关， 如果我们用够切分和合并行为）。然而，gatewayDirection属性用在解析时 作为约束条件对进入、外出顺序流。所以使用这个属性 会减低出错的机会，当引用顺序流时， 但不是必填的。

#### 3.8.7. 网关：唯一网关

唯一网关表达了一个流程中的唯一决策。 会有一个外向顺序流被使用，根据定义在 顺序流中的条件。

对应的jPDL结构，相同的语法是 decision 活动。唯一网关的 完全技术名称是'基于数据的唯一网关'， 但是也经常称为XOR 网关。 XOR网关被描绘为一个菱形，内部有一个'X'， 一个空的菱形，没有网关也象征着唯一网关。

下面图形显示了唯一网关的用法：根据amount变量的值， 会选择唯一网关外向的三个外向顺序流 中的一个。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.exclusive.gateway.png)

唯一网关需要所有外向顺序流上都定义条件。 对这种规则一种例外是默认顺序流。 使用default 属性来引用一个已存在的 顺序流的id。这个顺序流会被使用 当其他外向顺序流的条件都执行为false时。

唯一网关可以同时实现汇聚和发散功能。这个逻辑很容易理解： 对于每个到达这个网关的分支流程，都会选择一个外向顺序流来继续执行。 下面的图形在BPMN 2.0中是完全合法的 （忽略名称和声明的条件）。


![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.exclusive.gateway.splitting.and.merging.png)

#### 3.8.8. 网关：并行网关
并行网关用来切分或同步相关的进入或外出 顺序流。
- 并行网关拥有一个进入顺序流的和多于一个的外出顺序流 叫做'并行切分或 'AND-split'。所有外出顺序流都会 被并行使用。注意：像规范中定义的那样， 外出顺序流中的条件都会被忽略。
- 并行网关拥有多个进入顺序流和一个外出顺序流 叫做'并行归并'或 AND-join。所有进入顺序流需要 到达这个并行归并，在外向顺序流使用之前

注意，gatewayDirection属性可以被使用， 已获得建模错误，在解析阶段（参考上面）。

下面的图形显示了一个并行网关可以如何使用。在流程启动后， 'prepare shipment' 和 'bill customer'用户任务都会被激活。 并行网关被描绘为一个菱形，内部图标是一个十字， 对切分和归并行为都是一样。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.parallel.gateway.png)

一个并行网关（其实是任何网关）可以同时拥有切分和汇聚行为。 下面的图形在BPMN 2.0中是完全合法的。 在流程启动之后，A和B任务都会激活。当A和B完成时，C,D和E 任务会被激活。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.parallel.gateway.splitting.and.merging.png)

#### 3.8.9. 网关：包含网关
一个包含网关 - 也叫做OR-gateway - 被用来 进行“条件性”切分或汇聚顺序流。它基本的行为就和一个并行网关一样， 但是它也可以统计条件，在外出顺序流上（切分行为） 和计算，如果这儿有流程离开，可以到达网关（合并行为）。

包含网关显示为一个典型的网关图形，里边有一个圆圈（参考'OR'的语法）。 和唯一网关不同，所有条件表达式被执行（发散或切分行为）。 对于每个表达式结果为true时，一个新的子流程分支就会被创建。 没有定义条件的顺序流会永远被选择（比如。一个子流程 在这种情况下总是会被创建）。

一个收敛的包含网关（合并行为）有一个更困难的执行逻辑。 当一个执行（在BPMN 2.0的语法中叫做Token）到达一个合并包含网关。 就会进行下面的检测（引用规范的文字）：
```
对于每个空的进入顺序流，这里没有Token
在顺序流的图形上面，比如，这里有一个没有直接的路径
（由顺序流组成）从Token到这个顺序流，除非
a) 路径到达了一个包含网关，或
b) 路径到达了一个节点，直接到一个非空的
  进入顺序流的包含网关 "
```
简单来说：当一个流程到达了这个网关，所有的激活流程会被检测 它们是否可以到达包含网关，只是统计顺序流 （注意：条件不会被执行！）。当包含网关被使用时， 它通常用在一个切分/汇聚包含网关对中。在其他情况， 流程行为足够简单，只要通过看图就可以理解了。

当然，不难想象情况，当流程切分和汇聚在复杂的组合， 使用大量的结构，其中包括包含网关。 在那些情况，很可能出现实际的流程行为可能 与建模者的期望不符。所以，当使用包含网关时，要注意 通常的最佳实践是让包含网关成对使用。

下面的图形演示了如何使用包含网关。 （例子来自于Bruce Silver的"BPMN method and style"）


![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.inclusive.gateway.png)


我们可以区分下面的情况：

- 现金多于10000，不是国外银行：只有 "Large deposit" 任务会被激活。
- 现金多于10000，是国外银行： "Large deposit" 和 "Foreign deposit" 任务会被激活。
- 现金少于10000，是国外银行： 只有 "Foreign deposit" 任务会被激活。
- 现金少于10000，不是国外银行： 在这种情况 所有表达式的结果都是false，默认的顺序流会被选择。 在这个例子中国，这意味着"Standard deposit"任务会被激活。

无论在包含网关之后多少任务被激活，右侧的收敛包含网关会等到 左侧的包含网关所有外向顺序流 到达合并网关（有时，只有一个，有时两个）。 

和其他网关类型一样，包含网关类型可以同时拥有合并和切分行为。 在这种情况下，包含网关将先等到所有分支流程到达， 在位每个顺序流进行再次切分之前，这里会有一个表达式执行 为true（获得没有一个表达式）。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.inclusive.gateway.merging.and.splitting.png)


#### 3.8.10. 任务
一个任务表示工作需要被外部实体完成， 比如人工或自动服务。

重要的是注意BPMN语法的'task'与jPDL语法的区别。 在jPDL中，'task'的概念总是用在人工做一些事情的环境。 的那个流程引擎遇到jPDL中的task，它会创建一个task， 交给一些人的任务列表，然后它会进入等待状态。然而在BPMN 2.0中， 这里有很多任务类型，一些表示等待状态（比如，User Task 一些表示自动活动（比如，Service Task。 所以小心不要混淆了任务的概念，在切换语言的时候。

任务被描绘成一个圆角矩形，一般内部包含文字。 任务的类型（用户任务，服务任务，脚本任务，等等）显示在矩形的左上角，用小图标区别。 根据任务的类型， 引擎会执行不同的功能。

> 活动（Activities）是业务流程定义的核心元素，中文可称为“活动”、“节点”、“步骤”。一个活动可以是流程中一个基本处理单元（如人工任务、服务任务），也可以是一个组合单元（如外部子流程、嵌套子流程）。  

#### 3.8.11. 任务：人工任务

user task是典型的'人工任务'， 实际中的每个workflow或BPMN软件中都可以找到。当流程执行到达这样一个user task时， 一个新人工任务就会被创建，交给用户的任务列表。

和manual task的主要区别是 （也与人工工作对应）是流程引擎了解任务。 引擎可以跟踪竞争，分配，时间，其他，这些不是manual task的情况。

user task描绘为一个圆角矩形，在左上角是一个小用户图标。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.user.task.png)

BPMN 2.0规范包含了一些方法把任务分配给用户，组，角色等等。 当前的BPMN 2.0 jBPM实现允许使用一个 resourceAssignmentExpression来分配任务， 结合humanPerformer or PotentialOwner结构。 这部分希望在未来的版本里能够进一步演化。

potentialOwner用来在你希望确定用户，组，角色的时候。 这是一个task的候选人。 参考下面的例子。这里的'My task'任务的候选人组是'management'用户组。 也要注意，需要在流程外部定义一个资源， 这样任务分配器可以引用到这个资源。 实际上，任何活动都可以引用一个或多个资源元素。 目前，只需要定义这个资源就可以了（因为它是规范中的一个必须的元素）， 但是在以后的发布中会进行加强（比如，资源可以拥有运行时参数）。

注意，我们使用了一个特定的后缀 (jbpm:type="group")，来定义这是一个用户组的分配方式。 如果删除了这个属性，就会默认使用用户组的语法 （在这个例子中也是没问题的）。 现在假设Peter和Mary是management组的成员 (这里使用默认的身份服务)：

当分配方式应该是候选用户时， 只需要使用jbpm:type="user"属性。

human performer用来，当你想把一个任务直接分配给一个人， 组，角色时。这个方法的使用方式 看起来和potential owner很像。

因为任务分配已经完成，通过使用 formalExpression，它也可以定义表达式 在运行期解析。表达式本身需要放在 ${}中，这和jBPM一样。 比如，如果流程变量'user'被定义了，然后，它可以用在表达式中。 当然也可以使用更复杂的表达式。

```
<userTask id="myTask" name="My User task">
  <humanPerformer resourceRef="employee">
    <resourceAssignmentExpression>
      <formalExpression>${user}</formalExpression>
    </resourceAssignmentExpression>
  </humanPerformer>
</userTask>
```
注意不需要在humanPerformer元素中使用'jbpm:type'，因为只能进行 直接用户分配。如果任务需要被分配给一个角色或一个组， 使用potentialOwner和group类型（当你把任务分配给一个组时， 组中的所有成员都会成为候选用户 - 参考potentialOwner的用法）。

#### 3.8.12. 任务：Java服务任务

Service Task是一个自动活动，它会调用一些服务， 比如web service，java service等等。当前jBPM引擎 只支持调用java service，但是web service的调用 已经在未来的版本中做了计划。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.service.task.png)

服务任务需要一个必填的id和一个可选的 name。implementation元素 是用来表示调用服务的类型。可选值是WebService, Other或者Unspecified。 因为我们只实现了Java调用， 现在只能选择Other。

服务任务将调用一个操作，operation的id 会在operationRef属性中引用。 这样一个操作就是下面实例的 interface的一部分。每个操作都至少有一个 输入信息，并且 最多有一个输出信息。

对于java服务，接口的名称用来 指定java类的全类名。操作的名称 用来指定将要调用方法名。 输入/输出信息表示着java方法的参数/返回值， 定义如下所示：

BPMN中很多元素叫做'item感知'，包括这个消息结构。 这意味着它们会在流程执行过程中保存或读取item。 负责这些元素的数据结构需要使用ItemDefinition。 在这个环境下，消息指定了它的数据结构， 通过引用 structureRef属性中定义的ItemDefinition。

注意，这写不是标准的BPMN 2.0标准（因此都有'jbpm'的前缀）。 实际上，根据标准，ItemDefinition不应该包含多余一个数据结构定义。 实际在输入参数的映射，使用一个数据结构， 在serviceTask的ioSpecification章节已经完成了。 然而，当前jBPM BPMN 2.0实现还没有实现那个结构。 所以，这意味着当前使用的上面这种方法， 很可能在不久的未来就会出现变化。

重要提醒：接口，ItemDefinitions和消息需要定义在 <process>外边。参考实例 ServiceTaskTest的实际流程和单元测试。

#### 3.8.13. 任务：脚本任务

脚本任务时一个自动活动，当到达这个任务的时候 流程引擎会执行一个脚本。脚本任务使用方式如下：

脚本任务，除了必填id和可选的 name之外，还允许指定 scriptLanguage和script。 因为我们使用了JSR-223（java平台的脚本语言），修改脚本语言就需要：

- 把scriptLanguage 属性修改为JSR-223兼容的名称
- 在classpath下添加JSR规范的ScriptEngine实现    

上面的XML对应图形如下所示（添加了空开始和结束事件）。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.script.task.png)

像上面例子中显示的那样，可以在脚本中使用流程变量。 我们现在可以启动一个这个例子的流程，也要提供一些随机生成的输入变量：

在输出控制台里，我们现在可以看到执行的执行的脚本：


#### 3.8.14. 任务：手工任务

手工任务时一个由外部人员执行的任务，但是没有指定是 一个BPM系统或是一个服务会被调用。在真实世界里，有很多例子： 安装一个电话系统，使用定期邮件发送一封信， 用电话联系客户，等等。

手工任务的目标更像 文档/建模提醒的，因为它 对流程引擎的运行没有任何意义，因此，当流程引擎遇到一个手工任务时 会简单略过。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.manual.task.png)

#### 3.8.15. 任务：java接收任务

receive task 是一个任务会等到外部消息的到来。 除了广泛使用的web service用例，规范在其他环境中的使用也是一样的。 web service用例还没有实现， 但是receive task已经可以在java环境中使用了。

receive task 显示为一个圆角矩形（和task图形一样） 在左上角有一个小信封的图标。
在java环境中，receive task没有其他属性，除了id和name（可选）， 行为就像是一个等待状态。为了在你的业务流程中使用等待状态， 只需要加入如下几行：

流程执行会在这样一个receive task中等待。流程会使用 熟悉的jBPM signal methods来继续执行。 注意，这些可能在未来改变，因为'signal' 在BPMN 2.0中拥有完全不同的含义。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.receive.task.java.png)


### 3.9. 高级结构

#### 3.9.1. 内嵌子流程
子流程的第一目的是实现流程的“继承”，意味着 设计者可以创建多个不同“级别”的细节。顶级视图理解为做 一件事情的最高级别方式，最低的级别 就关注具体细节。

比如下面的图形。在这个模型里，只有最高级的步骤显示出来。 实际的实现"Check credit"步骤隐藏在 折叠子流程中，这可能是最完美的级别 细节来讨论业务流程，与最终用户。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.collapsed.subprocess.png)

子流程的第二种主要功能是子流程"容器"作为 事件的作用域。当一个事件在子流程中触发时，获取事件 在子流程的边界上就会首先获得这个事件。

定义在顶级流程的子流程被称为内嵌子流程。 上级流程中的所有流程数据也可以在子流程中使用。 下面的图形演示了 上面模型的展开形式。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.embedded.subprocess.png)

注意在子流程内部，事件，活动，任务的定义与顶级流程中是一样的。  子流程只允许有一个空开始事件。

结论，一个内嵌子流程会像下面这样运行：当一个流程执行到子流程， 一个子分支会被创建。子分支以后还可以创建其他子分支， 比如，当一个并发网关使用在子流程中。 子流程，只会在没有任何活动的分支时才会完成。 这时，上级流程会 继续执行。

比如，在下面的图形中，"Third task" 只会在"First task"和"Second task"都完成时才会到达。 子流程的其中一个任务不会触发子流程向下运行， 因为另一个分支在子流程中还是活动的。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.subprocess.two.endevents.png)

子流程可以拥有多个开始事件。这种情况下，多个并行分支就在流程中存在。 子流程完成的规则没有改变： 子流程只有在所有并行分支都完成时 才会结束。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.subprocess.parallel.paths.png)

内嵌子流程也是可以的。这时，流程可以分散成多个不同级别的细节。 这里没有对内嵌级别做任何限制。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.subprocess.nested.png)

实现提醒：按照BPMN2规范，一个没有外向顺序流的活动会隐式结束当前分支。 然而当前，必须特别指定一个结束事件 在子流程中，来结束一个分支， 这会在未来的规范兼容过程中加强。

#### 3.9.2. 定时启动事件

定时启动事件用来表示流程需要在指定时间启动。 可以指定一个特殊的时间点（比如，2010年10月10日下午5点）， 但是也可以用一个通常的时间（比如，每个周五的半夜）。

定时启动事件看起来是在圆圈中有一个表的图标。
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.timer.start.event.png)

可以使用下面的时间定义：

- timeDate: 指定一个固定时间， 这时定时器会触发，流程会继续。默认的时间格式是 "dd/MM/yyyy hh:mm:ss"。这是引擎范围的，可以通过设置 配置中的jbpm.duedatetime.format属性来改变。

注意，在使用固定事件时，流程只用在一个单独的事件。 在流程实例创建之后，定时启动事件不会再次触发。

- timeCycle: 指定一个延迟时间段， 相对于流程进入定时器事件时。可以用两种定义方式：

这与jPDL中的定时器时间段定义是完全相同的。注意， BPMN2定时启动事件也可以理解"业务时间"。 这允许，比如定义一个"业务日期"作为周期，从早九点到晚五点。 这样，从下午5点到上午9点的时间就不会被计算， 当事件触发的事件被计算的时候。 请参考jPDL用户手册，获得更多信息，关于如何自定义业务日历。 

- Cron 表达式： 虽然时间段表达式已经很好的覆盖了 延迟定义，有时，它们不太好用。 当，比如，一个流程实例应该在每个周五晚上23点执行， cron表达式允许一个更自然的方式来定义这种重复的行为的发生。

jBPM中实现的定时启动事件也拥有如下的特性：

- 声明了定时启动事件的流程定义，也可以当做一个无启动事件启动。 这就是说，比如调用 executionService.startProcessInstanceByKey(key)也是可以的。
- 定时启动事件的内部实现是一个定时任务。这意味着 必须配置job executor，定时启动事件才能工作。 这种实现的优点是，定时启动事件的触发是事务性的 （比如，如果定时启动事件后的一个服务任务失败了， 事务就会回滚，定时启动事件就会稍后执行） 并且可以应付服务器崩溃。（比如，当服务器备份时， 定时启动事件会由job executor获取， 就像什么也没有发生一样）。
- 当一个拥有定时启动事件的流程定义发布新版本时， 旧版本的定时启动事件的任务会被从系统中删除。这意味着 只有最新版本的流程定义会被使用 来创建一个流程实例。

#### 3.9.3. 中间事件
中间事件用来表示在流程执行过程中发生的事件（比如， 在流程启动之后，在它完成之前）。中间事件看起来就像 一个有着双边线的圆圈，圆圈中的图标表示了事件的类型。

这儿有好多种中间事件类型，比如定时器事件，触发事件，传播事件，等等。 中间事件既可以抛出也可以捕获：

- 抛出：当一个流程到达事件中， 它会立刻触发一个对应的触发器（一个激活，一个错误，等等）。 抛出事件用图形表示起来就是使用黑色填充的图标。
- 捕获：当一个流程到达事件中， 它会等待一个对应的触发器发生（一个错误，一个定时器，等等）。 捕获事件用图形表示起来就是没有使用黑色填充的图标（比如，内部是白色的）。


#### 3.9.4. 内部捕获事件：定时器

内部定时器事件用来表示一个流程的延迟。 直接的用例是收集数据， 只在没有人工作的晚上执行大量的逻辑，等等。

注意，一个内部定时器只能是一个捕获事件（抛出一个定时器事件时没有意义的）。 下面的图形中演示了内部定时器事件的图形形式。

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/bpmn2.intermediate.timer.png)

有两种方法可以来指定延迟，使用timeCycle 或 a timeDate。

下面的延迟定义也是可以用的（这与启动定时器是相同的）。

- timeDate: 指定一个固定时间， 这时定时器会触发，流程会继续。默认的时间格式是 "dd/MM/yyyy hh:mm:ss"。这是引擎范围的，可以通过设置 配置中的jbpm.duedatetime.format属性来改变。

- timeCycle: 指定一个延迟时间段， 相对于流程进入定时器事件时。

- Cron 表达式：允许我们定义延迟，这种方式很多人都知道（因为CRON表达式 在Unix中用来定义任务）。注意一个cron表达式 通常用来定义重复执行。在这个环境下，就是 第一个满足cron表达式的时间点 用来设置定时器事件的持续时间（所以不会重复执行）。

### 3.10. 完全的实例（包括控制台任务表单）
注意，流程变量可以使用 ${my_process_variable}来访问。也要注意输入控件的名称。 （比如，输入文本框，提交表单）可以用来 定义新流程变量。 












































