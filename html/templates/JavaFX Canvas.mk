# 使用 Canvas API
### 总览
JavaFX Canvas API提供了可以写入的自定义纹理。它是由类中定义Canvas并GraphicsContext在javafx.scene.canvas包中。使用此API涉及创建一个Canvas对象，获取其对象，GraphicsContext并调用绘图操作以在屏幕上呈现您的自定义形状。因为Canvas是Node子类，所以可以在JavaFX scene （场景图）中使用它。

### Canvas
Canvas 是可以使用GraphicsContext。提供的图形命令集绘制的图像。

一个 Canvas节点被构造成具有宽度和高度，指定到其中的画布绘图命令被描绘的图像的大小。所有绘图操作都被裁剪到该图像的边界。

### GraphicsContext
```text
Canvas canvas = new Canvas(300, 250);
GraphicsContext gc = canvas.getGraphicsContext2D();
```
- This class is used to issue draw calls to a Canvas using a buffer.
- 此类用于使用缓冲区向画布发出绘制调用。
- Each call pushes the necessary parameters onto the buffer where they will be later rendered onto the image of the Canvas node by the rendering thread at the end of a pulse.
- 每次调用都会将必要的参数推送到缓冲区，然后在脉冲结束时由渲染线程将它们渲染到画布节点的图像上。
- A Canvas only contains one GraphicsContext, and only one buffer. If it is not attached to any scene, then it can be modified by any thread, as long as it is only used from one thread at a time. Once a Canvas node is attached to a scene, it must be modified on the JavaFX Application Thread.
- 画布只包含一个GraphicsContext和一个缓冲区。如果它没有附加到任何场景，那么它可以被任何线程修改，只要它一次只能从一个线程使用。将画布节点附加到场景后，必须在JavaFX应用程序线程上对其进行修改。
- Calling any method on the GraphicsContext is considered modifying its corresponding Canvas and is subject to the same threading rules.
- 在GraphicsContext上调用任何方法都将被视为修改其相应的画布，并受相同的线程规则的约束。
- A GraphicsContext also manages a stack of state objects that can be saved or restored at anytime.
-  GraphicsContext还管理一堆可以随时保存或恢复的状态对象堆栈。




























