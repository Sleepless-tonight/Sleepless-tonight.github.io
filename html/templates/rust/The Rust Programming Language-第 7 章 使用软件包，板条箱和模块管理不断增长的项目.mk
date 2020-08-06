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
>对于一个软件工程来说，我们往往按照所使用的编程语言的组织规范来进行组织，组织模块的主要结构往往是树。Java 组织功能模块的主要单位是类，而 JavaScript 组织模块的主要方式是 function。
>
>这些先进的语言的组织单位可以层层包含，就像文件系统的目录结构一样。Rust 中的组织单位是模块（Module）。
>
>访问权限：
>
>Rust 中有两种简单的访问权：公共（public）和私有（private）。
>
>默认情况下，如果不加修饰符，模块中的成员访问权将是私有的。
> 
>如果想使用公共权限，需要使用 pub 关键字。
>
>对于私有的模块，只有在与其平级的位置或下级的位置才能访问，不能从其外部访问。
>
>如果模块中定义了结构体，结构体除了其本身是私有的以外，其字段也默认是私有的。所以如果想使用模块中的结构体以及其字段，需要 pub 声明。
>
>如果我们将一个枚举公开，则其所有变体都将公开。


In this section, we’ll talk about modules and other parts of the module system, namely paths that allow you to name items; the use keyword that brings a path into scope; and the pub keyword to make items public. We’ll also discuss the as keyword, external packages, and the glob operator. For now, let’s focus on modules!   在本节中，我们将讨论模块和模块系统的其他部分，即允许您命名项目的路径。use将路径带入范围的关键字；以及将pub项目设为公开的关键字。我们还将讨论as关键字，外部包和glob运算符。现在，让我们专注于模块！

Modules let us organize code within a crate into groups for readability and easy reuse. Modules also control the privacy of items, which is whether an item can be used by outside code (public) or is an internal implementation detail and not available for outside use (private).   模块使我们可以将板条箱中的代码分为几组，以提高可读性和重用性。模块还控制项目的隐私，即项目是可以由外部代码使用（公共）还是内部实现细节而不能用于外部使用（私有）。


As an example, let’s write a library crate that provides the functionality of a restaurant. We’ll define the signatures of functions but leave their bodies empty to concentrate on the organization of the code, rather than actually implement a restaurant in code.  例如，让我们写一个提供餐厅功能的库箱。我们将定义函数的签名，但将它们的主体留空以专注于代码的组织，而不是实际在代码中实现餐厅。

In the restaurant industry, some parts of a restaurant are referred to as front of house and others as back of house. Front of house is where customers are; this is where hosts seat customers, servers take orders and payment, and bartenders make drinks. Back of house is where the chefs and cooks work in the kitchen, dishwashers clean up, and managers do administrative work.    在餐饮业中，餐厅的某些部分称为 房屋前部，而其他部分称为房屋后部。屋前就是顾客的所在。主机在这里招待客户，服务器在接受订单和付款，调酒师在这里喝酒。屋后是厨师在厨房工作，洗碗碟机，经理进行行政工作的地方。

To structure our crate in the same way that a real restaurant works, we can organize the functions into nested modules. Create a new library named restaurant by running cargo new --lib restaurant; then put the code in Listing 7-1 into src/lib.rs to define some modules and function signatures.   为了以与实际餐厅相同的方式构造板条箱，我们可以将功能组织到嵌套模块中。restaurant通过运行创建一个新的库 cargo new --lib restaurant；然后将清单7-1中的代码放入src / lib.rs中，以定义一些模块和函数签名。

Filename: src/lib.rs
```
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```
我们以mod关键字开头定义模块，然后指定模块名称（在本例中为front_of_house），并将大括号放在模块主体周围。在模块内部，我们可以有其他模块，在这种情况下，可以使用hosting和serving。模块还可以保存其他项的定义，例如结构，枚举，常量，特征或功能（如清单7-1所示）。

通过使用模块，我们可以将相关的定义分组在一起，并命名它们为什么相关。使用此代码的程序员可以更轻松地找到他们想要使用的定义，因为他们可以基于组导航代码，而不必阅读所有定义。向此代码添加新功能的程序员将知道将代码放置在何处以保持程序的组织性。

Earlier, we mentioned that src/main.rs and src/lib.rs are called crate roots. The reason for their name is that the contents of either of these two files form a module named crate at the root of the crate’s module structure, known as the module tree. 在前面，我们提到src / main.rs和src / lib.rs称为板条箱根。之所以要使用它们，是因为这两个文件中的任何一个的内容都构成了一个模块crate，该模块在板条箱的模块结构的根目录下被命名为模块树。

清单7-2显示了清单7-1中的结构的模块树。

