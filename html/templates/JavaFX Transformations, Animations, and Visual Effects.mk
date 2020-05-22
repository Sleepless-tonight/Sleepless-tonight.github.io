# JavaFX: Transformations, Animations, and Visual Effects
JavaFX：转换，动画和视觉效果

### 1、转换概述
所有转换都位于javafx.scene.transform 包中，并且是Transform该类的子类。

#### Introducing Transformations 变换 介绍
转换会根据某些参数更改图形对象在坐标系中的位置。JavaFX支持以下类型的转换：
- Translation 转换
- Rotation 回转
- Scaling 缩放比例
- Shearing 剪力

These transformations can be applied to either a standalone node or to groups of nodes. You can apply one transformation at a time or you can combine transformations and apply several transformations to one node.
这些变换可以应用于独立节点或节点组。您可以一次应用一个变换，也可以组合转换并将多个变换应用于一个节点。

The Transform class implements the concepts of affine transformations. The Affine class extends the Transform class and acts as a superclass to all transformations. Affine transformations are based on euclidean algebra, and perform a linear mapping (through the use of matrixes) from initial coordinates to other coordinates while preserving the straightness and parallelism of lines. Affine transformations can be constructed using observableArrayLists rotations, translations, scales, and shears. 在Transform类实现仿射变换的概念。本Affine类扩展Transform类，并作为一个超类中的所有变换。仿射变换基于欧几里德代数，并执行线性映射（通过使用矩阵），从初始坐标到其他坐标，同时保留直线的直线性和平行性。可以使用observableArrayLists旋转，平移，缩放和剪切来构造仿射变换。

> Note: 注意：
> > Usually, do not use the Affine class directly, but instead, use the specific Translate, Scale, Rotate, or Shear transformations. 通常，不要Affine直接使用该类，而应使用特定的“平移”，“缩放”，“旋转”或“剪切”变换。

Transformations in JavaFX can be performed along three coordinates, thus enabling users to create three-dimensional (3-D) objects and effects. To manage the display of objects with depth in 3-D graphics, JavaFX implements z-buffering. Z-buffering ensures that the perspective is the same in the virtual world as it is in the real one: a solid object in the foreground blocks the view of one behind it. Z-buffering can be enabled by using the setDepthTest class. You can try to disable z-buffering (setDepthTest(DepthTest.DISABLE)) in the sample application to see the effect of the z-buffer. JavaFX中的变换可以沿着三个坐标执行，从而使用户能够创建三维(3-D)对象和效果。为了在3-D图形中管理具有深度的对象的显示，JavaFX实现了z-buffering。Z-buffering确保虚拟世界中的透视图与现实世界中的透视图相同:前台的实体对象会阻塞后面的视图。可以通过使用setDepthTest类启用z缓冲。您可以尝试在样例应用程序中禁用z-buffering (setDepthTest(DepthTest.DISABLE))，以查看z-buffer的效果。

To simplify transformation usage, JavaFX implements transformation constructors with the x-axis and y-axis along with the x, y, and z axes. If you want to create a two-dimensional (2-D) effect, you can specify only the x and y coordinates. If you want to create a 3-D effect, specify all three coordinates. 为了简化转换的使用，JavaFX使用x轴和y轴以及x、y和z轴实现转换构造函数。如果要创建二维(2d)效果，可以只指定x和y坐标。如果您想要创建一个3d效果，请指定所有三个坐标。

To be able to see 3-D objects and transformation effects in JavaFX, users must enable the perspective camera. 为了能够在JavaFX中查看3-D对象和转换效果，用户必须启用透视相机。

Though knowing the underlying concepts can help you use JavaFX more effectively, you can start using transformations by studying the example provided with this document and trying different transformation parameters. For more information about particular classes, methods, or additional features, see the API documentation. 尽管了解基本概念可以帮助您更有效地使用JavaFX，但是可以通过研究本文档提供的示例并尝试不同的转换参数来开始使用转换。有关特定类，方法或其他功能的更多信息，请参阅API文档。

In this document, a Xylophone application is used as a sample to illustrate all the available transformations. You can download its source code by clicking the transformations.zip link. 在本文档中，木琴应用程序用作示例来说明所有可用的转换。您可以通过单击transformations.zip链接下载其源代码。

