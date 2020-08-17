## 第 8章 Common Collections  常用集合
Rust’s standard library includes a number of very useful data structures called collections. Most other data types represent one specific value, but collections can contain multiple values. Unlike the built-in array and tuple types, the data these collections point to is stored on the heap, which means the amount of data does not need to be known at compile time and can grow or shrink as the program runs. Each kind of collection has different capabilities and costs, and choosing an appropriate one for your current situation is a skill you’ll develop over time. In this chapter, we’ll discuss three collections that are used very often in Rust programs:Rust的标准库包括许多非常有用的数据结构，称为 collections。大多数其他数据类型表示一个特定值，但是集合可以包含多个值。与内置数组和元组类型不同，这些集合指向的数据存储在堆中，这意味着在编译时不需要知道数据量，并且可以在程序运行时增加或缩小。每种类型的收藏品都有不同的功能和成本，并且根据当前情况选择合适的收藏品是您将随着时间的推移而发展的一项技能。在本章中，我们将讨论Rust程序中经常使用的三个集合：

- A vector allows you to store a variable number of values next to each other.  一个 矢量 允许你值的可变数量的存储彼此相邻。
- A string is a collection of characters. We’ve mentioned the String type previously, but in this chapter we’ll talk about it in depth. 一个字符串是字符的集合。我们之前已经提到过该String类型，但是在本章中我们将深入讨论它。
- A hash map allows you to associate a value with a particular key. It’s a particular implementation of the more general data structure called a map.   一个 哈希表 ，您可以将值与特定的键关联。这是称为map的更通用数据结构的特定实现。

To learn about the other kinds of collections provided by the standard library, see the documentation.  要了解标准库提供的其他种类的集合，请参阅文档。

We’ll discuss how to create and update vectors, strings, and hash maps, as well as what makes each special. 们将讨论如何创建和更新向量，字符串和哈希图，以及使每个特征与众不同的地方。

### 8.1。Storing Lists of Values with Vectors    用向量存储值列表

The first collection type we’ll look at is Vec<T>, also known as a vector. Vectors allow you to store more than one value in a single data structure that puts all the values next to each other in memory. Vectors can only store values of the same type. They are useful when you have a list of items, such as the lines of text in a file or the prices of items in a shopping cart.   我们要研究的第一个集合类型是矢量Vec<T>，也称为矢量。向量使您可以在单个数据结构中存储多个值，该结构将所有值彼此相邻放置在内存中。向量只能存储相同类型的值。当您具有项目列表时，例如文件中的文本行或购物车中项目的价格时，它们很有用。

#### Creating a New Vector

To create a new, empty vector, we can call the Vec::new function, as shown in Listing 8-1.  要创建一个新的空向量，我们可以调用该Vec::new函数，如清单8-1所示。
```
   let v: Vec<i32> = Vec::new();
```
Listing 8-1: Creating a new, empty vector to hold values of type i32    清单8-1：创建一个新的空向量来保存类型的值 i32

Note that we added a type annotation here. Because we aren’t inserting any values into this vector, Rust doesn’t know what kind of elements we intend to store. This is an important point. Vectors are implemented using generics; we’ll cover how to use generics with your own types in Chapter 10. For now, know that the Vec<T> type provided by the standard library can hold any type, and when a specific vector holds a specific type, the type is specified within angle brackets. In Listing 8-1, we’ve told Rust that the Vec<T> in v will hold elements of the i32 type.   请注意，我们在此处添加了类型注释。因为我们没有在此向量中插入任何值，所以Rust不知道我们打算存储哪种元素。这是重要的一点。向量是使用泛型实现的；我们将在第10章中介绍如何将泛型与您自己的类型一起使用。现在，您知道Vec<T>标准库提供的类型可以容纳任何类型，并且当特定向量具有特定类型时，该类型将在尖括号中指定。在清单8-1中，我们告诉Rust，Vec<T>in v将容纳该i32类型的元素。

