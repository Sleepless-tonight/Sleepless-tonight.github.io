# Go入门指南.mk

## 第二部分：语言的核心结构与技术
## 第4章：基本结构和基本数据类型
### 4.1 文件名、关键字与标识符

Go 的源文件以 .go 为后缀名存储在计算机中，这些文件名均由小写字母组成，如 scanner.go 。如果文件名由多个部分组成，则使用下划线 _ 对它们进行分隔，如 scanner_test.go 。文件名不包含空格或其他特殊字符。

一个源文件可以包含任意多行的代码，Go 本身没有对源文件的大小进行限制。

有效的标识符必须以字母（可以使用任何 UTF-8 编码的字符或 _）开头，然后紧跟着 0 个或多个字符或 Unicode 数字

_ 本身就是一个特殊的标识符，被称为空白标识符。它可以像其他标识符那样用于变量的声明或赋值（任何类型都可以赋值给它），但任何赋给这个标识符的值都将被抛弃，因此这些值不能在后续的代码中使用，也不可以使用这个标识符作为变量对其它变量进行赋值或运算。

程序的代码通过语句来实现结构化。每个语句不需要像 C 家族中的其它语言一样以分号 ; 结尾，因为这些工作都将由 Go 编译器自动完成。

如果你打算将多个语句写在同一行，它们则必须使用 ; 人为区分，但在实际开发中我们并不鼓励这种做法。

### 4.2 Go 程序的基本结构和要素
包是结构化代码的一种方式：每个程序都由包（通常简称为 pkg）的概念组成，可以使用自身的包或者从其它包中导入内容。

如同其它一些编程语言中的类库或命名空间的概念，每个 Go 文件都属于且仅属于一个包。一个包可以由许多以 .go 为扩展名的源文件组成，因此文件名和包名一般来说都是不相同的。

你必须在源文件中非注释的第一行指明这个文件属于哪个包，如：package main。package main表示一个可独立执行的程序，每个 Go 应用程序都包含一个名为 main 的包。

一个应用程序可以包含不同的包，而且即使你只使用 main 包也不必把所有的代码都写在一个巨大的文件里：你可以用一些较小的文件，并且在每个文件非注释的第一行都使用 package main 来指明这些文件都属于 main 包。如果你打算编译包名不是为 main 的源文件，如 pack1，编译后产生的对象文件将会是 pack1.a 而不是可执行程序。另外要注意的是，所有的包名都应该使用小写字母。

#### 标准库

在 Go 的安装文件里包含了一些可以直接使用的包，即标准库。在 Windows 下，标准库的位置在 Go 根目录下的子目录 pkg\windows_386 中；在 Linux 下，标准库在 Go 根目录下的子目录 pkg\linux_amd64 中（如果是安装的是 32 位，则在 linux_386 目录中）。一般情况下，标准包会存放在 $GOROOT/pkg/$GOOS_$GOARCH/ 目录下。

Go 的标准库包含了大量的包（如：fmt 和 os），但是你也可以创建自己的包（第 9 章）。

如果想要构建一个程序，则包和包内的文件都必须以正确的顺序进行编译。包的依赖关系决定了其构建顺序。

属于同一个包的源文件必须全部被一起编译，一个包即是编译时的一个单元，因此根据惯例，每个目录都只包含一个包。

**如果对一个包进行更改或重新编译，所有引用了这个包的客户端程序都必须全部重新编译。**

Go 中的包模型采用了显式依赖关系的机制来达到快速编译的目的，编译器会从后缀名为 .o 的对象文件（需要且只需要这个文件）中提取传递依赖类型的信息。

如果 A.go 依赖 B.go，而 B.go 又依赖 C.go：

- 编译 C.go, B.go, 然后是 A.go.
- 为了编译 A.go, 编译器读取的是 B.o 而不是 C.o.

这种机制对于编译大型的项目时可以显著地提升编译速度。

**每一段代码只会被编译一次**

一个 Go 程序是通过 import 关键字将一组包链接在一起。

import "fmt" 告诉 Go 编译器这个程序需要使用 fmt 包（的函数，或其他元素），fmt 包实现了格式化 IO（输入/输出）的函数。包名被封闭在半角双引号 "" 中。如果你打算从已编译的包中导入并加载公开声明的方法，不需要插入已编译包的源代码。

如果需要多个包，它们可以被分别导入：