### 2、Transformation Types and Examples 转换类型和示例
This document describes specific transformations and provides code examples. 本文档描述了特定的转换并提供了代码示例。

#### Translation 平移
The translation transformation shifts a node from one place to another along one of the axes relative to its initial position. The initial position of the xylophone bar is defined by x, y, and z coordinates. In Example 2-1, the initial position values are specified by the xStart, yPos, and zPos variables. Some other variables are added to simplify the calculations when applying different transformations. Each bar of the xylophone is based on one of the base bars. The example then translates the base bars with different shifts along the three axes to correctly locate them in space. 平移变换将一个节点相对于其初始位置沿一个轴从一个位置移动到另一个位置。木琴横条的初始位置由x，y和z坐标定义。在实施例2-1中，初始位置值由指定的xStart，yPos和zPos变量。应用其他转换时，添加了一些其他变量以简化计算。木琴的每个条都基于基础条之一。然后，该示例将沿三个轴平移的基杆平移，以正确地将其定位在空间中。

Example 2-1 shows a code snippet from the sample application with the translation transformation. 例2-1显示了带有转换转换的示例应用程序中的代码片段。

```
Group rectangleGroup = new Group();
        rectangleGroup.setDepthTest(DepthTest.ENABLE);
 
        double xStart = 260.0;
        double xOffset = 30.0;
        double yPos = 300.0;
        double zPos = 0.0;
        double barWidth = 22.0;
        double barDepth = 7.0;
 
        // Base1
        Cube base1Cube = new Cube(1.0, new Color(0.2, 0.12, 0.1, 1.0), 1.0);
        base1Cube.setTranslateX(xStart + 135);
        base1Cube.setTranslateZ(yPos+20.0);
        base1Cube.setTranslateY(11.0);
```
#### Rotation 回转
The rotation transformation moves the node around a specified pivot point of the scene. You can use the rotate method of the Transform class to perform the rotation. 旋转变换将节点围绕场景的指定枢轴点移动。您可以使用类的rotate方法Transform执行旋转。

To rotate the camera around the xylophone in the sample application, the rotation transformation is used, although technically, it is the xylophone itself that is moving when the mouse rotates the camera. 在示例应用程序中，为了使照相机围绕木琴旋转，使用了旋转变换，尽管从技术上讲，当鼠标旋转照相机时，木琴本身才在移动。

Example 2-2 shows the code for the rotation transformation. 例2-2显示了旋转变换的代码。

```
class Cam extends Group {
        Translate t  = new Translate();
        Translate p  = new Translate();
        Translate ip = new Translate();
        Rotate rx = new Rotate();
        { rx.setAxis(Rotate.X_AXIS); }
        Rotate ry = new Rotate();
        { ry.setAxis(Rotate.Y_AXIS); }
        Rotate rz = new Rotate();
        { rz.setAxis(Rotate.Z_AXIS); }
        Scale s = new Scale();
        public Cam() { super(); getTransforms().addAll(t, p, rx, rz, ry, s, ip); }
    }
...
        scene.setOnMouseDragged(new EventHandler<MouseEvent>() {
            public void handle(MouseEvent me) {
                mouseOldX = mousePosX;
                mouseOldY = mousePosY;
                mousePosX = me.getX();
                mousePosY = me.getY();
                mouseDeltaX = mousePosX - mouseOldX;
                mouseDeltaY = mousePosY - mouseOldY;
                if (me.isAltDown() && me.isShiftDown() && me.isPrimaryButtonDown()) {
                    cam.rz.setAngle(cam.rz.getAngle() - mouseDeltaX);
                }
                else if (me.isAltDown() && me.isPrimaryButtonDown()) {
                    cam.ry.setAngle(cam.ry.getAngle() - mouseDeltaX);
                    cam.rx.setAngle(cam.rx.getAngle() + mouseDeltaY);
                }
                else if (me.isAltDown() && me.isSecondaryButtonDown()) {
                    double scale = cam.s.getX();
                    double newScale = scale + mouseDeltaX*0.01;
                    cam.s.setX(newScale); cam.s.setY(newScale); cam.s.setZ(newScale);
                }
                else if (me.isAltDown() && me.isMiddleButtonDown()) {
                    cam.t.setX(cam.t.getX() + mouseDeltaX);
                    cam.t.setY(cam.t.getY() + mouseDeltaY);
                }
            }
        });
```
Note that the pivot point and the angle define the destination point the image is moved to. Carefully calculate values when specifying the pivot point. Otherwise, the image might appear where it is not intended to be. For more information, see the API documentation 请注意，枢轴点和角度定义了图像要移动到的目标点。指定枢轴点时，请仔细计算值。否则，图像可能会出现在原本不希望出现的位置。有关更多信息，请参见API文档。