```
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

This tree shows how some of the modules nest inside one another (for example, hosting nests inside front_of_house). The tree also shows that some modules are siblings to each other, meaning they’re defined in the same module (hosting and serving are defined within front_of_house). To continue the family metaphor, if module A is contained inside module B, we say that module A is the child of module B and that module B is the parent of module A. Notice that the entire module tree is rooted under the implicit module named crate. 这个树显示了一些模块是如何相互嵌套的(例如，在front_of_house中托管嵌套)。该树还表明，有些模块是彼此的兄弟模块，这意味着它们定义在同一个模块中(托管和服务是在front_of_house中定义的)。继续使用“家族”这个比喻，如果模块A包含在模块B中，我们就说模块A是模块B的子模块，模块B是模块A的父模块。请注意，整个模块树的根位于名为crate的隐含模块下。

The module tree might remind you of the filesystem’s directory tree on your computer; this is a very apt comparison! Just like directories in a filesystem, you use modules to organize your code. And just like files in a directory, we need a way to find our modules.   模块树可能使您想起计算机上文件系统的目录树。这是一个非常恰当的比较！就像文件系统中的目录一样，您可以使用模块来组织代码。就像目录中的文件一样，我们需要一种找到模块的方法。
### 7.3。Paths for Referring to an Item in the Module Tree   引用模块树中项目的路径

To show Rust where to find an item in a module tree, we use a path in the same way we use a path when navigating a filesystem. If we want to call a function, we need to know its path. 为了向Rust展示在模块树中找到项目的位置，我们使用的路径与浏览文件系统时使用的路径相同。如果要调用函数，则需要知道其路径。

A path can take two forms:  路径可以采用两种形式：

- An absolute path starts from a crate root by using a crate name or a literal crate.   一个绝对路径从crate 关键字开始描述。
- A relative path starts from the current module and uses self, super, or an identifier in the current module.  相对路径从 self 或 super 关键字或一个在当前模块中的一个标识符开始描述。

Both absolute and relative paths are followed by one or more identifiers separated by double colons (::).   绝对路径和相对路径后均跟随一个或多个标识符，并用双冒号（::）隔开。

Let’s return to the example in Listing 7-1. How do we call the add_to_waitlist function? This is the same as asking, what’s the path of the add_to_waitlist function? In Listing 7-3, we simplified our code a bit by removing some of the modules and functions. We’ll show two ways to call the add_to_waitlist function from a new function eat_at_restaurant defined in the crate root. The eat_at_restaurant function is part of our library crate’s public API, so we mark it with the pub keyword. In the ”Exposing Paths with the pub Keyword” section, we’ll go into more detail about pub. Note that this example won’t compile just yet; we’ll explain why in a bit. 让我们回到清单7-1中的示例。我们如何调用该 add_to_waitlist函数？这和询问add_to_waitlist函数的路径是什么一样 ？在清单7-3中，我们通过删除一些模块和函数来简化了代码。我们将展示两种add_to_waitlist从eat_at_restaurant板条箱根中定义的新函数调用函数的方法 。该eat_at_restaurant函数是我们的库箱公共API的一部分，因此我们将其标记为pub关键字。在“使用pub关键字公开路径”部分中，我们将详细介绍pub。请注意，该示例尚未编译。我们稍后会解释原因。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path    绝对路径
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path    相对路径
    front_of_house::hosting::add_to_waitlist();
}
```
清单7-3：add_to_waitlist使用绝对路径和相对路径调用函数

The first time we call the add_to_waitlist function in eat_at_restaurant, we use an absolute path. The add_to_waitlist function is defined in the same crate as eat_at_restaurant, which means we can use the crate keyword to start an absolute path.  第一次在中调用add_to_waitlist函数时eat_at_restaurant，我们使用绝对路径。该add_to_waitlist函数与定义在同一板条箱中eat_at_restaurant，这意味着我们可以使用crate关键字来启动绝对路径。

After crate, we include each of the successive modules until we make our way to add_to_waitlist. You can imagine a filesystem with the same structure, and we’d specify the path /front_of_house/hosting/add_to_waitlist to run the add_to_waitlist program; using the crate name to start from the crate root is like using / to start from the filesystem root in your shell. 之后 crate，我们将包括每个后续模块，直到我们逐步实现add_to_waitlist。您可以想象一个具有相同结构的文件系统，我们将指定/front_of_house/hosting/add_to_waitlist运行 add_to_waitlist程序的路径。使用crate名称从板条箱根/启动就像使用从外壳中的文件系统根启动一样。

The second time we call add_to_waitlist in eat_at_restaurant, we use a relative path. The path starts with front_of_house, the name of the module defined at the same level of the module tree as eat_at_restaurant. Here the filesystem equivalent would be using the path front_of_house/hosting/add_to_waitlist. Starting with a name means that the path is relative.   第二次调用add_to_waitlist时eat_at_restaurant，我们使用相对路径。路径以开头front_of_house，在与模块树相同级别定义的模块名称eat_at_restaurant。这里等效的文件系统将使用path front_of_house/hosting/add_to_waitlist。以名称开头表示路径是相对的。

Choosing whether to use a relative or absolute path is a decision you’ll make based on your project. The decision should depend on whether you’re more likely to move item definition code separately from or together with the code that uses the item. For example, if we move the front_of_house module and the eat_at_restaurant function into a module named customer_experience, we’d need to update the absolute path to add_to_waitlist, but the relative path would still be valid. However, if we moved the eat_at_restaurant function separately into a module named dining, the absolute path to the add_to_waitlist call would stay the same, but the relative path would need to be updated. Our preference is to specify absolute paths because it’s more likely to move code definitions and item calls independently of each other.    选择使用相对还是绝对路径是您根据项目决定的。该决定应取决于您是更可能将物料定义代码与使用物料的代码分开移动还是一起使用。例如，如果将front_of_house模块和 eat_at_restaurant函数移动到名为的模块中customer_experience，则需要将绝对路径更新为add_to_waitlist，但是相对路径仍然有效。但是，如果我们将eat_at_restaurant函数单独移动到名为的模块中dining，则add_to_waitlist调用的绝对路径 将保持不变，但是相对路径将需要更新。我们倾向于指定绝对路径，因为它更有可能彼此独立地移动代码定义和项目调用。

让我们尝试编译清单7-3，找出为什么它还不能编译！清单7-4显示了我们得到的错误。

```
$ cargo build
   Compiling restaurant v0.1.0 (file:///projects/restaurant)
error[E0603]: module `hosting` is private
 --> src/lib.rs:9:28
  |
9 |     crate::front_of_house::hosting::add_to_waitlist();
  |                            ^^^^^^^

error[E0603]: module `hosting` is private
  --> src/lib.rs:12:21
   |
12 |     front_of_house::hosting::add_to_waitlist();
   |                     ^^^^^^^

error: aborting due to 2 previous errors

For more information about this error, try `rustc --explain E0603`.
error: could not compile `restaurant`.

To learn more, run the command again with --verbose.
```
清单7-4：编译清单7-3中的代码产生的编译器错误

