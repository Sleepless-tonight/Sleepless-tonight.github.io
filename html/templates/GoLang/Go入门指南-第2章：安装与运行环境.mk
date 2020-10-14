# Go入门指南.mk


## 第2章：安装与运行环境
2.1 平台与架构
2.2 Go 环境变量
2.3 在 Linux 上安装 Go
2.4 在 Mac OS X 上安装 Go
2.5 在 Windows 上安装 Go

### 2.6 安装目录清单
你的 Go 安装目录（$GOROOT）的文件夹结构应该如下所示：

README.md, AUTHORS, CONTRIBUTORS, LICENSE

- /bin：包含可执行文件，如：编译器，Go 工具
- /doc：包含示例程序，代码工具，本地文档等
- /lib：包含文档模版
- /misc：包含与支持 Go 编辑器有关的配置文件以及 cgo 的示例
- /os_arch：包含标准库的包的对象文件（.a）
- /src：包含源代码构建脚本和标准库的包的完整源代码（Go 是一门开源语言）
- /src/cmd：包含 Go 和 C 的编译器和命令行脚本

### 2.7 Go 运行时（runtime）

尽管 Go 编译器产生的是本地可执行代码，这些代码仍旧运行在 Go 的 runtime（这部分的代码可以在 runtime 包中找到）当中。这个 runtime 类似 Java 和 .NET 语言所用到的虚拟机，它负责管理包括内存分配、垃圾回收（第 10.8 节）、栈处理、goroutine、channel、切片（slice）、map 和反射（reflection）等等。

runtime 主要由 C 语言编写（Go 1.5 开始自举），并且是每个 Go 包的最顶级包。你可以在目录 $GOROOT/src/runtime 中找到相关内容。

垃圾回收器 Go 拥有简单却高效的标记-清除回收器。它的主要思想来源于 IBM 的可复用垃圾回收器，旨在打造一个高效、低延迟的并发回收器。目前 gccgo 还没有回收器，同时适用 gc 和 gccgo 的新回收器正在研发中。使用一门具有垃圾回收功能的编程语言不代表你可以避免内存分配所带来的问题，分配和回收内容都是消耗 CPU 资源的一种行为。

Go 的可执行文件都比相对应的源代码文件要大很多，这恰恰说明了 Go 的 runtime 嵌入到了每一个可执行文件当中。当然，在部署到数量巨大的集群时，较大的文件体积也是比较头疼的问题。但总的来说，Go 的部署工作还是要比 Java 和 Python 轻松得多。因为 Go 不需要依赖任何其它文件，它只需要一个单独的静态文件，这样你也不会像使用其它语言一样在各种不同版本的依赖文件之间混淆。

### 2.8 Go 解释器

因为 Go 具有像动态语言那样快速编译的能力，自然而然地就有人会问 Go 语言能否在 REPL（read-eval-print loop）编程环境下实现。Sebastien Binet 已经使用这种环境实现了一个 Go 解释器，你可以在这个页面找到：https://github.com/sbinet/igo。