In more realistic code, Rust can often infer the type of value you want to store once you insert values, so you rarely need to do this type annotation. It’s more common to create a Vec<T> that has initial values, and Rust provides the vec! macro for convenience. The macro will create a new vector that holds the values you give it. Listing 8-2 creates a new Vec<i32> that holds the values 1, 2, and 3. The integer type is i32 because that’s the default integer type, as we discussed in the “Data Types” section of Chapter 3.   在更实际的代码中，Rust通常可以在插入值后就推断出要存储的值的类型，因此您几乎不需要执行此类型注释。创建Vec<T>具有初始值的更为常见，Rust vec!为方便起见提供了该宏。宏将创建一个新向量，其中包含您提供的值。清单8-2创建一个新的Vec<i32>保存价值1，2和3。整数类型是i32因为这是默认的整数类型，正如我们在第3章的“数据类型”一节中讨论的那样。
```
 let v = vec![1, 2, 3];
```
Listing 8-2: Creating a new vector containing values    清单8-2：创建一个包含值的新向量

Because we’ve given initial i32 values, Rust can infer that the type of v is Vec<i32>, and the type annotation isn’t necessary. Next, we’ll look at how to modify a vector. 因为我们已经给定了初始i32值，所以Rust可以推断出的类型v 为Vec<i32>，并且不需要类型注释。接下来，我们将研究如何修改向量。

#### Updating a Vector

To create a vector and then add elements to it, we can use the push method, as shown in Listing 8-3.    要创建一个向量，然后向其中添加元素，我们可以使用push方法，如清单8-3所示。
```
    let mut v = Vec::new();

    v.push(5);
    v.push(6);
    v.push(7);
    v.push(8);
```
Listing 8-3: Using the push method to add values to a vector    清单8-3：使用该push方法向向量添加值

As with any variable, if we want to be able to change its value, we need to make it mutable using the mut keyword, as discussed in Chapter 3. The numbers we place inside are all of type i32, and Rust infers this from the data, so we don’t need the Vec<i32> annotation.    与任何变量一样，如果我们希望能够更改其值，则需要使用mut关键字使它可变，如第3章中所述。我们放入其中的数字均为type i32，Rust从数据中推断出这一点，因此我们不需要Vec<i32>注释。

#### Dropping a Vector Drops Its Elements   删除向量将删除其元素

Like any other struct, a vector is freed when it goes out of scope, as annotated in Listing 8-4.    像其他任何struct一个向量一样，向量超出范围时将被释放，如清单8-4所示。
```
    {
        let v = vec![1, 2, 3, 4];

        // do stuff with v
    } // <- v goes out of scope and is freed here
```
Listing 8-4: Showing where the vector and its elements are dropped  清单8-4：显示放置向量及其元素的位置

When the vector gets dropped, all of its contents are also dropped, meaning those integers it holds will be cleaned up. This may seem like a straightforward point but can get a bit more complicated when you start to introduce references to the elements of the vector. Let’s tackle that next! 当向量被丢弃时，其所有内容也将被丢弃，这意味着其所持有的那些整数将被清除。这似乎很简单，但是当您开始引入对向量元素的引用时，可能会变得更加复杂。让我们接下来解决这个问题！

#### Reading Elements of Vectors    向量的阅读要素

Now that you know how to create, update, and destroy vectors, knowing how to read their contents is a good next step. There are two ways to reference a value stored in a vector. In the examples, we’ve annotated the types of the values that are returned from these functions for extra clarity.    既然您知道如何创建，更新和销毁向量，那么下一步就是了解如何读取向量的内容。有两种方法可以引用存储在向量中的值。在示例中，我们为从这些函数返回的值的类型添加了注释，以更加明确。

Listing 8-5 shows both methods of accessing a value in a vector, either with indexing syntax or the get method. 清单8-5展示了两种使用索引语法或方法访问向量中值的get方法。
```
fn main() {
    let v = vec![1, 2, 3, 4, 5];

    let third: &i32 = &v[2];
    println!("The third element is {}", third);

    match v.get(2) {
        Some(third) => println!("The third element is {}", third),
        None => println!("There is no third element."),
    }
}
```
Listing 8-5: Using indexing syntax or the get method to access an item in a vector  清单8-5：使用索引语法或get方法访问向量中的项目