The error messages say that module hosting is private. In other words, we have the correct paths for the hosting module and the add_to_waitlist function, but Rust won’t let us use them because it doesn’t have access to the private sections.    错误消息表明该模块hosting是私有的。换句话说，我们具有hosting模块和add_to_waitlist 功能的正确路径，但是Rust不允许我们使用它们，因为它无法访问私有部分。

Modules aren’t useful only for organizing your code. They also define Rust’s privacy boundary: the line that encapsulates the implementation details external code isn’t allowed to know about, call, or rely on. So, if you want to make an item like a function or struct private, you put it in a module.    模块不仅仅对组织代码有用。他们还定义了Rust的 隐私边界：封装实现细节的行不允许外部代码知道，调用或依赖。因此，如果要将项目设为函数或结构私有，则将其放在模块中。

The way privacy works in Rust is that all items (functions, methods, structs, enums, modules, and constants) are private by default. Items in a parent module can’t use the private items inside child modules, but items in child modules can use the items in their ancestor modules. The reason is that child modules wrap and hide their implementation details, but the child modules can see the context in which they’re defined. To continue with the restaurant metaphor, think of the privacy rules as being like the back office of a restaurant: what goes on in there is private to restaurant customers, but office managers can see and do everything in the restaurant in which they operate.   Rust中隐私的工作方式是默认情况下所有项目（函数，方法，结构，枚举，模块和常量）都是私有的。父模块中的项目不能使用子模块中的私有项目，但是子模块中的项目可以使用其祖先模块中的项目。原因是子模块包装并隐藏了它们的实现细节，但是子模块可以看到定义它们的上下文。要继续使用餐厅的隐喻，可以将隐私规则视为餐厅的后台办公室：餐厅客户的隐私是私人的，但办公室经理可以查看并在其经营的餐厅中做任何事情。

Rust chose to have the module system function this way so that hiding inner implementation details is the default. That way, you know which parts of the inner code you can change without breaking outer code. But you can expose inner parts of child modules' code to outer ancestor modules by using the pub keyword to make an item public.   Rust选择以这种方式使模块系统起作用，以便默认隐藏内部实现细节。这样，您就知道可以更改内部代码的哪些部分而不会破坏外部代码。但是，您可以通过使用pub 关键字将项目公开，从而将子模块代码的内部部分公开给外部祖先模块。

