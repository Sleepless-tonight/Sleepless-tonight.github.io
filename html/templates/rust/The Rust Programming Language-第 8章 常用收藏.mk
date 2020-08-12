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
Listing 8-1: Creating a new, empty vector to hold values of type i32

Note that we added a type annotation here. Because we aren’t inserting any values into this vector, Rust doesn’t know what kind of elements we intend to store. This is an important point. Vectors are implemented using generics; we’ll cover how to use generics with your own types in Chapter 10. For now, know that the Vec<T> type provided by the standard library can hold any type, and when a specific vector holds a specific type, the type is specified within angle brackets. In Listing 8-1, we’ve told Rust that the Vec<T> in v will hold elements of the i32 type.

In more realistic code, Rust can often infer the type of value you want to store once you insert values, so you rarely need to do this type annotation. It’s more common to create a Vec<T> that has initial values, and Rust provides the vec! macro for convenience. The macro will create a new vector that holds the values you give it. Listing 8-2 creates a new Vec<i32> that holds the values 1, 2, and 3. The integer type is i32 because that’s the default integer type, as we discussed in the “Data Types” section of Chapter 3.
```
 let v = vec![1, 2, 3];
```
Listing 8-2: Creating a new vector containing values

Because we’ve given initial i32 values, Rust can infer that the type of v is Vec<i32>, and the type annotation isn’t necessary. Next, we’ll look at how to modify a vector.

Updating a Vector

To create a vector and then add elements to it, we can use the push method, as shown in Listing 8-3.
```
    let mut v = Vec::new();

    v.push(5);
    v.push(6);
    v.push(7);
    v.push(8);
```
Listing 8-3: Using the push method to add values to a vector

As with any variable, if we want to be able to change its value, we need to make it mutable using the mut keyword, as discussed in Chapter 3. The numbers we place inside are all of type i32, and Rust infers this from the data, so we don’t need the Vec<i32> annotation.

Dropping a Vector Drops Its Elements

Like any other struct, a vector is freed when it goes out of scope, as annotated in Listing 8-4.
```
    {
        let v = vec![1, 2, 3, 4];

        // do stuff with v
    } // <- v goes out of scope and is freed here
```
Listing 8-4: Showing where the vector and its elements are dropped

When the vector gets dropped, all of its contents are also dropped, meaning those integers it holds will be cleaned up. This may seem like a straightforward point but can get a bit more complicated when you start to introduce references to the elements of the vector. Let’s tackle that next!

Reading Elements of Vectors

Now that you know how to create, update, and destroy vectors, knowing how to read their contents is a good next step. There are two ways to reference a value stored in a vector. In the examples, we’ve annotated the types of the values that are returned from these functions for extra clarity.

Listing 8-5 shows both methods of accessing a value in a vector, either with indexing syntax or the get method.
```
    let v = vec![1, 2, 3, 4, 5];

    let third: &i32 = &v[2];
    println!("The third element is {}", third);

    match v.get(2) {
        Some(third) => println!("The third element is {}", third),
        None => println!("There is no third element."),
    }
```
Listing 8-5: Using indexing syntax or the get method to access an item in a vector

Note two details here. First, we use the index value of 2 to get the third element: vectors are indexed by number, starting at zero. Second, the two ways to get the third element are by using & and [], which gives us a reference, or by using the get method with the index passed as an argument, which gives us an Option<&T>.

Rust has two ways to reference an element so you can choose how the program behaves when you try to use an index value that the vector doesn’t have an element for. As an example, let’s see what a program will do if it has a vector that holds five elements and then tries to access an element at index 100, as shown in Listing 8-6.
```
    let v = vec![1, 2, 3, 4, 5];

    let does_not_exist = &v[100];
    let does_not_exist = v.get(100);
```
Listing 8-6: Attempting to access the element at index 100 in a vector containing five elements

When we run this code, the first [] method will cause the program to panic because it references a nonexistent element. This method is best used when you want your program to crash if there’s an attempt to access an element past the end of the vector.