```
import "fmt"
import "os"
```
或
```
import "fmt"; import "os"
```
但是还有更短且更优雅的方法（被称为因式分解关键字，该方法同样适用于 const、var 和 type 的声明或定义）：
```
import (
   "fmt"
   "os"
)
```
它甚至还可以更短的形式，但使用 gofmt 后将会被强制换行：
```
import ("fmt"; "os")
```
当你导入多个包时，最好按照字母顺序排列包名，这样做更加清晰易读。

- 如果包名以 / 开头（在 Windows 下也可以这样使用），则会在系统的绝对路径中查找。
- 如果包名以 ./ 开头，则 Go 会在相对目录中查找；
- 如果包名不是以 . 或 / 开头，如 "fmt" 或者 "container/list"，则 Go 会在全局文件进行查找；

导入包即等同于包含了这个包的所有的代码对象。

除了符号 _，包中所有代码对象的标识符必须是唯一的，以避免名称冲突。但是相同的标识符可以在不同的包中使用，因为可以使用包名来区分它们。

包通过下面这个被编译器强制执行的规则来决定是否将自身的代码对象暴露给外部文件：

#### 可见性规则
当标识符（包括常量、变量、类型、函数名、结构字段等等）以一个大写字母开头，如：Group1，那么使用这种形式的标识符的对象就可以被外部包的代码所使用（客户端程序需要先导入这个包），这被称为导出（像面向对象语言中的 public）；标识符如果以小写字母开头，则对包外是不可见的，但是他们在整个包的内部是可见并且可用的（像面向对象语言中的 private ）。

（大写字母可以使用任何 Unicode 编码的字符，比如希腊文，不仅仅是 ASCII 码中的大写字母）。

因此，在导入一个外部包后，能够且只能够访问该包中导出的对象。

假设在包 pack1 中我们有一个变量或函数叫做 Thing（以 T 开头，所以它能够被导出），那么在当前包中导入 pack1 包，Thing 就可以像面向对象语言那样使用点标记来调用：pack1.Thing（pack1 在这里是不可以省略的）。

因此包也可以作为命名空间使用，帮助避免命名冲突（名称冲突）：两个包中的同名变量的区别在于他们的包名，例如 pack1.Thing 和 pack2.Thing。

你可以通过使用包的别名来解决包名之间的名称冲突，或者说根据你的个人喜好对包名进行重新设置，如：import fm "fmt"。下面的代码展示了如何使用包的别名：

```
package main

import fm "fmt" // alias3

func main() {
   fm.Println("hello, world")
}
```
> 注意事项
>
>>如果你导入了一个包却没有使用它，则会在构建程序时引发错误，如 imported and not used: os，这正是遵循了 Go 的格言：“没有不必要的代码！“。

#### 包的分级声明和初始化

你可以在使用 import 导入包之后定义或声明 0 个或多个常量（const）、变量（var）和类型（type），这些对象的作用域都是全局的（在本包范围内），所以可以被本包中所有的函数调用（如 gotemplate.go 源文件中的 c 和 v），然后声明一个或多个函数（func）。
```
package main

import (
	"fmt"
)

const c = "C"

var v int = 5

type T struct{}

func init() {
	// initialization of package
}

func main() {
	var a int
	Func1()
	// ...
	fmt.Println(a)
}

func (t T) Method1() {
	//...
}

func Func1() { // exported function Func1
	//...
}
```

#### 4.2.2 函数

这是定义一个函数最简单的格式：
```
func functionName()
```
你可以在括号 () 中写入 0 个或多个函数的参数（使用逗号 , 分隔），每个参数的名称后面必须紧跟着该参数的类型。

main 函数是每一个可执行程序所必须包含的，一般来说都是在启动后第一个执行的函数（如果有 init() 函数则会先执行该函数）。如果你的 main 包的源代码没有包含 main 函数，则会引发构建错误 undefined: main.main。main 函数既没有参数，也没有返回类型（与 C 家族中的其它语言恰好相反）。如果你不小心为 main 函数添加了参数或者返回类型，将会引发构建错误
```
func main must have no arguments and no return values results.
```
在程序开始执行并完成初始化后，第一个调用（程序的入口点）的函数是 main.main()（如：C 语言），该函数一旦返回就表示程序已成功执行并立即退出。

函数里的代码（函数体）使用大括号 {} 括起来。