#### Exposing Paths with the pub Keyword 使用pub关键字公开路径
Let’s return to the error in Listing 7-4 that told us the hosting module is private. We want the eat_at_restaurant function in the parent module to have access to the add_to_waitlist function in the child module, so we mark the hosting module with the pub keyword, as shown in Listing 7-5.   让我们回到清单7-4中的错误，告诉我们该hosting模块是私有的。我们希望eat_at_restaurant父模块中的add_to_waitlist功能可以访问子模块中的功能，因此我们hosting用pub关键字标记 模块，如清单7-5所示。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```
清单7-5：从以下位置声明要使用的hosting模块pubeat_at_restaurant

不幸的是，清单7-5中的代码仍然导致错误，如清单7-6所示。
```
$ cargo build
   Compiling restaurant v0.1.0 (file:///projects/restaurant)
error[E0603]: function `add_to_waitlist` is private
 --> src/lib.rs:9:37
  |
9 |     crate::front_of_house::hosting::add_to_waitlist();
  |                                     ^^^^^^^^^^^^^^^

error[E0603]: function `add_to_waitlist` is private
  --> src/lib.rs:12:30
   |
12 |     front_of_house::hosting::add_to_waitlist();
   |                              ^^^^^^^^^^^^^^^

error: aborting due to 2 previous errors

For more information about this error, try `rustc --explain E0603`.
error: could not compile `restaurant`.

To learn more, run the command again with --verbose.
```
Listing 7-6: Compiler errors from building the code in Listing 7-5  清单7-6：构建清单7-5中的代码产生的编译器错误

What happened? Adding the pub keyword in front of mod hosting makes the module public. With this change, if we can access front_of_house, we can access hosting. But the contents of hosting are still private; making the module public doesn’t make its contents public. The pub keyword on a module only lets code in its ancestor modules refer to it.  发生了什么？在pub关键字前面添加关键字mod hosting可使模块成为公共模块。进行此更改后，如果可以访问front_of_house，就可以访问hosting。但是，内容的hosting仍然是私有的; 公开该模块不会公开其内容。pub模块上的关键字仅允许其祖先模块中的代码引用它。

The errors in Listing 7-6 say that the add_to_waitlist function is private. The privacy rules apply to structs, enums, functions, and methods as well as modules.   清单7-6中的错误表明该add_to_waitlist函数是私有的。隐私规则适用于结构，枚举，函数，方法以及模块。

Let’s also make the add_to_waitlist function public by adding the pub keyword before its definition, as in Listing 7-7. 我们还add_to_waitlist通过在pub 关键字的定义之前添加关键字来使该函数公开，如清单7-7所示。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```
Listing 7-7: Adding the pub keyword to mod hosting and fn add_to_waitlist lets us call the function from eat_at_restaurant  清单7-7：向 和添加pub关键字mod hosting，fn add_to_waitlist让我们从中调用函数 eat_at_restaurant

Now the code will compile! Let’s look at the absolute and the relative path and double-check why adding the pub keyword lets us use these paths in add_to_waitlist with respect to the privacy rules.   现在代码将编译！让我们看一下绝对路径和相对路径，并仔细检查为什么添加pub关键字可以使我们add_to_waitlist根据隐私规则使用这些路径 。

In the absolute path, we start with crate, the root of our crate’s module tree. Then the front_of_house module is defined in the crate root. The front_of_house module isn’t public, but because the eat_at_restaurant function is defined in the same module as front_of_house (that is, eat_at_restaurant and front_of_house are siblings), we can refer to front_of_house from eat_at_restaurant. Next is the hosting module marked with pub. We can access the parent module of hosting, so we can access hosting. Finally, the add_to_waitlist function is marked with pub and we can access its parent module, so this function call works!   在绝对路径中，我们从crate周转箱模块树的根开始。然后front_of_house在板条箱根中定义模块。该 front_of_house模块是不公开的，但由于eat_at_restaurant 功能是一样的模块定义front_of_house（即， eat_at_restaurant和front_of_house是兄弟），我们可以参照 front_of_house从eat_at_restaurant。接下来是hosting标有的模块pub。我们可以访问的父模块hosting，因此我们可以访问 hosting。最后，该add_to_waitlist函数标有pub，我们可以访问其父模块，因此此函数调用有效！

In the relative path, the logic is the same as the absolute path except for the first step: rather than starting from the crate root, the path starts from front_of_house. The front_of_house module is defined within the same module as eat_at_restaurant, so the relative path starting from the module in which eat_at_restaurant is defined works. Then, because hosting and add_to_waitlist are marked with pub, the rest of the path works, and this function call is valid! 在相对路径中，逻辑与绝对路径相同（除了第一步）：路径不是从板条箱根开始，而是从 front_of_house。该front_of_house模块与定义在同一模块内eat_at_restaurant，因此从eat_at_restaurant定义该模块的模块开始的相对路径 有效。然后，由于hosting和 add_to_waitlist标记为pub，因此其余路径起作用，并且此函数调用有效！

#### Starting Relative Paths with super 起始相对路径 super
We can also construct relative paths that begin in the parent module by using super at the start of the path. This is like starting a filesystem path with the .. syntax. Why would we want to do this? 我们还可以通过super在路径的开头使用来构造从父模块 开始的相对路径。这就像使用..语法来启动文件系统路径。我们为什么要这样做？

Consider the code in Listing 7-8 that models the situation in which a chef fixes an incorrect order and personally brings it out to the customer. The function fix_incorrect_order calls the function serve_order by specifying the path to serve_order starting with super:    考虑清单7-8中的代码，该代码对厨师修复错误订单并将其亲自带给客户的情况进行建模。该函数通过指定以以下内容开头的路径来fix_incorrect_order调用该函数：serve_orderserve_ordersuper

Filename: src/lib.rs    文件名：src / lib.rs
```
fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}
```
Listing 7-8: Calling a function using a relative path starting with super   清单7-8：使用从以下开始的相对路径调用函数 super

The fix_incorrect_order function is in the back_of_house module, so we can use super to go to the parent module of back_of_house, which in this case is crate, the root. From there, we look for serve_order and find it. Success! We think the back_of_house module and the serve_order function are likely to stay in the same relationship to each other and get moved together should we decide to reorganize the crate’s module tree. Therefore, we used super so we’ll have fewer places to update code in the future if this code gets moved to a different module.  该fix_incorrect_order功能位于back_of_house模块中，因此我们可以使用super转到的父模块back_of_house，在本例中为crate根。从那里，我们寻找serve_order并找到它。成功！我们认为，如果我们决定重组包装箱的模块树，则back_of_house模块和serve_order功能之间可能会保持相同的关系并在一起移动。因此，我们曾经使用过super这样的方法， 以便将来在将代码移至其他模块时，将在更少的地方进行代码更新。

> super 代表当前模块的父模块

#### Making Structs and Enums Public    公开结构和枚举
We can also use pub to designate structs and enums as public, but there are a few extra details. If we use pub before a struct definition, we make the struct public, but the struct’s fields will still be private. We can make each field public or not on a case-by-case basis. In Listing 7-9, we’ve defined a public back_of_house::Breakfast struct with a public toast field but a private seasonal_fruit field. This models the case in a restaurant where the customer can pick the type of bread that comes with a meal, but the chef decides which fruit accompanies the meal based on what’s in season and in stock. The available fruit changes quickly, so customers can’t choose the fruit or even see which fruit they’ll get.  我们也可以pub用来将结构体和枚举指定为公共，但是还有一些额外的细节。如果pub在结构定义之前使用，则将结构公开，但结构的字段仍将是私有的。我们可以根据具体情况公开或不公开每个字段。在清单7-9中，我们定义了一个back_of_house::Breakfast具有公共toast字段但私有seasonal_fruit字段的公共结构。这可以在一家餐馆中为案例建模，顾客可以在这家餐馆选择随餐添加的面包类型，但是厨师会根据季节和库存情况决定随餐搭配的水果。可用的水果变化很快，因此客户无法选择水果，甚至看不到会得到哪种水果。

Filename: src/lib.rs    文件名：src / lib.rs
```rust
mod back_of_house {
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}

pub fn eat_at_restaurant() {
    // Order a breakfast in the summer with Rye toast
    let mut meal = back_of_house::Breakfast::summer("Rye");
    // Change our mind about what bread we'd like
    meal.toast = String::from("Wheat");
    println!("I'd like {} toast please", meal.toast);

    // The next line won't compile if we uncomment it; we're not allowed
    // to see or modify the seasonal fruit that comes with the meal
    // meal.seasonal_fruit = String::from("blueberries");
}
```
Listing 7-9: A struct with some public fields and some private fields   清单7-9：具有一些公共字段和一些私有字段的结构

Because the toast field in the back_of_house::Breakfast struct is public, in eat_at_restaurant we can write and read to the toast field using dot notation. Notice that we can’t use the seasonal_fruit field in eat_at_restaurant because seasonal_fruit is private. Try uncommenting the line modifying the seasonal_fruit field value to see what error you get! 由于结构中的toast字段back_of_house::Breakfast是公共字段，因此eat_at_restaurant我们可以toast使用点符号对字段进行读写。注意，我们不能在其中使用该seasonal_fruit字段， eat_at_restaurant因为它seasonal_fruit是私有的。尝试取消注释修改seasonal_fruit字段值的行，以查看出现什么错误！

Also, note that because back_of_house::Breakfast has a private field, the struct needs to provide a public associated function that constructs an instance of Breakfast (we’ve named it summer here). If Breakfast didn’t have such a function, we couldn’t create an instance of Breakfast in eat_at_restaurant because we couldn’t set the value of the private seasonal_fruit field in eat_at_restaurant.    另外，请注意，由于back_of_house::Breakfast具有私有字段，因此该结构需要提供一个公共的关联函数来构造的实例Breakfast（在summer此已将其命名）。如果Breakfast没有这样的功能，我们将无法创建Breakfastin 的实例，eat_at_restaurant因为我们无法在中设置私有seasonal_fruit字段的值 eat_at_restaurant。

In contrast, if we make an enum public, all of its variants are then public. We only need the pub before the enum keyword, as shown in Listing 7-10.    相反，如果我们将一个枚举公开，则其所有变体都将公开。我们只需要关键字pubbefore enum，如清单7-10所示。

Filename: src/lib.rs
```
mod back_of_house {
    pub enum Appetizer {
        Soup,
        Salad,
    }
}

pub fn eat_at_restaurant() {
    let order1 = back_of_house::Appetizer::Soup;
    let order2 = back_of_house::Appetizer::Salad;
}
```
Listing 7-10: Designating an enum as public makes all its variants public   清单7-10：将枚举指定为公共会使其所有变体成为公共

Because we made the Appetizer enum public, we can use the Soup and Salad variants in eat_at_restaurant. Enums aren’t very useful unless their variants are public; it would be annoying to have to annotate all enum variants with pub in every case, so the default for enum variants is to be public. Structs are often useful without their fields being public, so struct fields follow the general rule of everything being private by default unless annotated with pub.  由于我们将Appetizer枚举公开，因此可以在中使用Soup和Salad 变体eat_at_restaurant。枚举不是很有用，除非它们的变体是公开的。pub在每种情况下都必须对所有枚举变量进行注释会很烦人 ，因此枚举变量的默认设置是公开的。结构通常在没有公开其字段的情况下很有用，因此结构字段遵循一般默认规则，即除非使用注释，否则所有内容均为私有pub。

There’s one more situation involving pub that we haven’t covered, and that is our last module system feature: the use keyword. We’ll cover use by itself first, and then we’ll show how to combine pub and use. pub我们还没有涉及另一种情况，那就是我们的最后一个模块系统功能：use关键字。我们将use首先介绍其本身，然后说明如何结合pub和use。

### 7.4。Bringing Paths into Scope with the use Keyword  使用关键字将路径带入范围

>每一个 Rust 文件的内容都是一个"难以发现"的模块。(每一个 Rust 文件 他的内容都默认属于 一个与文件名一样的 模块。)
>
>use 关键字能够将模块标识符引入当前作用域：
>
>这样就解决了局部模块路径过长的问题。
>
>当然，有些情况下存在两个相同的名称，且同样需要导入，我们可以使用 as 关键字为标识符添加别名：
>
>use crate::nation::government::govern;
>
>use crate::nation::govern as nation_govern;
>
>所有的系统库模块都是被默认导入的，
>
>使用 use 关键字简化路径就可以方便的使用

It might seem like the paths we’ve written to call functions so far are inconveniently long and repetitive. For example, in Listing 7-7, whether we chose the absolute or relative path to the add_to_waitlist function, every time we wanted to call add_to_waitlist we had to specify front_of_house and hosting too. Fortunately, there’s a way to simplify this process. We can bring a path into a scope once and then call the items in that path as if they’re local items with the use keyword. 到目前为止，似乎我们编写的用于调用函数的路径并不方便且冗长。例如，清单7-7中，我们是否选择了绝对或相对路径的add_to_waitlist功能，我们每次想打电话时add_to_waitlist，我们必须指定front_of_house和 hosting太。幸运的是，有一种方法可以简化此过程。我们可以一次将一个路径引入一个范围，然后使用该use关键字将该路径中的项目视为本地项目。

In Listing 7-11, we bring the crate::front_of_house::hosting module into the scope of the eat_at_restaurant function so we only have to specify hosting::add_to_waitlist to call the add_to_waitlist function in eat_at_restaurant. 在清单7-11中，我们将crate::front_of_house::hosting模块放入eat_at_restaurant函数的范围内，因此我们只需要指定 hosting::add_to_waitlist在中调用add_to_waitlist函数即可 eat_at_restaurant。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```
Listing 7-11: Bringing a module into scope with use 清单7-11：将模块带入范围 use

Adding use and a path in a scope is similar to creating a symbolic link in the filesystem. By adding use crate::front_of_house::hosting in the crate root, hosting is now a valid name in that scope, just as though the hosting module had been defined in the crate root. Paths brought into scope with use also check privacy, like any other paths. use在作用域中添加和路径类似于在文件系统中创建符号链接。通过添加use crate::front_of_house::hosting板条箱根，hosting现在在该范围内是一个有效名称，就像hosting 模块已在板条箱根中定义一样。与use 其他路径一样，进入作用域的路径也会检查隐私。

You can also bring an item into scope with use and a relative path. Listing 7-12 shows how to specify a relative path to get the same behavior as in Listing 7-11.  您还可以通过use和相对路径将某项纳入范围。清单7-12显示了如何指定相对路径以获得与清单7-11相同的行为。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use self::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```
Listing 7-12: Bringing a module into scope with use and a relative path 清单7-12：通过use和相对路径将模块引入作用域

#### Creating Idiomatic use Paths   创建惯用use路径
In Listing 7-11, you might have wondered why we specified use crate::front_of_house::hosting and then called hosting::add_to_waitlist in eat_at_restaurant rather than specifying the use path all the way out to the add_to_waitlist function to achieve the same result, as in Listing 7-13.  在清单7-11中，您可能想知道为什么我们指定use crate::front_of_house::hosting然后调用hosting::add_to_waitlist， eat_at_restaurant而不是像清单7-13那样use一直指定到add_to_waitlist函数的路径，以获得相同的结果。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting::add_to_waitlist;

pub fn eat_at_restaurant() {
    add_to_waitlist();
    add_to_waitlist();
    add_to_waitlist();
}
```
Listing 7-13: Bringing the add_to_waitlist function into scope with use, which is unidiomatic   清单7-13：瞻add_to_waitlist功能为与范围use，这是unidiomatic

Although both Listing 7-11 and 7-13 accomplish the same task, Listing 7-11 is the idiomatic way to bring a function into scope with use. Bringing the function’s parent module into scope with use so we have to specify the parent module when calling the function makes it clear that the function isn’t locally defined while still minimizing repetition of the full path. The code in Listing 7-13 is unclear as to where add_to_waitlist is defined. 尽管清单7-11和7-13都完成了相同的任务，但是清单7-11是惯用的将函数带入作用域的方法use。将函数的父模块带入范围内，use因此我们在调用函数时必须指定父模块，以便清楚地知道该函数不是本地定义的，同时仍使完整路径的重复最小化。清单7-13中的代码不清楚在哪里add_to_waitlist定义。

On the other hand, when bringing in structs, enums, and other items with use, it’s idiomatic to specify the full path. Listing 7-14 shows the idiomatic way to bring the standard library’s HashMap struct into the scope of a binary crate.    另一方面，当使用引入结构，枚举和其他项目时use，指定完整路径是惯用的。清单7-14显示了将标准库的HashMap结构引入二进制条板箱范围的惯用方式。

Filename: src/main.rs   文件名：src / main.rs
```
se std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```
Listing 7-14: Bringing HashMap into scope in an idiomatic way   清单7-14：HashMap以惯用的方式进入范围

There’s no strong reason behind this idiom: it’s just the convention that has emerged, and folks have gotten used to reading and writing Rust code this way.    这个习惯用语没有充分的理由：这只是惯例的出现，人们已经习惯了以这种方式读取和编写Rust代码。

The exception to this idiom is if we’re bringing two items with the same name into scope with use statements, because Rust doesn’t allow that. Listing 7-15 shows how to bring two Result types into scope that have the same name but different parent modules and how to refer to them.   这个习惯用法的例外是，如果我们将两个具有相同名称的项目放入use语句范围内，因为Rust不允许这样做。清单7-15显示了如何将两个Result具有相同名称但父模块不同的类型引入范围，以及如何引用它们。

Filename: src/lib.rs    文件名：src / lib.rs
```
use std::fmt;
use std::io;

fn function1() -> fmt::Result {
    // --snip--
}

fn function2() -> io::Result<()> {
    // --snip--
}
```
Listing 7-15: Bringing two types with the same name into the same scope requires using their parent modules.    代码清单7-15：将两个具有相同名称的类型带入相同的作用域需要使用它们的父模块

As you can see, using the parent modules distinguishes the two Result types. If instead we specified use std::fmt::Result and use std::io::Result, we’d have two Result types in the same scope and Rust wouldn’t know which one we meant when we used Result.  如您所见，使用父模块可以区分这两种Result类型。如果相反，我们指定use std::fmt::Result和use std::io::Result，我们将Result在同一范围内有两种类型，而Rust在使用时将不知道我们指的是哪一种Result。

#### Providing New Names with the as Keyword    使用as关键字提供新名称
There’s another solution to the problem of bringing two types of the same name into the same scope with use: after the path, we can specify as and a new local name, or alias, for the type. Listing 7-16 shows another way to write the code in Listing 7-15 by renaming one of the two Result types using as. 还有另一个解决方案，可以通过以下方式将相同名称的两种类型引入同一作用域use：在路径之后，我们可以as为该类型指定一个新的本地名称或别名。清单7-16显示了另一种方式来编写清单7-15中的代码，方法是使用来重命名两种Result类型之一as。

Filename: src/lib.rs    文件名：src / lib.rs
```
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
}

