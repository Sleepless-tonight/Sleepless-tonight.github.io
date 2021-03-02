# JavaFX Stage 舞台
### 总览
JavaFX Stage .类是顶级JavaFX容器。初级阶段由平台构建。Application 可以构造Stage对象。

Stage 对象必须在JavaFX Application Thread上构造和修改。

The JavaFX Application Thread is created as part of the startup process for the JavaFX runtime.

JavaFX Application Thread 是在JavaFX运行时启动过程中创建的。

许多 Stage 属性是只读的，因为它们可以由基础平台在外部进行更改，因此不能绑定。

#### **样式**
Stage 具有以下样式之一：
- StageStyle.DECORATED -具有纯白色背景和平台装饰的舞台。
- StageStyle.UNDECORATED -具有纯白色背景且没有装饰的舞台。
- StageStyle.TRANSPARENT -具有透明背景且没有装饰的舞台。
- StageStyle.UTILITY -具有纯白色背景和最少平台装饰的舞台。

必须先初始化样式，然后才能使舞台可见。

在某些平台上，装饰可能不可用。例如，在某些移动或嵌入式设备上。在这些情况下，将接受对DECORATED或UTILITY窗口的请求，但不会显示任何装饰。

#### **所有者**
A stage can optionally have an owner Window. When a window is a stage's owner, it is said to be the parent of that stage.
stage 可以有一个所有者 Window。当一个 Window 是一个 stage 所有者时，它被称为该 stage 的父级。

拥有的舞台绑定到父窗口。拥有的舞台将始终位于其父窗口的顶部。当父窗口关闭或图标化时，所有拥有的窗口也会受到影响。拥有的舞台不能被独立地标识。

必须先初始化所有者，然后才能使该舞台可见。



































