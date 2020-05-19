# JavaFX: Transformations, Animations, and Visual Effects
JavaFX：转换，动画和视觉效果

### 1、转换概述
所有转换都位于javafx.scene.transform 包中，并且是Transform该类的子类。

#### Introducing Transformations 转型介绍
转换会根据某些参数更改图形对象在坐标系中的位置。JavaFX支持以下类型的转换：
- Translation 翻译
- Rotation 回转
- Scaling 缩放比例
- Shearing 剪力

These transformations can be applied to either a standalone node or to groups of nodes. You can apply one transformation at a time or you can combine transformations and apply several transformations to one node.
这些转换可以应用于独立节点或节点组。您可以一次应用一个转换，也可以组合转换并将多个转换应用于一个节点。

The Transform class implements the concepts of affine transformations. The Affine class extends the Transform class and acts as a superclass to all transformations. Affine transformations are based on euclidean algebra, and perform a linear mapping (through the use of matrixes) from initial coordinates to other coordinates while preserving the straightness and parallelism of lines. Affine transformations can be constructed using observableArrayLists rotations, translations, scales, and shears. 在Transform类实现仿射变换的概念。本Affine类扩展Transform类，并作为一个超类中的所有转换。仿射变换基于欧几里德代数，并执行线性映射（通过使用矩阵），从初始坐标到其他坐标，同时保留直线的直线性和平行性。可以使用observableArrayLists旋转，平移，缩放和剪切来构造仿射变换。

> Note: 注意：
> > Usually, do not use the Affine class directly, but instead, use the specific Translate, Scale, Rotate, or Shear transformations. 通常，不要Affine直接使用该类，而应使用特定的“平移”，“缩放”，“旋转”或“剪切”转换。

Transformations in JavaFX can be performed along three coordinates, thus enabling users to create three-dimensional (3-D) objects and effects. To manage the display of objects with depth in 3-D graphics, JavaFX implements z-buffering. Z-buffering ensures that the perspective is the same in the virtual world as it is in the real one: a solid object in the foreground blocks the view of one behind it. Z-buffering can be enabled by using the setDepthTest class. You can try to disable z-buffering (setDepthTest(DepthTest.DISABLE)) in the sample application to see the effect of the z-buffer.

To simplify transformation usage, JavaFX implements transformation constructors with the x-axis and y-axis along with the x, y, and z axes. If you want to create a two-dimensional (2-D) effect, you can specify only the x and y coordinates. If you want to create a 3-D effect, specify all three coordinates. JavaFX中的转换可以沿三个坐标执行，从而使用户能够创建三维（3-D）对象和效果。为了管理3D图形中具有深度的对象的显示，JavaFX实现了z缓冲。Z缓冲可确保虚拟世界中的透视图与真实世界中的透视图相同：前景中的实体对象会阻止其后方的视图。可以通过使用setDepthTest类来启用Z缓冲。您可以尝试setDepthTest(DepthTest.DISABLE在示例应用程序中禁用z缓冲（），以查看z缓冲的效果。

To be able to see 3-D objects and transformation effects in JavaFX, users must enable the perspective camera. 为了能够在JavaFX中查看3-D对象和转换效果，用户必须启用透视相机。

Though knowing the underlying concepts can help you use JavaFX more effectively, you can start using transformations by studying the example provided with this document and trying different transformation parameters. For more information about particular classes, methods, or additional features, see the API documentation. 尽管了解基本概念可以帮助您更有效地使用JavaFX，但是可以通过研究本文档提供的示例并尝试不同的转换参数来开始使用转换。有关特定类，方法或其他功能的更多信息，请参阅API文档。

In this document, a Xylophone application is used as a sample to illustrate all the available transformations. You can download its source code by clicking the transformations.zip link. 在本文档中，木琴应用程序用作示例来说明所有可用的转换。您可以通过单击transformations.zip链接下载其源代码。

### 2、Transformation Types and Examples 转换类型和示例
This document describes specific transformations and provides code examples.

#### Translation 平移
The translation transformation shifts a node from one place to another along one of the axes relative to its initial position. The initial position of the xylophone bar is defined by x, y, and z coordinates. In Example 2-1, the initial position values are specified by the xStart, yPos, and zPos variables. Some other variables are added to simplify the calculations when applying different transformations. Each bar of the xylophone is based on one of the base bars. The example then translates the base bars with different shifts along the three axes to correctly locate them in space.

Example 2-1 shows a code snippet from the sample application with the translation transformation.

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
#### Rotation 平移
The rotation transformation moves the node around a specified pivot point of the scene. You can use the rotate method of the Transform class to perform the rotation.

To rotate the camera around the xylophone in the sample application, the rotation transformation is used, although technically, it is the xylophone itself that is moving when the mouse rotates the camera.

Example 2-2 shows the code for the rotation transformation.

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
Note that the pivot point and the angle define the destination point the image is moved to. Carefully calculate values when specifying the pivot point. Otherwise, the image might appear where it is not intended to be. For more information, see the API documentation

#### Scaling 平移

The scaling transformation causes a node to either appear larger or smaller, depending on the scaling factor. Scaling changes the node so that the dimensions along its axes are multiplied by the scale factor. Similar to the rotation transformations, scaling transformations are applied at a pivot point. This pivot point is considered the point around which scaling occurs.

To scale, use the Scale class and the scale method of the Transform class.

In the Xylophone application, you can scale the xylophone using the mouse while pressing Alt and the right mouse button. The scale transformation is used to see the scaling.

Example 2-3 shows the code for the scale transformation.

```
else if (me.isAltDown() && me.isSecondaryButtonDown()) {
          double scale = cam.s.getX();
          double newScale = scale + mouseDeltaX*0.01;
          cam.s.setX(newScale); cam.s.setY(newScale); cam.s.setZ(newScale);
                }
...
```

#### Shearing 平移
A shearing transformation rotates one axis so that the x-axis and y-axis are no longer perpendicular. The coordinates of the node are shifted by the specified multipliers.

To shear, use the Shear class or the shear method of the Transform class.

In the Xylophone application, you can shear the xylophone by dragging the mouse while holding Shift and pressing the left mouse button.

Example 2-4 shows the code snippet for the shear transformation.

```
else if (me.isShiftDown() && me.isPrimaryButtonDown()) {
    double yShear = shear.getY();
    shear.setY(yShear + mouseDeltaY/1000.0);
    double xShear = shear.getX();
    shear.setX(xShear + mouseDeltaX/1000.0);
}
```
#### Multiple Transformations
You can construct multiple transformations by specifying an ordered chain of transformations. For example, you can scale an object and then apply a shearing transformation to it, or you can translate an object and then scale it.

Example 2-5 shows multiple transformations applied to an object to create a xylophone bar.

Example 2-5 Multiple Transformations

```
Cube base1Cube = new Cube(1.0, new Color(0.2, 0.12, 0.1, 1.0), 1.0);
        base1Cube.setTranslateX(xStart + 135);
        base1Cube.setTranslateZ(yPos+20.0);
        base1Cube.setTranslateY(11.0);
        base1Cube.setScaleX(barWidth*11.5);
        base1Cube.setScaleZ(10.0);
        base1Cube.setScaleY(barDepth*2.0);
```
























































































