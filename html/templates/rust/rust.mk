# Rust编程语言

1. 标签：Rust、基础、
2. 时间：2020年8月6日6:25:00
3. 连接：http://www.nostyling.cn/html/templates/Thinking-In-Java.mk

## 前言
## 介绍
## 第 1章 入门
### 1.1。安装
### 1.2。你好，世界！
### 1.3。您好，货运！
## 第 2章 编写猜谜游戏
## 第 3章 通用编程概念
### 3.1。变量和可变性
### 3.2。资料类型
### 3.3。功能
### 3.4。注释
### 3.5。控制流
## 第 4章 了解所有权
### 4.1。什么是所有权？
### 4.2。参考和借阅
### 4.3。切片类型
## 第 5章 使用结构来构造相关数据
### 5.1。定义和实例化结构
### 5.2。使用结构的示例程序
### 5.3。方法语法
## 第 6章 枚举和模式匹配
### 6.1。定义枚举
### 6.2。匹配控制流运算符
### 6.3。如果让简洁控制流
## 第 7 章 使用软件包，板条箱和模块管理不断增长的项目
Rust 中有三和重要的组织概念：包、箱、模块。

- Packages: A Cargo feature that lets you build, test, and share crates 包装：货运功能，可让您构建，测试和共享包装箱
- Crates: A tree of modules that produces a library or executable   板条箱：产生库或可执行文件的模块树
- Modules and use: Let you control the organization, scope, and privacy of paths    模块和用途：让您控制路径的组织，范围和隐私
- Paths: A way of naming an item, such as a struct, function, or module 路径：一种命名项目的方法，例如结构，函数或模块

### 7.1。Packages and Crates 包装和板条箱
Cargo 是 Rust 的构建系统和包管理器。它可以帮助开发人员下载和管理依赖项，并帮助创建 Rust 包。在 Rust 社区中，Rust 中的“包”通常被称为“crate”（板条箱），因此在安装 Rust 时会得到 Cargo。

要创建一个新的包，请使用关键字 new，跟上包名称。
```
cargo new my-project
```
>当运行 cargo new 时是在创建一个包

运行 tree 命令以查看目录结构，它会报告已创建了一些文件和目录，首先，它创建一个带有包名称的目录，并且在该目录内有一个存放你的源代码文件的 src 目录，src 目录下会生成一个 main.rs 源文件，Cargo 默认这个文件为二进制箱的根，编译之后的二进制箱将与包名相同：
```
$ tree .
.
└── hello_opensource
    ├── Cargo.toml
    └── src
        └── main.rs

2 directories, 2 files
```
> main.rs 文件经过编译后生产问二进制可执行文件与包名相同

一个软件包包含一个Cargo.toml文件，包必须由一个 Cargo.toml 文件来管理，该文件描述了包的基本信息以及依赖项。

一个包最多包含一个库"箱"，可以包含任意数量的二进制"箱"，但是至少包含一个"箱"（不管是库还是二进制"箱"）。
 
Cargo 的约定是如果在代表表的 Cargo.toml 的同级目录下包含 src 目录且其中包含 main.rs 文件的话，Cargo 就知道这个包带有一个与包同名的二进制 crate，且 src/main.rs 就是 crate 根。另一个约定如果包目录中包含 src/lib.rs，则包带有与其同名的库 crate，且 src/lib.rs 是 crate 根。crate 根文件将由 Cargo 传递给 rustc来实际构建库或者二进制项目。
 
我们有一个仅包含src / main.rs的软件包，这意味着它仅包含一个名为的二进制条板箱my-project。如果软件包包含src / main.rs 和src / lib.rs，则它有两个包装箱：库和二进制文件，两者的名称与软件包相同。通过将文件放在src / bin目录中，一个软件包可以具有多个二进制文件箱：每个文件将是一个单独的二进制文件箱。
 
这是因为 main.rs 和 lib.rs 对于一个 crate 来讲，是两个特殊的文件名。rustc 内置了对这两个特殊文件名的处理（当然也可以通过 Cargo.toml 进行配置，不详谈），我们可以认为它们就是一个 crate 的入口。
 
可执行 crate 和库 crate 是两种不同的 crate。
 
板条箱会将范围内的相关功能组合在一起，因此该功能易于在多个项目之间共享。例如，rand我们在第2章中使用的 板条箱提供了生成随机数的功能。通过将rand板条箱放入我们项目的范围，我们可以在自己的项目中使用该功能。rand板条箱提供的所有功能都可以通过板条箱的名称进行访问rand。
 
