## 第 1章 入门
### 1.1。安装
> 单独有写一篇如何安装
### 1.2。你好，世界！
```
fn main() {
    println!("Hello, world!");
}
```
#### Rust程序剖析

1. 第一行声明一个名为的函数main，该函数不带参数且不返回任何内容。如果有参数，它们将放在括号内()。该main功能很特殊：它始终是每个可执行Rust程序中运行的第一个代码。
2. 函数主体用大括号括起来{}。
3. println!调用Rust宏。如果改为调用函数，则将其输入为println（不带!）。
4. 我们用分号（;）结束该行，这表明该表达式已结束，下一个表达式可以开始了。Rust代码的大多数行以分号结尾。
### 1.3。Hello, Cargo!   您好，货运！

Cargo是Rust的构建系统和包管理器。大多数Rustacean使用此工具来管理他们的Rust项目，因为Cargo会为您处理很多任务，例如:

1. 构建代码，
2. 下载代码所依赖的库以及构建这些库。（我们称库为您的代码需要依赖项。）

#### 用 Cargo 创建项目