Note two details here. First, we use the index value of 2 to get the third element: vectors are indexed by number, starting at zero. Second, the two ways to get the third element are by using & and [], which gives us a reference, or by using the get method with the index passed as an argument, which gives us an Option<&T>.    请在此处注意两个细节。首先，我们使用的索引值2获取第三个元素：向量从零开始按数字索引。其次，获得第三个元素的两种方法是使用&和[]，这为我们提供了一个参考，或者使用get将索引作为参数传递的方法，这给了我们一个Option<&T>。

Rust has two ways to reference an element so you can choose how the program behaves when you try to use an index value that the vector doesn’t have an element for. As an example, let’s see what a program will do if it has a vector that holds five elements and then tries to access an element at index 100, as shown in Listing 8-6.  Rust有两种引用元素的方法，因此您可以选择在尝试使用向量没有元素的索引值时程序的行为。作为示例，让我们看看程序具有一个包含五个元素的向量，然后尝试访问索引为100的元素时的操作，如清单8-6所示。
```
    let v = vec![1, 2, 3, 4, 5];

    let does_not_exist = &v[100];
    let does_not_exist = v.get(100);
```
Listing 8-6: Attempting to access the element at index 100 in a vector containing five elements 清单8-6：尝试在包含五个元素的向量中访问索引为100的元素

When we run this code, the first [] method will cause the program to panic because it references a nonexistent element. This method is best used when you want your program to crash if there’s an attempt to access an element past the end of the vector. 当我们运行此代码时，第[]一种方法将导致程序出现恐慌，因为它引用了不存在的元素。如果要访问向量结尾之后的元素，则当您希望程序崩溃时，最好使用此方法。

When the get method is passed an index that is outside the vector, it returns None without panicking. You would use this method if accessing an element beyond the range of the vector happens occasionally under normal circumstances. Your code will then have logic to handle having either Some(&element) or None, as discussed in Chapter 6. For example, the index could be coming from a person entering a number. If they accidentally enter a number that’s too large and the program gets a None value, you could tell the user how many items are in the current vector and give them another chance to enter a valid value. That would be more user-friendly than crashing the program due to a typo!   当该get方法传递给向量之外的索引时，它None不会惊慌地返回 。如果在正常情况下偶尔访问超出向量范围的元素，则可以使用此方法。然后，您的代码将具有处理或包含Some(&element)或的 逻辑None，如第6章中所述。例如，索引可能来自输入数字的人。如果他们不小心输入了一个太大的数字而程序得到了一个None值，您可以告诉用户当前向量中有多少个项目，并给他们另一个输入有效值的机会。这比由于错字而导致程序崩溃更人性化！

When the program has a valid reference, the borrow checker enforces the ownership and borrowing rules (covered in Chapter 4) to ensure this reference and any other references to the contents of the vector remain valid. Recall the rule that states you can’t have mutable and immutable references in the same scope. That rule applies in Listing 8-7, where we hold an immutable reference to the first element in a vector and try to add an element to the end, which won’t work.   当程序具有有效的引用时，借用检查器将执行所有权和借用规则（在第4章中介绍），以确保该引用和对向量内容的任何其他引用保持有效。回想一下规则，该规则规定在同一范围内不能有可变和不可变的引用。该规则适用于清单8-7，其中我们对向量中的第一个元素持有不变的引用，并尝试将元素添加到末尾，这是行不通的。
```
    let mut v = vec![1, 2, 3, 4, 5];

    let first = &v[0];

    v.push(6);

    println!("The first element is: {}", first);
```
Listing 8-7: Attempting to add an element to a vector while holding a reference to an item  清单8-7：尝试在保留对项目的引用的同时向矢量添加元素