When the get method is passed an index that is outside the vector, it returns None without panicking. You would use this method if accessing an element beyond the range of the vector happens occasionally under normal circumstances. Your code will then have logic to handle having either Some(&element) or None, as discussed in Chapter 6. For example, the index could be coming from a person entering a number. If they accidentally enter a number that’s too large and the program gets a None value, you could tell the user how many items are in the current vector and give them another chance to enter a valid value. That would be more user-friendly than crashing the program due to a typo!

When the program has a valid reference, the borrow checker enforces the ownership and borrowing rules (covered in Chapter 4) to ensure this reference and any other references to the contents of the vector remain valid. Recall the rule that states you can’t have mutable and immutable references in the same scope. That rule applies in Listing 8-7, where we hold an immutable reference to the first element in a vector and try to add an element to the end, which won’t work.
```
    let mut v = vec![1, 2, 3, 4, 5];

    let first = &v[0];

    v.push(6);

    println!("The first element is: {}", first);
```
Listing 8-7: Attempting to add an element to a vector while holding a reference to an item

Compiling this code will result in this error:
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
The code in Listing 8-7 might look like it should work: why should a reference to the first element care about what changes at the end of the vector? This error is due to the way vectors work: adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn’t enough room to put all the elements next to each other where the vector currently is. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.

> Note: For more on the implementation details of the Vec<T> type, see “The Rustonomicon”.

Iterating over the Values in a Vector

If we want to access each element in a vector in turn, we can iterate through all of the elements rather than use indices to access one at a time. Listing 8-8 shows how to use a for loop to get immutable references to each element in a vector of i32 values and print them.
```
    let v = vec![100, 32, 57];
    for i in &v {
        println!("{}", i);
    }
```
Listing 8-8: Printing each element in a vector by iterating over the elements using a for loop

We can also iterate over mutable references to each element in a mutable vector in order to make changes to all the elements. The for loop in Listing 8-9 will add 50 to each element.
```
    let mut v = vec![100, 32, 57];
    for i in &mut v {
        *i += 50;
    }
```
Listing 8-9: Iterating over mutable references to elements in a vector

To change the value that the mutable reference refers to, we have to use the dereference operator (*) to get to the value in i before we can use the += operator. We’ll talk more about the dereference operator in the “Following the Pointer to the Value with the Dereference Operator” section of Chapter 15.

Using an Enum to Store Multiple Types

At the beginning of this chapter, we said that vectors can only store values that are the same type. This can be inconvenient; there are definitely use cases for needing to store a list of items of different types. Fortunately, the variants of an enum are defined under the same enum type, so when we need to store elements of a different type in a vector, we can define and use an enum!

For example, say we want to get values from a row in a spreadsheet in which some of the columns in the row contain integers, some floating-point numbers, and some strings. We can define an enum whose variants will hold the different value types, and then all the enum variants will be considered the same type: that of the enum. Then we can create a vector that holds that enum and so, ultimately, holds different types. We’ve demonstrated this in Listing 8-10.
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
Listing 8-10: Defining an enum to store values of different types in one vector

Rust needs to know what types will be in the vector at compile time so it knows exactly how much memory on the heap will be needed to store each element. A secondary advantage is that we can be explicit about what types are allowed in this vector. If Rust allowed a vector to hold any type, there would be a chance that one or more of the types would cause errors with the operations performed on the elements of the vector. Using an enum plus a match expression means that Rust will ensure at compile time that every possible case is handled, as discussed in Chapter 6.

When you’re writing a program, if you don’t know the exhaustive set of types the program will get at runtime to store in a vector, the enum technique won’t work. Instead, you can use a trait object, which we’ll cover in Chapter 17.

Now that we’ve discussed some of the most common ways to use vectors, be sure to review the API documentation for all the many useful methods defined on Vec<T> by the standard library. For example, in addition to push, a pop method removes and returns the last element. Let’s move on to the next collection type: String!
### 8.2。使用字符串存储UTF-8编码文本
### 8.3。在哈希图中存储具有关联值的键
































































