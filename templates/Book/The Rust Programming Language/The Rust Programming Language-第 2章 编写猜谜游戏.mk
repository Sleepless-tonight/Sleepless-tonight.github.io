## 第 2章 编写猜谜游戏

```
use std::io;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin()
        .read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

让我们逐行进行介绍。为了获得用户输入，然后将结果打印为输出，我们需要将 io(input/output)库纳入范围。该io库来自标准库（称为std）：
```
use std::io;
```
> Rust 的标准库，有一个 prelude 子模块，这里面包含了默认导入（std 库是默认导入的，然后 std 库中的 prelude 下面的东西也是默认导入的）的所有符号。

use 关键字
use 关键字能够将模块标识符引入当前作用域,这样就解决了局部模块路径过长的问题。
所有的系统库模块都是被默认导入的，所以在使用的时候只需要使用 use 关键字简化路径就可以方便的使用了。
当然，有些情况下存在两个相同的名称，且同样需要导入，我们可以使用 as 关键字为标识符添加别名