Compiling this code will result in this error:  编译此代码将导致以下错误：
```
$ cargo run
   Compiling collections v0.1.0 (file:///projects/collections)
error[E0502]: cannot borrow `v` as mutable because it is also borrowed as immutable
 --> src/main.rs:6:5
  |
4 |     let first = &v[0];
  |                  - immutable borrow occurs here
5 | 
6 |     v.push(6);
  |     ^^^^^^^^^ mutable borrow occurs here
7 | 
8 |     println!("The first element is: {}", first);
  |                                          ----- immutable borrow later used here

error: aborting due to previous error

For more information about this error, try `rustc --explain E0502`.
error: could not compile `collections`.

To learn more, run the command again with --verbose.
```
The code in Listing 8-7 might look like it should work: why should a reference to the first element care about what changes at the end of the vector? This error is due to the way vectors work: adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn’t enough room to put all the elements next to each other where the vector currently is. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.   清单8-7中的代码可能看起来应该工作：为什么对第一个元素的引用应该关心向量结尾处的变化？此错误是由于向量的工作方式造成的：如果没有足够的空间将所有元素放在每个元素的旁边，则在向量的末尾添加一个新元素可能需要分配新的内存并将旧元素复制到新空间中向量当前所在的其他位置。在这种情况下，对第一个元素的引用将指向释放的内存。借用规则阻止程序在这种情况下结束。

> Note: For more on the implementation details of the Vec<T> type, see “The Rustonomicon”.  注意：有关该Vec<T>类型的实现详细信息，请参见“ The Rustonomicon”。

#### Iterating over the Values in a Vector  遍历向量中的值

If we want to access each element in a vector in turn, we can iterate through all of the elements rather than use indices to access one at a time. Listing 8-8 shows how to use a for loop to get immutable references to each element in a vector of i32 values and print them.    如果我们要依次访问向量中的每个元素，则可以遍历所有元素，而不必一次使用索引来访问一个。清单8-8显示了如何使用for循环获取i32值向量中每个元素的不可变引用并进行打印。
```
    let v = vec![100, 32, 57];
    for i in &v {
        println!("{}", i);
    }
```
Listing 8-8: Printing each element in a vector by iterating over the elements using a for loop  清单8-8：通过使用for循环遍历元素来打印向量中的每个元素

We can also iterate over mutable references to each element in a mutable vector in order to make changes to all the elements. The for loop in Listing 8-9 will add 50 to each element.  我们还可以迭代对可变向量中每个元素的可变引用，以对所有元素进行更改。for清单8-9中的循环将添加50到每个元素。
```
    let mut v = vec![100, 32, 57];
    for i in &mut v {
        *i += 50;
    }
```
Listing 8-9: Iterating over mutable references to elements in a vector  清单8-9：迭代对向量中元素的可变引用

To change the value that the mutable reference refers to, we have to use the dereference operator (*) to get to the value in i before we can use the += operator. We’ll talk more about the dereference operator in the “Following the Pointer to the Value with the Dereference Operator” section of Chapter 15.   要更改可变引用所引用的值，我们必须使用解引用运算符（*）来获取值，i然后才能使用该 +=运算符。我们将在 第15章的“使用Dereference运算符跟随指针到值”部分中进一步讨论dereference运算符 

#### Using an Enum to Store Multiple Types  使用枚举存储多种类型

At the beginning of this chapter, we said that vectors can only store values that are the same type. This can be inconvenient; there are definitely use cases for needing to store a list of items of different types. Fortunately, the variants of an enum are defined under the same enum type, so when we need to store elements of a different type in a vector, we can define and use an enum! 在本章开始时，我们说过向量只能存储相同类型的值。这可能会带来不便；肯定有一些用例需要存储不同类型的项目列表。幸运的是，枚举的变体是在相同的枚举类型下定义的，因此当我们需要在向量中存储不同类型的元素时，我们可以定义和使用枚举！