Keeping a crate’s functionality in its own scope clarifies whether particular functionality is defined in our crate or the rand crate and prevents potential conflicts. For example, the rand crate provides a trait named Rng. We can also define a struct named Rng in our own crate. Because a crate’s functionality is namespaced in its own scope, when we add rand as a dependency, the compiler isn’t confused about what the name Rng refers to. In our crate, it refers to the struct Rng that we defined. We would access the Rng trait from the rand crate as rand::Rng.    将板条箱的功能保持在其自己的范围内可以澄清是在我们的板条箱中还是在rand板条箱中定义了特定功能，并防止了潜在的冲突。例如，rand 板条箱提供了一个名为的特征 Rng。我们还可以在自己的板条箱中定义一个 struct named Rng。由于包装箱的功能是在其自己的作用域中命名的，因此当我们添加rand为依赖项时，编译器不会对名称Rng所指的内容感到困惑。在我们的箱子中，它指的 struct Rng是我们定义的。我们可以Rng从rand板条箱访问 特质rand::Rng。

> 上面提到了 trait 和 struct ，struct 是 5.1 里面说的 结构。trait：
>一个Trait描述了一种抽象接口（找不到很合适的词），这个抽象接口可以被类型继承。Trait只能由三部分组成（可能只包含部分）：
> - functions（方法）
> - types（类型）
> - constants（常量）

### 7.2。Defining Modules to Control Scope and Privacy 定义模块以控制范围和隐私

### 7.3。引用模块树中项目的路径
### 7.4。使用关键字将路径带入范围
### 7.5。将模块分成不同的文件
## 第 8章 常用收藏
### 8.1。用向量存储值列表
### 8.2。使用字符串存储UTF-8编码文本
### 8.3。在哈希图中存储具有关联值的键
## 第 9章 错误处理
### 9.1。不可挽回的错误与恐慌！
### 9.2。结果可恢复错误
### 9.3。恐慌！还是不要慌！
## 第 10章 通用类型，特征和寿命
### 10.1。通用数据类型
### 10.2。特性：定义共同的行为
### 10.3。使用生命周期验证参考
## 第 11章 编写自动化测试
### 11.1。如何编写测试
### 11.2。控制测试的运行方式
### 11.3。测试组织
## 第 12章  I_O项目：构建命令行程序
### 12.1。接受命令行参数
### 12.2。读取文件
### 12.3。重构以提高模块化和错误处理
### 12.4。通过测试驱动开发来开发库的功能
### 12.5。使用环境变量
### 12.6。将错误消息写入标准错误而不是标准输出
## 第 13章 功能语言功能：迭代器和闭包
### 13.1。闭包：可以捕获其环境的匿名函数
### 13.2。使用迭代器处理一系列项目
### 13.3。改善我们的I_O项目
### 13.4。比较性能：循环与迭代器
## 第 14章 有关Cargo和Crates.io的更多信息
### 14.1。使用发布配置文件自定义构建
### 14.2。将箱子发布到Crates.io
### 14.3。货运工作区
### 14.4。通过商品安装从Crates.io安装二进制文件
### 14.5。使用自定义命令扩展货物
## 第 15章 智能指针
### 15.1。使用盒子 指向堆上的数据
### 15.2。使用Deref特性将智能指针视为常规参考
### 15.3。使用Drop Trait运行清理代码
### 15.4。钢筋混凝土，参考计数智能指针
### 15.5。RefCell 和内部可变性模式
### 15.6。参考周期可能会泄漏内存
## 第 16章 无畏的并发
### 16.1。使用线程同时运行代码
### 16.2。使用消息传递在线程之间传输数据
### 16.3。共享状态并发
### 16.4。具有同步和发送特征的可扩展并发
## 第 17章  Rust的面向对象编程功能
### 17.1。面向对象语言的特征
### 17.2。使用允许不同类型值的特性对象
### 17.3。实施面向对象的设计模式
## 第 18章 模式与匹配
### 18.1。可以使用所有场所模式
### 18.2。可引用性：模式是否可能不匹配
### 18.3。模式语法
## 第 19章 高级功能
### 19.1。不安全的锈
### 19.2。高级特质
### 19.3。高级类型
### 19.4。高级功能和闭包
### 19.5。巨集
## 第 20章 最终项目：构建多线程Web服务器
### 20.1。构建单线程Web服务器
### 20.2。将我们的单线程服务器转变为多线程服务器
### 20.3。正常关机和清理
## 第 21章 附录
### 21.1。A-关键字
### 21.2。B-运算符和符号
### 21.3。C-可衍生特征
### 21.4。D-有用的开发工具
### 21.5。电子版
### 21.6。F-这本书的翻译
### 21.7。G-如何制造锈蚀和“夜锈”