左大括号 { 必须与方法的声明放在同一行，这是编译器的强制规定，否则你在使用 gofmt 时就会出现错误提示：
```
`build-error: syntax error: unexpected semicolon or newline before {`
```
（这是因为编译器会产生 func main() ; 这样的结果，很明显这错误的）

**Go 语言虽然看起来不使用分号作为语句的结束，但实际上这一过程是由编译器自动完成，因此才会引发像上面这样的错误**

右大括号 } 需要被放在紧接着函数体的下一行。如果你的函数非常简短，你也可以将它们放在同一行：
```
func Sum(a, b int) int { return a + b }
```
对于大括号 {} 的使用规则在任何时候都是相同的（如：if 语句等）。

因此符合规范的函数一般写成如下的形式：
```
func functionName(parameter_list) (return_value_list) {
   …
}
```
其中：
- parameter_list 的形式为 (param1 type1, param2 type2, …)
- return_value_list 的形式为 (ret1 type1, ret2 type2, …)

只有当某个函数需要被外部包调用的时候才使用大写字母开头，并遵循 Pascal 命名法；否则就遵循骆驼命名法，即第一个单词的首字母小写，其余单词的首字母大写。

下面这一行调用了 fmt 包中的 Println 函数，可以将字符串输出到控制台，并在最后自动增加换行字符 \n：
```
fmt.Println（"hello, world"）
```
使用 fmt.Print("hello, world\n") 可以得到相同的结果。

Print 和 Println 这两个函数也支持使用变量，如：fmt.Println(arr)。如果没有特别指定，它们会以默认的打印格式将变量 arr 输出到控制台。

单纯地打印一个字符串或变量甚至可以使用预定义的方法来实现，如：print、println：print("ABC")、println("ABC")、println(i)（带一个变量 i）。

这些函数只可以用于调试阶段，在部署程序的时候务必将它们替换成 fmt 中的相关函数。

当被调用函数的代码执行到结束符 } 或返回语句时就会返回，然后程序继续执行调用该函数之后的代码。

程序正常退出的代码为 0 即 Program exited with code 0；如果程序因为异常而被终止，则会返回非零值，如：1。这个数值可以用来测试是否成功执行一个程序。

#### 4.2.3 注释
示例 4.2 hello_world2.go
```
package main

import "fmt" // Package implementing formatted I/O.

func main() {
   fmt.Printf("Καλημέρα κόσμε; or こんにちは 世界\n")
}
```
上面这个例子通过打印 Καλημέρα κόσμε; or こんにちは 世界 展示了如何在 Go 中使用国际化字符，以及如何使用注释。

注释不会被编译，但可以通过 godoc 来使用（第 3.6 节）。

单行注释是最常见的注释形式，你可以在任何地方使用以 // 开头的单行注释。多行注释也叫块注释，均已以 /* 开头，并以 */ 结尾，且不可以嵌套使用，多行注释一般用于包的文档描述或注释成块的代码片段。

每一个包应该有相关注释，在 package 语句之前的块注释将被默认认为是这个包的文档说明，其中应该提供一些相关信息并对整体功能做简要的介绍。一个包可以分散在多个文件中，但是只需要在其中一个进行注释说明即可。当开发人员需要了解包的一些情况时，自然会用 godoc 来显示包的文档说明，在首行的简要注释之后可以用成段的注释来进行更详细的说明，而不必拥挤在一起。另外，在多段注释之间应以空行分隔加以区分。

示例：
```
// Package superman implements methods for saving the world.
//
// Experience has shown that a small number of procedures can prove
// helpful when attempting to save the world.
package superman
```
几乎所有全局作用域的类型、常量、变量、函数和被导出的对象都应该有一个合理的注释。如果这种注释（称为文档注释）出现在函数前面，例如函数 Abcd，则要以 "Abcd..." 作为开头。

示例：
```
// enterOrbit causes Superman to fly into low Earth orbit, a position
// that presents several possibilities for planet salvation.
func enterOrbit() error {
   ...
}
```

godoc 工具（第 3.6 节）会收集这些注释并产生一个技术文档。

#### 4.2.4 类型
变量（或常量）包含数据，这些数据可以有不同的数据类型，简称类型。使用 var 声明的变量的值会自动初始化为该类型的零值。类型定义了某个变量的值的集合与可对其进行操作的集合。

类型可以是基本类型，如：int、float、bool、string；结构化的（复合的），如：struct、array、slice、map、channel；只描述类型的行为的，如：interface。


### 4.3 常量

### 4.4 变量
### 4.5 基本类型和运算符
### 4.6 字符串
### 4.7 strings 和 strconv 包
### 4.8 时间和日期
### 4.9 指针