For example, say we want to get values from a row in a spreadsheet in which some of the columns in the row contain integers, some floating-point numbers, and some strings. We can define an enum whose variants will hold the different value types, and then all the enum variants will be considered the same type: that of the enum. Then we can create a vector that holds that enum and so, ultimately, holds different types. We’ve demonstrated this in Listing 8-10.   例如，假设我们要从电子表格的一行中获取值，其中该行中的某些列包含整数，一些浮点数和一些字符串。我们可以定义一个枚举，其变量将包含不同的值类型，然后所有枚举变量将被视为相同的类型：枚举的类型。然后，我们可以创建一个包含该枚举的向量，从而最终包含不同的类型。我们已在清单8-10中对此进行了演示。
```
    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }

    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];
```
Listing 8-10: Defining an enum to store values of different types in one vector 清单8-10：定义将一个enum不同类型的值存储在一个向量中

Rust needs to know what types will be in the vector at compile time so it knows exactly how much memory on the heap will be needed to store each element. A secondary advantage is that we can be explicit about what types are allowed in this vector. If Rust allowed a vector to hold any type, there would be a chance that one or more of the types would cause errors with the operations performed on the elements of the vector. Using an enum plus a match expression means that Rust will ensure at compile time that every possible case is handled, as discussed in Chapter 6.  Rust需要知道在编译时向量中将包含哪些类型，因此Rust确切知道要存储每个元素需要多少内存。第二个优点是，我们可以明确说明此向量允许哪些类型。如果Rust允许向量保留任何类型，则一个或多个类型可能会导致对向量元素执行的操作出错。使用枚举加match表达式意味着Rust将在编译时确保处理所有可能的情况，如第6章中所述。

When you’re writing a program, if you don’t know the exhaustive set of types the program will get at runtime to store in a vector, the enum technique won’t work. Instead, you can use a trait object, which we’ll cover in Chapter 17. 在编写程序时，如果您不知道程序将在运行时获取的完整类型集以存储在向量中，则枚举技术将不起作用。相反，您可以使用trait对象，我们将在第17章中介绍。

Now that we’ve discussed some of the most common ways to use vectors, be sure to review the API documentation for all the many useful methods defined on Vec<T> by the standard library. For example, in addition to push, a pop method removes and returns the last element. Let’s move on to the next collection type: String!    现在，我们已经讨论了一些使用向量的最常用方法，请确保查看API文档中Vec<T>有关标准库定义的所有有用方法的信息 。例如，除了push，pop 方法还删除并返回最后一个元素。让我们继续下一个集合类型：String！


### 8.2。Storing UTF-8 Encoded Text with Strings 使用字符串存储UTF-8编码文本
We talked about strings in Chapter 4, but we’ll look at them in more depth now. New Rustaceans commonly get stuck on strings for a combination of three reasons: Rust’s propensity for exposing possible errors, strings being a more complicated data structure than many programmers give them credit for, and UTF-8. These factors combine in a way that can seem difficult when you’re coming from other programming languages.

It’s useful to discuss strings in the context of collections because strings are implemented as a collection of bytes, plus some methods to provide useful functionality when those bytes are interpreted as text. In this section, we’ll talk about the operations on String that every collection type has, such as creating, updating, and reading. We’ll also discuss the ways in which String is different from the other collections, namely how indexing into a String is complicated by the differences between how people and computers interpret String data.

What Is a String?
We’ll first define what we mean by the term string. Rust has only one string type in the core language, which is the string slice str that is usually seen in its borrowed form &str. In Chapter 4, we talked about string slices, which are references to some UTF-8 encoded string data stored elsewhere. String literals, for example, are stored in the program’s binary and are therefore string slices.

The String type, which is provided by Rust’s standard library rather than coded into the core language, is a growable, mutable, owned, UTF-8 encoded string type. When Rustaceans refer to “strings” in Rust, they usually mean the String and the string slice &str types, not just one of those types. Although this section is largely about String, both types are used heavily in Rust’s standard library, and both String and string slices are UTF-8 encoded.

Rust’s standard library also includes a number of other string types, such as OsString, OsStr, CString, and CStr. Library crates can provide even more options for storing string data. See how those names all end in String or Str? They refer to owned and borrowed variants, just like the String and str types you’ve seen previously. These string types can store text in different encodings or be represented in memory in a different way, for example. We won’t discuss these other string types in this chapter; see their API documentation for more about how to use them and when each is appropriate.

