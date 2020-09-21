## 第 1章 入门
### 1.1。安装
> 单独有写一篇如何安装
>
>
#### 更新和卸载
通过安装Rust后rustup，轻松更新到最新版本。在您的外壳中，运行以下更新脚本：
```
$ rustup update
```
要卸载Rust和rustup，请从您的外壳运行以下卸载脚本：
```
$ rustup self uninstall
```
#### 本地文件
运行rustup doc以在浏览器中打开本地文档。

### 1.2。你好，世界！
```
fn main() {
    println!("Hello, world!");
}
```
#### 编译和运行
```
>$ rustc main.rs
>.\main.exe
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

请在终端中输入以下内容，检查是否已安装Cargo：
```
$ cargo --version
```

#### 用 Cargo 创建项目

```
$ cargo new hello_cargo
$ cd hello_cargo
```
第一个命令创建一个名为hello_cargo的新目录。我们已将项目命名为hello_cargo，并且Cargo在同名目录中创建其文件。

进入hello_cargo目录并列出文件。您会看到Cargo为我们生成了两个文件和一个目录：一个Cargo.toml文件和一个其中带有main.rs文件的 src目录。











