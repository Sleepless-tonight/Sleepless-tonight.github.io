# Window10下 搭建 Rust 环境
首先要说明的是，本文是介绍 windows + MSYS2 + Rust ，非 MSVC。

Windows作业系统中的Rust程式，预设会使用MSVC来编译的。但是如果Rust程式有使用到GNU相关的函式库(例如GTK)时，就得搭配MinGW来编译了。MSYS2 是一套整合MinGW和POSIX环境的工具，可以在Windows作业系统上模拟出Linux作业系统的开发环境，且能利用MinGW直接编译出在Windows作业系统上执行的程式。

## 1、安装和设定 MSYS2
已经有其他博文做过介绍，参考即可

## 2、安在Windows作业系统安装Rust开发环境
现在官方推荐使用 rustup 来安装 Rust 环境。

首先在MSYS2的终端机上执行以下指令：
```
curl https://sh.rustup.rs -sSf | sh
```
注意，在 Windows 上面，Rust 编译需要 Visual C++ Build Tools。请先安装这个之后再安装 rustup。

安装程式可能会提示说需要微软的Visual C++ Build Tools。不要理它，输入「y」继续。

选择第二个选项，自定义Rust要如何安装

host triple的部份，输入「x86_64-pc-windows-gnu」，也就是我们的Rust编译器预设使用的目标(target)名称。

接着输入Rust的版本，建议使用「stable」，如果有nightly需求的话就用「nightly」吧！

接着设定是否要修改「PATH」环境变数，输入「y」。

然后回到选单，选择第一项，开始用我们刚才的设定来安装Rust。

### 更新与卸载
更新所有 Rust，运行：
```
 rustup update
```
校验Rust编译环境
```
rustc --version
cargo --version
```
检查 rustup 自身是否有更新：
```
 rustup self update
```
卸载 rustup：
```
rustup self uninstall
```