#### Scaling 缩放比例

The scaling transformation causes a node to either appear larger or smaller, depending on the scaling factor. Scaling changes the node so that the dimensions along its axes are multiplied by the scale factor. Similar to the rotation transformations, scaling transformations are applied at a pivot point. This pivot point is considered the point around which scaling occurs. 缩放变换导致节点根据缩放因子而显得更大或更小。缩放会更改节点，以便沿其轴的尺寸乘以比例因子。与旋转变换类似，缩放变换应用于枢轴点。该枢轴点被认为是发生缩放的点。

To scale, use the Scale class and the scale method of the Transform class. 要缩放，请使用Scale类和该类的scale方法Transform。

In the Xylophone application, you can scale the xylophone using the mouse while pressing Alt and the right mouse button. The scale transformation is used to see the scaling. 在木琴应用程序中，您可以在按住Alt键和鼠标右键的同时，使用鼠标缩放木琴。比例变换用于查看比例。

Example 2-3 shows the code for the scale transformation. 例2-3显示了比例变换的代码。

```
else if (me.isAltDown() && me.isSecondaryButtonDown()) {
          double scale = cam.s.getX();
          double newScale = scale + mouseDeltaX*0.01;
          cam.s.setX(newScale); cam.s.setY(newScale); cam.s.setZ(newScale);
                }
...
```

#### Shearing 剪力 剪切
A shearing transformation rotates one axis so that the x-axis and y-axis are no longer perpendicular. The coordinates of the node are shifted by the specified multipliers. 剪切变换使一个轴旋转，以使x轴和y轴不再垂直。节点的坐标移动指定的乘数。

To shear, use the Shear class or the shear method of the Transform class. 要剪切，请使用Shear该类或该类的shear方法Transform。

In the Xylophone application, you can shear the xylophone by dragging the mouse while holding Shift and pressing the left mouse button. 在木琴应用程序中，可以通过按住Shift并按鼠标左键的同时拖动鼠标来剪切木琴。

Example 2-4 shows the code snippet for the shear transformation. 图2-1剪切转换

```
else if (me.isShiftDown() && me.isPrimaryButtonDown()) {
    double yShear = shear.getY();
    shear.setY(yShear + mouseDeltaY/1000.0);
    double xShear = shear.getX();
    shear.setX(xShear + mouseDeltaX/1000.0);
}
```
#### Multiple Transformations 多重转换
You can construct multiple transformations by specifying an ordered chain of transformations. For example, you can scale an object and then apply a shearing transformation to it, or you can translate an object and then scale it. 您可以通过指定转换的有序链来构造多个转换。例如，您可以缩放对象，然后对其应用剪切变换，也可以平移对象然后对其进行缩放。

Example 2-5 shows multiple transformations applied to an object to create a xylophone bar. 例2-5显示了应用于对象以创建木琴条的多个转换。

Example 2-5 Multiple Transformations 示例2-5多重转换

```
Cube base1Cube = new Cube(1.0, new Color(0.2, 0.12, 0.1, 1.0), 1.0);
        base1Cube.setTranslateX(xStart + 135);
        base1Cube.setTranslateZ(yPos+20.0);
        base1Cube.setTranslateY(11.0);
        base1Cube.setScaleX(barWidth*11.5);
        base1Cube.setScaleZ(10.0);
        base1Cube.setScaleY(barDepth*2.0);
```


### 3、Animation Basics 转换类型和示例

Animation in JavaFX can be divided into timeline animation and transitions. This chapter provides examples of each animation type.

Timeline and Transition are subclasses of the javafx.animation.Animation class. For more information about particular classes, methods, or additional features, see the API documentation.