Creating a New String
Many of the same operations available with Vec<T> are available with String as well, starting with the new function to create a string, shown in Listing 8-11.


    let mut s = String::new();
Listing 8-11: Creating a new, empty String

This line creates a new empty string called s, which we can then load data into. Often, we’ll have some initial data that we want to start the string with. For that, we use the to_string method, which is available on any type that implements the Display trait, as string literals do. Listing 8-12 shows two examples.


    let data = "initial contents";

    let s = data.to_string();

    // the method also works on a literal directly:
    let s = "initial contents".to_string();
Listing 8-12: Using the to_string method to create a String from a string literal

This code creates a string containing initial contents.

We can also use the function String::from to create a String from a string literal. The code in Listing 8-13 is equivalent to the code from Listing 8-12 that uses to_string.


    let s = String::from("initial contents");
Listing 8-13: Using the String::from function to create a String from a string literal

Because strings are used for so many things, we can use many different generic APIs for strings, providing us with a lot of options. Some of them can seem redundant, but they all have their place! In this case, String::from and to_string do the same thing, so which you choose is a matter of style.

Remember that strings are UTF-8 encoded, so we can include any properly encoded data in them, as shown in Listing 8-14.


    let hello = String::from("السلام عليكم");
    let hello = String::from("Dobrý den");
    let hello = String::from("Hello");
    let hello = String::from("שָׁלוֹם");
    let hello = String::from("नमस्ते");
    let hello = String::from("こんにちは");
    let hello = String::from("안녕하세요");
    let hello = String::from("你好");
    let hello = String::from("Olá");
    let hello = String::from("Здравствуйте");
    let hello = String::from("Hola");
Listing 8-14: Storing greetings in different languages in strings

All of these are valid String values.

Updating a String
A String can grow in size and its contents can change, just like the contents of a Vec<T>, if you push more data into it. In addition, you can conveniently use the + operator or the format! macro to concatenate String values.

Appending to a String with push_str and push
We can grow a String by using the push_str method to append a string slice, as shown in Listing 8-15.


    let mut s = String::from("foo");
    s.push_str("bar");
Listing 8-15: Appending a string slice to a String using the push_str method

After these two lines, s will contain foobar. The push_str method takes a string slice because we don’t necessarily want to take ownership of the parameter. For example, the code in Listing 8-16 shows that it would be unfortunate if we weren’t able to use s2 after appending its contents to s1.


    let mut s1 = String::from("foo");
    let s2 = "bar";
    s1.push_str(s2);
    println!("s2 is {}", s2);
Listing 8-16: Using a string slice after appending its contents to a String

If the push_str method took ownership of s2, we wouldn’t be able to print its value on the last line. However, this code works as we’d expect!

The push method takes a single character as a parameter and adds it to the String. Listing 8-17 shows code that adds the letter l to a String using the push method.


    let mut s = String::from("lo");
    s.push('l');
Listing 8-17: Adding one character to a String value using push

As a result of this code, s will contain lol.

Concatenation with the + Operator or the format! Macro
Often, you’ll want to combine two existing strings. One way is to use the + operator, as shown in Listing 8-18.


    let s1 = String::from("Hello, ");
    let s2 = String::from("world!");
    let s3 = s1 + &s2; // note s1 has been moved here and can no longer be used
Listing 8-18: Using the + operator to combine two String values into a new String value

The string s3 will contain Hello, world! as a result of this code. The reason s1 is no longer valid after the addition and the reason we used a reference to s2 has to do with the signature of the method that gets called when we use the + operator. The + operator uses the add method, whose signature looks something like this:


