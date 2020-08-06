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
Listing 7-10: Designating an enum as public makes all its variants public

Because we made the Appetizer enum public, we can use the Soup and Salad variants in eat_at_restaurant. Enums aren’t very useful unless their variants are public; it would be annoying to have to annotate all enum variants with pub in every case, so the default for enum variants is to be public. Structs are often useful without their fields being public, so struct fields follow the general rule of everything being private by default unless annotated with pub.

There’s one more situation involving pub that we haven’t covered, and that is our last module system feature: the use keyword. We’ll cover use by itself first, and then we’ll show how to combine pub and use.

### 7.4。使用关键字将路径带入范围


### 7.5。将模块分成不同的文件