#### Transitions

Transitions in JavaFX provide the means to incorporate animations in an internal timeline. Transitions can be composed to create multiple animations that are executed in parallel or sequentially. See the Parallel Transition and Sequential Transition sections for details. The following sections provide some transition animation examples.

#### Fade Transition

A fade transition changes the opacity of a node over a given time.

Example 3-1 shows a code snippet for a fade transition that is applied to a rectangle. First a rectangle with rounded corners is created, and then a fade transition is applied to it.

Example 3-1 Fade Transition
```
final Rectangle rect1 = new Rectangle(10, 10, 100, 100);
rect1.setArcHeight(20);
rect1.setArcWidth(20);
rect1.setFill(Color.RED);
...
FadeTransition ft = new FadeTransition(Duration.millis(3000), rect1);
ft.setFromValue(1.0);
ft.setToValue(0.1);
ft.setCycleCount(Timeline.INDEFINITE);
ft.setAutoReverse(true);
ft.play();
```

#### Path Transition
A path transition moves a node along a path from one end to the other over a given time.

Figure 3-1 Path Transition
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/path.jpg)

Example 3-2 shows a code snippet for a path transition that is applied to a rectangle. The animation is reversed when the rectangle reaches the end of the path. In code, first a rectangle with rounded corners is created, and then a new path animation is created and applied to the rectangle.

Example 3-2 Path Transition

```
final Rectangle rectPath = new Rectangle (0, 0, 40, 40);
rectPath.setArcHeight(10);
rectPath.setArcWidth(10);
rectPath.setFill(Color.ORANGE);
...
Path path = new Path();
path.getElements().add(new MoveTo(20,20));
path.getElements().add(new CubicCurveTo(380, 0, 380, 120, 200, 120));
path.getElements().add(new CubicCurveTo(0, 120, 0, 240, 380, 240));
PathTransition pathTransition = new PathTransition();
pathTransition.setDuration(Duration.millis(4000));
pathTransition.setPath(path);
pathTransition.setNode(rectPath);
pathTransition.setOrientation(PathTransition.OrientationType.ORTHOGONAL_TO_TANGENT);
pathTransition.setCycleCount(Timeline.INDEFINITE);
pathTransition.setAutoReverse(true);
pathTransition.play();
```

#### Parallel Transition
A parallel transition executes several transitions simultaneously.

Example 3-3 shows the code snippet for the parallel transition that executes fade, translate, rotate, and scale transitions applied to a rectangle.

Figure 3-2 Parallel Transition
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/parallel.jpg)

Example 3-3 Parallel Transition
```
Rectangle rectParallel = new Rectangle(10,200,50, 50);
rectParallel.setArcHeight(15);
rectParallel.setArcWidth(15);
rectParallel.setFill(Color.DARKBLUE);
rectParallel.setTranslateX(50);
rectParallel.setTranslateY(75);
...
        FadeTransition fadeTransition = 
            new FadeTransition(Duration.millis(3000), rectParallel);
        fadeTransition.setFromValue(1.0f);
        fadeTransition.setToValue(0.3f);
        fadeTransition.setCycleCount(2);
        fadeTransition.setAutoReverse(true);
        TranslateTransition translateTransition =
            new TranslateTransition(Duration.millis(2000), rectParallel);
        translateTransition.setFromX(50);
        translateTransition.setToX(350);
        translateTransition.setCycleCount(2);
        translateTransition.setAutoReverse(true);
        RotateTransition rotateTransition = 
            new RotateTransition(Duration.millis(3000), rectParallel);
        rotateTransition.setByAngle(180f);
        rotateTransition.setCycleCount(4);
        rotateTransition.setAutoReverse(true);
        ScaleTransition scaleTransition = 
            new ScaleTransition(Duration.millis(2000), rectParallel);
        scaleTransition.setToX(2f);
        scaleTransition.setToY(2f);
        scaleTransition.setCycleCount(2);
        scaleTransition.setAutoReverse(true);
        
        parallelTransition = new ParallelTransition();
        parallelTransition.getChildren().addAll(
                fadeTransition,
                translateTransition,
                rotateTransition,
                scaleTransition
        );
        parallelTransition.setCycleCount(Timeline.INDEFINITE);
        parallelTransition.play();
```
#### Sequential Transition
A sequential transition executes several transitions one after another.