fn function2() -> IoResult<()> {
    // --snip--
}
```
Listing 7-16: Renaming a type when it’s brought into scope with the as keyword  清单7-16：使用as关键字将类型带入范围时重命名

In the second use statement, we chose the new name IoResult for the std::io::Result type, which won’t conflict with the Result from std::fmt that we’ve also brought into scope. Listing 7-15 and Listing 7-16 are considered idiomatic, so the choice is up to you!    在第二个use语句中，我们IoResult为 std::io::Result类型选择了新名称，这与 我们也将其引入范围的Resultfrom 不会冲突std::fmt。清单7-15和清单7-16被认为是惯用的，因此选择取决于您！

#### Re-exporting Names with pub use    用以下方式重新导出名称 pub use
When we bring a name into scope with the use keyword, the name available in the new scope is private. To enable the code that calls our code to refer to that name as if it had been defined in that code’s scope, we can combine pub and use. This technique is called re-exporting because we’re bringing an item into scope but also making that item available for others to bring into their scope.    当我们使用use关键字将名称带入范围时，新范围中可用的名称是私有的。为了使调用我们代码的代码能够引用该名称，就像在该代码的范围内定义了该名称一样，我们可以将pub 和组合在一起use。这项技术称为重新导出，因为我们将某个项目放入范围内，同时也使该项目可供其他人进入其范围内。

Listing 7-17 shows the code in Listing 7-11 with use in the root module changed to pub use. 清单7-17显示了清单7-11中的代码，use其中根模块更改为pub use。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```
Listing 7-17: Making a name available for any code to use from a new scope with pub use 清单7-17：在新作用域中使名称可用于任何代码 pub use

