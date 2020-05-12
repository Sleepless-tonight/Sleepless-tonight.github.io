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