Example 3-4 shows the code for the sequential transition that executes one after another. Fade, translate, rotate, and scale transitions that are applied to a rectangle.

Example 3-4 Sequential Transition
```
Rectangle rectSeq = new Rectangle(25,25,50,50);
rectSeq.setArcHeight(15);
rectSeq.setArcWidth(15);
rectSeq.setFill(Color.CRIMSON);
rectSeq.setTranslateX(50);
rectSeq.setTranslateY(50);

...

         FadeTransition fadeTransition = 
            new FadeTransition(Duration.millis(1000), rectSeq);
        fadeTransition.setFromValue(1.0f);
        fadeTransition.setToValue(0.3f);
        fadeTransition.setCycleCount(1);
        fadeTransition.setAutoReverse(true);
 
        TranslateTransition translateTransition =
            new TranslateTransition(Duration.millis(2000), rectSeq);
        translateTransition.setFromX(50);
        translateTransition.setToX(375);
        translateTransition.setCycleCount(1);
        translateTransition.setAutoReverse(true);
 
        RotateTransition rotateTransition = 
            new RotateTransition(Duration.millis(2000), rectSeq);
        rotateTransition.setByAngle(180f);
        rotateTransition.setCycleCount(4);
        rotateTransition.setAutoReverse(true);
 
        ScaleTransition scaleTransition = 
            new ScaleTransition(Duration.millis(2000), rectSeq);
        scaleTransition.setFromX(1);
        scaleTransition.setFromY(1);
        scaleTransition.setToX(2);
        scaleTransition.setToY(2);
        scaleTransition.setCycleCount(1);
        scaleTransition.setAutoReverse(true);

sequentialTransition = new SequentialTransition();
sequentialTransition.getChildren().addAll(
        fadeTransition,
        translateTransition,
        rotateTransition,
        scaleTransition);
sequentialTransition.setCycleCount(Timeline.INDEFINITE);
sequentialTransition.setAutoReverse(true);

sequentialTransition.play();
```
For more information about animation and transitions, see the API documentation and the Animation section in the Ensemble project in the SDK.

#### Timeline Animation
An animation is driven by its associated properties, such as size, location, and color etc. Timeline provides the capability to update the property values along the progression of time. JavaFX supports key frame animation. In key frame animation, the animated state transitions of the graphical scene are declared by start and end snapshots (key frames) of the state of the scene at certain times. The system can automatically perform the animation. It can stop, pause, resume, reverse, or repeat movement when requested.

#### Basic Timeline Animation
The code in Example 3-5 animates a rectangle horizontally and moves it from its original position X=100 to X=300 in 500 ms. To animate an object horizontally, alter the x-coordinates and leave the y-coordinates unchanged.

Figure 3-3 Horizontal Movement
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/basic-timeline.jpg)
Example 3-5 shows the code snippet for the basic timeline animation.

Example 3-5 Timeline Animation
```
final Rectangle rectBasicTimeline = new Rectangle(100, 50, 100, 50);
rectBasicTimeline.setFill(Color.RED);
...
final Timeline timeline = new Timeline();
timeline.setCycleCount(Timeline.INDEFINITE);
timeline.setAutoReverse(true);
final KeyValue kv = new KeyValue(rectBasicTimeline.xProperty(), 300);
final KeyFrame kf = new KeyFrame(Duration.millis(500), kv);
timeline.getKeyFrames().add(kf);
timeline.play();
```
#### Timeline Events
JavaFX provides the means to incorporate events that can be triggered during the timeline play. The code in Example 3-6 changes the radius of the circle in the specified range, and KeyFrame triggers the random transition of the circle in the x-coordinate of the scene.

Example 3-6 Timeline Events