By using pub use, external code can now call the add_to_waitlist function using hosting::add_to_waitlist. If we hadn’t specified pub use, the eat_at_restaurant function could call hosting::add_to_waitlist in its scope, but external code couldn’t take advantage of this new path.  通过使用pub use，外部代码现在可以add_to_waitlist使用调用该函数hosting::add_to_waitlist。如果未指定pub use，则该 eat_at_restaurant函数可以hosting::add_to_waitlist在其作用域内调用，但外部代码无法利用此新路径。

Re-exporting is useful when the internal structure of your code is different from how programmers calling your code would think about the domain. For example, in this restaurant metaphor, the people running the restaurant think about “front of house” and “back of house.” But customers visiting a restaurant probably won’t think about the parts of the restaurant in those terms. With pub use, we can write our code with one structure but expose a different structure. Doing so makes our library well organized for programmers working on the library and programmers calling the library.   当代码的内部结构与调用代码的程序员对域的思考方式不同时，重新导出很有用。例如，在这个餐厅的比喻中，经营餐厅的人会想到“房子的前面”和“房子的后面”。但是光顾这些餐厅的顾客可能不会考虑这些餐厅的组成部分。使用 pub use，我们可以使用一种结构编写代码，但可以公开不同的结构。这样做使我们的库井井有条，适合从事库工作的程序员和调用库的程序员。