fn add(self, s: &str) -> String {
This isn’t the exact signature that’s in the standard library: in the standard library, add is defined using generics. Here, we’re looking at the signature of add with concrete types substituted for the generic ones, which is what happens when we call this method with String values. We’ll discuss generics in Chapter 10. This signature gives us the clues we need to understand the tricky bits of the + operator.

First, s2 has an &, meaning that we’re adding a reference of the second string to the first string because of the s parameter in the add function: we can only add a &str to a String; we can’t add two String values together. But wait—the type of &s2 is &String, not &str, as specified in the second parameter to add. So why does Listing 8-18 compile?

The reason we’re able to use &s2 in the call to add is that the compiler can coerce the &String argument into a &str. When we call the add method, Rust uses a deref coercion, which here turns &s2 into &s2[..]. We’ll discuss deref coercion in more depth in Chapter 15. Because add does not take ownership of the s parameter, s2 will still be a valid String after this operation.

Second, we can see in the signature that add takes ownership of self, because self does not have an &. This means s1 in Listing 8-18 will be moved into the add call and no longer be valid after that. So although let s3 = s1 + &s2; looks like it will copy both strings and create a new one, this statement actually takes ownership of s1, appends a copy of the contents of s2, and then returns ownership of the result. In other words, it looks like it’s making a lot of copies but isn’t; the implementation is more efficient than copying.

If we need to concatenate multiple strings, the behavior of the + operator gets unwieldy:


    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s3 = String::from("toe");

    let s = s1 + "-" + &s2 + "-" + &s3;
At this point, s will be tic-tac-toe. With all of the + and " characters, it’s difficult to see what’s going on. For more complicated string combining, we can use the format! macro:


    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s3 = String::from("toe");

    let s = format!("{}-{}-{}", s1, s2, s3);
This code also sets s to tic-tac-toe. The format! macro works in the same way as println!, but instead of printing the output to the screen, it returns a String with the contents. The version of the code using format! is much easier to read and doesn’t take ownership of any of its parameters.

Indexing into Strings
In many other programming languages, accessing individual characters in a string by referencing them by index is a valid and common operation. However, if you try to access parts of a String using indexing syntax in Rust, you’ll get an error. Consider the invalid code in Listing 8-19.

This code does not compile!
    let s1 = String::from("hello");
    let h = s1[0];
Listing 8-19: Attempting to use indexing syntax with a String

This code will result in the following error:


$ cargo run
   Compiling collections v0.1.0 (file:///projects/collections)
error[E0277]: the type `std::string::String` cannot be indexed by `{integer}`
 --> src/main.rs:3:13
  |
3 |     let h = s1[0];
  |             ^^^^^ `std::string::String` cannot be indexed by `{integer}`
  |
  = help: the trait `std::ops::Index<{integer}>` is not implemented for `std::string::String`

error: aborting due to previous error

For more information about this error, try `rustc --explain E0277`.
error: could not compile `collections`.

To learn more, run the command again with --verbose.
The error and the note tell the story: Rust strings don’t support indexing. But why not? To answer that question, we need to discuss how Rust stores strings in memory.

Internal Representation
A String is a wrapper over a Vec<u8>. Let’s look at some of our properly encoded UTF-8 example strings from Listing 8-14. First, this one:


    let hello = String::from("Hola");
In this case, len will be 4, which means the vector storing the string “Hola” is 4 bytes long. Each of these letters takes 1 byte when encoded in UTF-8. But what about the following line? (Note that this string begins with the capital Cyrillic letter Ze, not the Arabic number 3.)


    let hello = String::from("Здравствуйте");
Asked how long the string is, you might say 12. However, Rust’s answer is 24: that’s the number of bytes it takes to encode “Здравствуйте” in UTF-8, because each Unicode scalar value in that string takes 2 bytes of storage. Therefore, an index into the string’s bytes will not always correlate to a valid Unicode scalar value. To demonstrate, consider this invalid Rust code:


let hello = "Здравствуйте";
let answer = &hello[0];
What should the value of answer be? Should it be З, the first letter? When encoded in UTF-8, the first byte of З is 208 and the second is 151, so answer should in fact be 208, but 208 is not a valid character on its own. Returning 208 is likely not what a user would want if they asked for the first letter of this string; however, that’s the only data that Rust has at byte index 0. Users generally don’t want the byte value returned, even if the string contains only Latin letters: if &"hello"[0] were valid code that returned the byte value, it would return 104, not h. To avoid returning an unexpected value and causing bugs that might not be discovered immediately, Rust doesn’t compile this code at all and prevents misunderstandings early in the development process.

Bytes and Scalar Values and Grapheme Clusters! Oh My!
Another point about UTF-8 is that there are actually three relevant ways to look at strings from Rust’s perspective: as bytes, scalar values, and grapheme clusters (the closest thing to what we would call letters).

If we look at the Hindi word “नमस्ते” written in the Devanagari script, it is stored as a vector of u8 values that looks like this:


[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164,
224, 165, 135]
That’s 18 bytes and is how computers ultimately store this data. If we look at them as Unicode scalar values, which are what Rust’s char type is, those bytes look like this:


['न', 'म', 'स', '्', 'त', 'े']
There are six char values here, but the fourth and sixth are not letters: they’re diacritics that don’t make sense on their own. Finally, if we look at them as grapheme clusters, we’d get what a person would call the four letters that make up the Hindi word:


["न", "म", "स्", "ते"]
Rust provides different ways of interpreting the raw string data that computers store so that each program can choose the interpretation it needs, no matter what human language the data is in.

A final reason Rust doesn’t allow us to index into a String to get a character is that indexing operations are expected to always take constant time (O(1)). But it isn’t possible to guarantee that performance with a String, because Rust would have to walk through the contents from the beginning to the index to determine how many valid characters there were.

Slicing Strings
Indexing into a string is often a bad idea because it’s not clear what the return type of the string-indexing operation should be: a byte value, a character, a grapheme cluster, or a string slice. Therefore, Rust asks you to be more specific if you really need to use indices to create string slices. To be more specific in your indexing and indicate that you want a string slice, rather than indexing using [] with a single number, you can use [] with a range to create a string slice containing particular bytes:



let hello = "Здравствуйте";

let s = &hello[0..4];
Here, s will be a &str that contains the first 4 bytes of the string. Earlier, we mentioned that each of these characters was 2 bytes, which means s will be Зд.

What would happen if we used &hello[0..1]? The answer: Rust would panic at runtime in the same way as if an invalid index were accessed in a vector:


$ cargo run
   Compiling collections v0.1.0 (file:///projects/collections)
    Finished dev [unoptimized + debuginfo] target(s) in 0.43s
     Running `target/debug/collections`
thread 'main' panicked at 'byte index 1 is not a char boundary; it is inside 'З' (bytes 0..2) of `Здравствуйте`', src/libcore/str/mod.rs:2069:5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace.
You should use ranges to create string slices with caution, because doing so can crash your program.

Methods for Iterating Over Strings
Fortunately, you can access elements in a string in other ways.

If you need to perform operations on individual Unicode scalar values, the best way to do so is to use the chars method. Calling chars on “नमस्ते” separates out and returns six values of type char, and you can iterate over the result to access each element:



for c in "नमस्ते".chars() {
    println!("{}", c);
}
This code will print the following:


न
म
स
्
त
े
The bytes method returns each raw byte, which might be appropriate for your domain:



for b in "नमस्ते".bytes() {
    println!("{}", b);
}
This code will print the 18 bytes that make up this String:


224
164
// --snip--
165
135
But be sure to remember that valid Unicode scalar values may be made up of more than 1 byte.

Getting grapheme clusters from strings is complex, so this functionality is not provided by the standard library. Crates are available on crates.io if this is the functionality you need.

Strings Are Not So Simple
To summarize, strings are complicated. Different programming languages make different choices about how to present this complexity to the programmer. Rust has chosen to make the correct handling of String data the default behavior for all Rust programs, which means programmers have to put more thought into handling UTF-8 data upfront. This trade-off exposes more of the complexity of strings than is apparent in other programming languages, but it prevents you from having to handle errors involving non-ASCII characters later in your development life cycle.

Let’s switch to something a bit less complex: hash maps!


### 8.3。在哈希图中存储具有关联值的键
































