```
import javafx.application.Application;
import javafx.stage.Stage;
import javafx.animation.AnimationTimer;
import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.Timeline;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.effect.Lighting;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.text.Text;
import javafx.util.Duration;
 
public class TimelineEvents extends Application {
    
    //main timeline
    private Timeline timeline;
    private AnimationTimer timer;
 
    //variable for storing actual frame
    private Integer i=0;
 
    @Override public void start(Stage stage) {
        Group p = new Group();
        Scene scene = new Scene(p);
        stage.setScene(scene);
        stage.setWidth(500);
        stage.setHeight(500);
        p.setTranslateX(80);
        p.setTranslateY(80);
 
        //create a circle with effect
        final Circle circle = new Circle(20,  Color.rgb(156,216,255));
        circle.setEffect(new Lighting());
        //create a text inside a circle
        final Text text = new Text (i.toString());
        text.setStroke(Color.BLACK);
        //create a layout for circle with text inside
        final StackPane stack = new StackPane();
        stack.getChildren().addAll(circle, text);
        stack.setLayoutX(30);
        stack.setLayoutY(30);
 
        p.getChildren().add(stack);
        stage.show();
 
        //create a timeline for moving the circle
        timeline = new Timeline();
        timeline.setCycleCount(Timeline.INDEFINITE);
        timeline.setAutoReverse(true);
 
//You can add a specific action when each frame is started.
        timer = new AnimationTimer() {
            @Override
            public void handle(long l) {
                text.setText(i.toString());
                i++;
            }
 
        };
 
        //create a keyValue with factory: scaling the circle 2times
        KeyValue keyValueX = new KeyValue(stack.scaleXProperty(), 2);
        KeyValue keyValueY = new KeyValue(stack.scaleYProperty(), 2);
 
        //create a keyFrame, the keyValue is reached at time 2s
        Duration duration = Duration.millis(2000);
        //one can add a specific action when the keyframe is reached
        EventHandler onFinished = new EventHandler<ActionEvent>() {
            public void handle(ActionEvent t) {
                 stack.setTranslateX(java.lang.Math.random()*200-100);
                 //reset counter
                 i = 0;
            }
        };
 
  KeyFrame keyFrame = new KeyFrame(duration, onFinished , keyValueX, keyValueY);
 
        //add the keyframe to the timeline
        timeline.getKeyFrames().add(keyFrame);
 
        timeline.play();
        timer.start();
    }
        
        
    public static void main(String[] args) {
        Application.launch(args);
    }
  } 
```
#### Interpolators
Interpolation defines positions of the object between the start and end points of the movement. You can use various built-in implementations of the Interpolator class or you can implement your own Interpolator to achieve custom interpolation behavior.

#### Built-in Interpolators
JavaFX provides several built-in interpolators that you can use to create different effects in your animation. By default, JavaFX uses linear interpolation to calculate the coordinates.

Example 3-7 shows a code snippet where the EASE_BOTH interpolator instance is added to the KeyValue in the basic timeline animation. This interpolator creates a spring effect when the object reaches its start point and its end point.

Example 3-7 Built-in Interpolator
```
final Rectangle rectBasicTimeline = new Rectangle(100, 50, 100, 50);
rectBasicTimeline.setFill(Color.BROWN);
...
final Timeline timeline = new Timeline();
timeline.setCycleCount(Timeline.INDEFINITE);
timeline.setAutoReverse(true);
final KeyValue kv = new KeyValue(rectBasicTimeline.xProperty(), 300,
 Interpolator.EASE_BOTH);
final KeyFrame kf = new KeyFrame(Duration.millis(500), kv);
timeline.getKeyFrames().add(kf);
timeline.play();
```
#### Custom Interpolators
Apart from built-in interpolators, you can implement your own interpolator to achieve custom interpolation behavior. A custom interpolator example consists of two java files. Example 3-8 shows a custom interpolator that is used to calculate the y-coordinate for the animation. Example 3-9 shows the code snippet of the animation where the AnimationBooleanInterpolator is used.

Example 3-8 Custom Interpolator
```
public class AnimationBooleanInterpolator extends Interpolator {
    @Override
    protected double curve(double t) {
        return Math.abs(0.5-t)*2 ;
    }
}
```
Example 3-9 Animation with Custom Interpolator
```
final KeyValue keyValue1 = new KeyValue(rect.xProperty(), 300);
 AnimationBooleanInterpolator yInterp = new AnimationBooleanInterpolator();
 final KeyValue keyValue2 = new KeyValue(rect.yProperty(), 0., yInterp);
```










