#### Using External Packages
In Chapter 2, we programmed a guessing game project that used an external package called rand to get random numbers. To use rand in our project, we added this line to Cargo.toml:  在第2章中，我们编写了一个猜测游戏项目，该项目使用一个名为的外部软件包rand来获取随机数。要rand在我们的项目中使用，我们将此行添加到Cargo.toml中：

Filename: Cargo.toml    文件名：Cargo.toml
```
[dependencies]
rand = "0.5.5"
```
Adding rand as a dependency in Cargo.toml tells Cargo to download the rand package and any dependencies from crates.io and make rand available to our project.  rand在Cargo.toml中添加依赖项后，Cargo会rand从crates.io下载 软件包和任何依赖项，并将其rand提供给我们的项目。

Then, to bring rand definitions into the scope of our package, we added a use line starting with the name of the crate, rand, and listed the items we wanted to bring into scope. Recall that in the “Generating a Random Number” section in Chapter 2, we brought the Rng trait into scope and called the rand::thread_rng function:   然后，为了将rand定义带入包的范围，我们添加了一个use以板条箱名称开头的 行rand，并列出了我们希望带入范围的项目。回想一下，在第2章的“生成随机数”部分中，我们将Rng特征引入了范围并称为rand::thread_rng函数：
```
use rand::Rng;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1, 101);
}
```
Members of the Rust community have made many packages available at crates.io, and pulling any of them into your package involves these same steps: listing them in your package’s Cargo.toml file and using use to bring items from their crates into scope.    Rust社区的成员已经在crates.io上提供了许多软件包 ，将它们中的任何一个放入到软件包中都涉及这些相同的步骤：将它们列出在软件包的Cargo.toml文件中，然后use将其包装中的物品带入范围。

Note that the standard library (std) is also a crate that’s external to our package. Because the standard library is shipped with the Rust language, we don’t need to change Cargo.toml to include std. But we do need to refer to it with use to bring items from there into our package’s scope. For example, with HashMap we would use this line:    请注意，标准库（std）也是我们包外部的板条箱。由于标准库随附Rust语言，因此我们不需要将Cargo.toml更改为include std。但是我们确实需要引用它，use以将其中的项目带入我们的包的范围。例如，HashMap我们将使用以下行：
```
use std::collections::HashMap;
```
This is an absolute path starting with std, the name of the standard library crate. 这是一个以开头的绝对路径std，即标准库箱的名称。

#### Using Nested Paths to Clean Up Large use Lists 使用嵌套路径清理大use列表
If we’re using multiple items defined in the same crate or same module, listing each item on its own line can take up a lot of vertical space in our files. For example, these two use statements we had in the Guessing Game in Listing 2-4 bring items from std into scope:   如果我们使用在同一个板条箱或同一个模块中定义的多个项目，则在每行中列出每个项目会占用我们文件中的大量垂直空间。例如，use清单2-4中的Guessing Game中的以下两个语句将项目从std以下范围引入：

Filename: src/main.rs   文件名：src / main.rs
```
// --snip--
use std::cmp::Ordering;
use std::io;
// --snip--
```
Instead, we can use nested paths to bring the same items into scope in one line. We do this by specifying the common part of the path, followed by two colons, and then curly brackets around a list of the parts of the paths that differ, as shown in Listing 7-18.   相反，我们可以使用嵌套路径将同一项目合并到一行中。为此，我们先指定路径的公共部分，然后指定两个冒号，然后在路径不同部分的列表周围使用花括号，如清单7-18所示。

Filename: src/main.rs   文件名：src / main.rs
```
// --snip--
use std::{cmp::Ordering, io};
// --snip--
```

Listing 7-18: Specifying a nested path to bring multiple items with the same prefix into scope  清单7-18：指定嵌套路径以将具有相同前缀的多个项目带入范围

In bigger programs, bringing many items into scope from the same crate or module using nested paths can reduce the number of separate use statements needed by a lot!   在较大的程序中，使用嵌套路径从同一板条箱或模块中将许多项目纳入范围可以减少use很多所需的独立语句！

We can use a nested path at any level in a path, which is useful when combining two use statements that share a subpath. For example, Listing 7-19 shows two use statements: one that brings std::io into scope and one that brings std::io::Write into scope.  我们可以在路径的任何级别上使用嵌套路径，这在组合两个use共享子路径的语句时非常有用。例如，清单7-19显示了两个 use语句：一个std::io进入范围，另一个 std::io::Write进入范围。

Filename: src/lib.rs    文件名：src / lib.rs
```
use std::io;
use std::io::Write;
```
Listing 7-19: Two use statements where one is a subpath of the other    清单7-19：两个use语句，其中一个是另一个的子路径

The common part of these two paths is std::io, and that’s the complete first path. To merge these two paths into one use statement, we can use self in the nested path, as shown in Listing 7-20.   这两个路径的共同部分是std::io，这就是完整的第一个路径。要将这两个路径合并为一条use语句，我们可以使用self嵌套路径，如清单7-20所示。

Filename: src/lib.rs    文件名：src / lib.rs
```
use std::io::{self, Write};
```
Listing 7-20: Combining the paths in Listing 7-19 into one use statement    清单7-20：将清单7-19中的路径合并为一条use语句

This line brings std::io and std::io::Write into scope. 此行带来了std::io和std::io::Write成的范围。

#### The Glob Operator  全局运算符
If we want to bring all public items defined in a path into scope, we can specify that path followed by *, the glob operator:   如果要将路径中定义的所有公共项目都纳入范围，可以指定该路径，后跟*，glob运算符：
```
use std::collections::*;
```

This use statement brings all public items defined in std::collections into the current scope. Be careful when using the glob operator! Glob can make it harder to tell what names are in scope and where a name used in your program was defined.  该use语句将定义的所有公共项目std::collections带入当前范围。使用glob运算符时要小心！Glob使得更难分辨作用域中的名称以及程序中使用的名称的定义位置。

The glob operator is often used when testing to bring everything under test into the tests module; we’ll talk about that in the “How to Write Tests” section in Chapter 11. The glob operator is also sometimes used as part of the prelude pattern: see the standard library documentation for more information on that pattern.   测试时通常使用glob运算符将要测试的所有内容带入tests模块；我们将在第11章的“如何编写测试”部分中讨论这一点。glob运算符有时也用作前奏模式的一部分： 有关该模式的更多信息，请参见标准库文档。

### 7.5。Separating Modules into Different Files 将模块分成不同的文件
So far, all the examples in this chapter defined multiple modules in one file. When modules get large, you might want to move their definitions to a separate file to make the code easier to navigate. 到目前为止，本章中的所有示例都在一个文件中定义了多个模块。当模块变大时，您可能希望将其定义移动到单独的文件中，以使代码更易于浏览。

For example, let’s start from the code in Listing 7-17 and move the front_of_house module to its own file src/front_of_house.rs by changing the crate root file so it contains the code shown in Listing 7-21. In this case, the crate root file is src/lib.rs, but this procedure also works with binary crates whose crate root file is src/main.rs.  例如，让我们从清单7-17中的代码开始，通过更改板条箱根文件将 front_of_house模块移至其自己的文件src / front_of_house.rs，使其包含清单7-21中所示的代码。在这种情况下，板条箱根文件是src / lib.rs，但是此过程也适用于板条箱根文件是src / main.rs的二进制板条箱。

Filename: src/lib.rs    文件名：src / lib.rs
```
mod front_of_house;

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```
Listing 7-21: Declaring the front_of_house module whose body will be in src/front_of_house.rs   清单7-21：front_of_house在src / front_of_house.rs中声明其主体的模块

And src/front_of_house.rs gets the definitions from the body of the front_of_house module, as shown in Listing 7-22.    和SRC / front_of_house.rs得到从身体的定义 front_of_house模块，如清单7-22英寸

Filename: src/front_of_house.rs 文件名：src / front_of_house.rs
```
pub mod hosting {
    pub fn add_to_waitlist() {}
}
```
Listing 7-22: Definitions inside the front_of_house module in src/front_of_house.rs 清单7-22：src / front_of_house.rs中front_of_house 模块内部的定义

Using a semicolon after mod front_of_house rather than using a block tells Rust to load the contents of the module from another file with the same name as the module. To continue with our example and extract the hosting module to its own file as well, we change src/front_of_house.rs to contain only the declaration of the hosting module:  在分号之后mod front_of_house而不是在分号之后使用分号告诉Rust从另一个与模块同名的文件中加载模块的内容。为了继续我们的示例并将hosting模块提取到其自己的文件中，我们将src / front_of_house.rs更改为仅包含hosting模块的声明：

Filename: src/front_of_house.rs 文件名：src / front_of_house.rs
```
pub mod hosting;
```
Then we create a src/front_of_house directory and a file src/front_of_house/hosting.rs to contain the definitions made in the hosting module:   然后，我们创建一个src / front_of_house目录和一个文件 src / front_of_house / hosting.rs，以包含在hosting模块中所做的定义 ：

Filename: src/front_of_house/hosting.rs 文件名：src / front_of_house / hosting.rs
```
pub fn add_to_waitlist() {}
```

The module tree remains the same, and the function calls in eat_at_restaurant will work without any modification, even though the definitions live in different files. This technique lets you move modules to new files as they grow in size.  模块树保持不变，eat_at_restaurant 即使定义存在于不同的文件中，调用的函数也无需任何修改即可工作。这种技术使您可以随着模块大小的增加而将其移动到新文件中。

Note that the pub use crate::front_of_house::hosting statement in src/lib.rs also hasn’t changed, nor does use have any impact on what files are compiled as part of the crate. The mod keyword declares modules, and Rust looks in a file with the same name as the module for the code that goes into that module.    请注意，src / lib.rs中的pub use crate::front_of_house::hosting语句 也没有更改，也不会影响作为板条箱一部分编译的文件。该关键字声明模块和锈看起来具有相同的名称作为该进入该模块的代码模块的文件。usemod

#### Summary    摘要
Rust lets you split a package into multiple crates and a crate into modules so you can refer to items defined in one module from another module. You can do this by specifying absolute or relative paths. These paths can be brought into scope with a use statement so you can use a shorter path for multiple uses of the item in that scope. Module code is private by default, but you can make definitions public by adding the pub keyword.  Rust使您可以将一个包分成多个包装箱，然后将一个包装箱分成多个模块，以便可以从另一个模块引用一个模块中定义的项目。您可以通过指定绝对或相对路径来做到这一点。可以使用一条use语句将这些路径纳入范围，因此您可以在该范围内为该项目的多次使用使用较短的路径。默认情况下，模块代码是私有的，但是您可以通过添加pub关键字来使定义公开。

In the next chapter, we’ll look at some collection data structures in the standard library that you can use in your neatly organized code.  在下一章中，我们将研究标准库中的一些集合数据结构，您可以在整洁的代码中使用它们。




