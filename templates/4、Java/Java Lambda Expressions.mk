## Lambda Expressions
匿名类的一个问题是，如果匿名类的实现非常简单（例如仅包含一个方法的接口），则匿名类的语法可能看起来笨拙且不清楚。在这些情况下，您通常试图将功能作为参数传递给另一种方法，例如，当某人单击按钮时应采取什么措施。Lambda表达式使您能够执行此操作，将功能视为方法参数，或将代码视为数据。

一个功能接口仅包含一个抽象方法，因此在实现该方法时可以省略该方法的名称。为此，您可以使用lambda表达式（而不是使用匿名类表达式）

### Lambda 表达式

A lambda expression is like a method: it provides a list of formal parameters and a body - an expression or block - expressed in terms of those parameters.
lambda表达式类似于一个方法:它提供了一个形式参数列表和一个主体(一个表达式或块)，后者根据这些参数进行表达。
```
LambdaExpression:
LambdaParameters -> LambdaBody
```
Lambda expressions are always poly expressions (§15.2).
Lambda表达式总是poly表达式

It is a compile-time error if a lambda expression occurs in a program in someplace other than an assignment context (§5.2), an invocation context (§5.3), or a casting context (§5.5).
如果lambda表达式出现在程序中的除分配上下文（第5.2节），调用上下文（第5.3节）或强制转换上下文（第5.5 节）之外的其他地方，则是编译时错误。
- 分配上下文
    - 赋值上下文 允许将表达式的值赋给变量
    ```
    // 常量表达式的编译时范围变窄意味着代码如下被允许。
    byte theAnswer = 42;
    ```
- 调用上下文
    - 调用上下文允许将方法或构造函数调用（第 8.8.7.1节，第 15.9节，第 15.12节）中的参数值分配给相应的形式参数。
    ```
    // 严格的或宽松的调用上下文都不包含在赋值上下文中允许的整数常量表达式的隐式缩小。Java编程语言的设计人员认为，包括这些隐式变窄的转换会给重载解析规则（第15.22.2节）增加额外的复杂性。
    public class Test {
        static int m(byte a, int b) { return a+b; }
        // static long m(long a, int b) { return a+b; } // 
        static int m(short a, short b) { return a-b; }
        public static void main(String[] args) {
            System.out.println(m(12, 2));  // compile-time error
        }
    }
    
    ```
- 分配上下文
    - 赋值上下文允许将表达式的值赋给变量
Evaluation of a lambda expression produces an instance of a functional interface (§9.8). Lambda expression evaluation does not cause the execution of the expression's body; instead, this may occur at a later time when an appropriate method of the functional interface is invoked.
对lambda表达式的求值将生成功能接口的实例（第9.8节）。Lambda表达式评估并不会导致表达的身体的执行; 相反，这可能在以后调用功能接口的适当方法时发生。

```
() -> {}                // No parameters; result is void 没有参数；结果为void 
() -> 42                // No parameters, expression body 无参数，表达式主体
() -> null              // No parameters, expression body 无参数，表达式主体
() -> { return 42; }    // No parameters, block body with return 没有参数，使用return 
() -> { System.gc(); }  // No parameters, void block body 没有参数，void块主体

() -> {                 // Complex block body with returns 复杂的块主体，
  if (true) return 12;
  else {
    int result = 15;
    for (int i = 1; i < 10; i++)
      result *= i;
    return result;
  }
}                          

(int x) -> x+1              // Single declared-type parameter 单个声明类型的参数
(int x) -> { return x+1; }  // Single declared-type parameter 单个声明类型的参数
(x) -> x+1                  // Single inferred-type parameter 单个推断类型参数
x -> x+1                    // Parentheses optional for 括号可选 单个推断类型参数
                            // single inferred-type parameter

(String s) -> s.length()      // Single declared-type parameter
(Thread t) -> { t.start(); }  // Single declared-type parameter
s -> s.length()               // Single inferred-type parameter
t -> { t.start(); }           // Single inferred-type parameter

(int x, int y) -> x+y  // Multiple declared-type parameters
(x, y) -> x+y          // Multiple inferred-type parameters
(x, int y) -> x+y    // Illegal: can't mix inferred and declared types
(x, final y) -> x+y  // Illegal: no modifiers with inferred types
```

This syntax has the advantage of minimizing bracket noise around simple lambda expressions, which is especially beneficial when a lambda expression is an argument to a method, or when the body is another lambda expression. It also clearly distinguishes between its expression and statement forms, which avoids ambiguities or over-reliance on ';' tokens. When some extra bracketing is needed to visually distinguish either the full lambda expression or its body expression, parentheses are naturally supported (just as in other cases in which operator precedence is unclear).此语法的优点是最大程度地减少了简单Lambda表达式周围的括号噪音，这在Lambda表达式是方法的自变量或主体是另一个Lambda表达式时特别有用。它还清楚地区分了其表达形式和声明形式，从而避免了歧义或过度依赖' ;'标记。当需要一些额外的包围以视觉上区分完整的lambda表达式或其主体表达式时，自然会支持括号（就像在其他运算符优先级不清楚的情况下一样）。

The syntax has some parsing challenges. The Java programming language has always required arbitrary lookahead to distinguish between types and expressions after a '(' token: what follows may be a cast or a parenthesized expression. This was made worse when generics reused the binary operators '<' and '>' in types. Lambda expressions introduce a new possibility: the tokens following '(' may describe a type, an expression, or a lambda parameter list. Some tokens immediately indicate a parameter list (annotations, final); in other cases there are certain patterns that must be interpreted as parameter lists (two names in a row, a ',' not nested inside of '<' and '>'); and sometimes, the decision cannot be made until a '->' is encountered after a ')'. The simplest way to think of how this might be efficiently parsed is with a state machine: each state represents a subset of possible interpretations (type, expression, or parameters), and when the machine transitions to a state in which the set is a singleton, the parser knows which case it is. This does not map very elegantly to a fixed-lookahead grammar, however.语法有一些解析挑战。Java编程语言始终要求进行任意先行查找，以区分' ('标记后的类型和表达式：其后可能是强制转换或带括号的表达式。当泛型重新使用类型中的二进制运算符“ <”和“ >” 时，情况变得更糟。Lambda表达式引入了一种新的可能性：“ (”之后的标记可以描述类型，表达式或Lambda参数列表。有些标记会立即指示参数列表（注释，final）; 在其他情况下，必须将某些模式解释为参数列表（连续两个名称，' ,'不嵌套在' <'和' >'内）；有时，直到在“ ->”之后遇到“ )” 之后才能做出决定。考虑状态解析的最简单方法是使用状态机：每个状态代表可能的解释（类型，表达式或参数）的子集，以及当机器转换为集合为单例的状态时，解析器知道是哪种情况。但是，这不能很好地映射到固定超前语法。

There is no special nullary form: a lambda expression with zero arguments is expressed as () -> .... The obvious special-case syntax, -> ..., does not work because it introduces an ambiguity between argument lists and casts: (x) -> ....没有特殊的无效形式：参数为零的lambda表达式表示为。明显的特殊情况语法无效，因为它在参数列表和强制类型转换之间引入了歧义。 () -> ...-> ...(x) -> ...

Lambda expressions cannot declare type parameters. While it would make sense semantically to do so, the natural syntax (preceding the parameter list with a type parameter list) introduces messy ambiguities. For example, consider: Lambda表达式无法声明类型参数。尽管这样做从语义上来说是有意义的，但自然语法（在参数列表之前加上类型参数列表）会带来混乱的歧义。例如，考虑：
```
foo( (x) < y , z > (w) -> v )
```

### Lambda 参数

The formal parameters of a lambda expression, if any, are specified by either a parenthesized list of comma-separated parameter specifiers or a parenthesized list of comma-separated identifiers. In a list of parameter specifiers, each parameter specifier consists of optional modifiers, then a type (or var), then an identifier that specifies the name of the parameter. In a list of identifiers, each identifier specifies the name of the parameter.lambda表达式的形式参数（如果有的话）由带括号的逗号分隔参数说明符列表或带括号的逗号分隔标识符列表指定。在参数说明符列表中，每个参数说明符均由可选修饰符组成，然后是类型（或var），然后是指定参数名称的标识符。在标识符列表中，每个标识符都指定参数的名称。

If a lambda expression has no formal parameters, then an empty pair of parentheses appears before the -> and the lambda body.如果lambda表达式没有形式参数，则在->和lambda主体之前会出现一对空括号。

If a lambda expression has exactly one formal parameter, and the parameter is specified by an identifier instead of a parameter specifier, then the parentheses around the identifier may be elided.如果lambda表达式仅具有一个形式参数，并且该参数由标识符而不是参数说明符指定，则可以省略标识符周围的括号。

```
LambdaParameters:
    ( [LambdaParameterList] )
    Identifier
LambdaParameterList:
    LambdaParameter {, LambdaParameter}
    Identifier {, Identifier}
LambdaParameter:
    {VariableModifier} LambdaParameterType VariableDeclaratorId
    VariableArityParameter
LambdaParameterType:
    UnannType
    var
```
The following productions from §8.4.1, §8.3, and §4.3 are shown here for convenience:

```
VariableArityParameter:
    {VariableModifier} UnannType {Annotation} ... Identifier
VariableModifier:
    Annotation
    final
VariableDeclaratorId:
    Identifier [Dims]
Dims:
    {Annotation} [ ] {{Annotation} [ ]}
```
A formal parameter of a lambda expression may be declared final, or annotated, only if specified by a parameter specifier. If a formal parameter is specified by an identifier instead, then the formal parameter is not final and has no annotations.final仅当由参数说明符指定时，才能 声明或批注lambda表达式的形式参数。如果形式参数由标识符代替，则形式参数不是final，也没有注释。

A formal parameter of a lambda expression may be a variable arity parameter, indicated by an ellipsis following the type in a parameter specifier. At most one variable arity parameter is permitted for a lambda expression. It is a compile-time error if a variable arity parameter appears anywhere in the list of parameter specifiers except the last position.Lambda表达式的形式参数可以是可变Arity参数，由参数说明符中的类型后面的省略号表示。lambda表达式最多允许使用一个变量arity参数。如果可变说明参数出现在参数说明符列表中除最后位置之外的任何位置，则是编译时错误。

Each formal parameter of a lambda expression has either an inferred type or a declared type:lambda表达式的每个形式参数都有一个 推断类型或一个声明类型：

- If a formal parameter is specified either by a parameter specifier that uses var, or by an identifier instead of a parameter specifier, then the formal parameter has an inferred type. The type is inferred from the functional interface type targeted by the lambda expression (§15.27.3).如果形式参数是由使用的参数说明符指定的var，或者由标识符而不是参数说明符指定的，则形式参数具有推断的类型。根据lambda表达式（第15.27.3节）所针对的功能接口类型来推断类型。

- If a formal parameter is specified by a parameter specifier that does not use var, then the formal parameter has a declared type. The declared type is determined as follows:如果不使用的参数说明符指定var了形式参数，则形式参数具有声明的类型。声明的类型确定如下：

    - If the formal parameter is not a variable arity parameter, then the declared type is denoted by UnannType if no bracket pairs appear in UnannType and VariableDeclaratorId, and specified by §10.2 otherwise.如果形式参数不是可变arity参数，则 如果在UnannType 和VariableDeclaratorId中没有括号对出现，则声明的类型由UnannType表示，否则由§10.2指定 。

    - If the formal parameter is a variable arity parameter, then the declared type is an array type specified by §10.2.如果形式参数是可变arity参数，则声明的类型是§10.2指定的数组类型 。

No distinction is made between the following lambda parameter lists:以下lambda参数列表之间没有区别：

```
(int... x) -> BODY
(int[] x) -> BODY
```
Either can be used, whether the functional interface's abstract method is fixed arity or variable arity. (This is consistent with the rules for method overriding.) Since lambda expressions are never directly invoked, using int... for the formal parameter where the functional interface uses int[] can have no impact on the surrounding program. In a lambda body, a variable arity parameter is treated just like an array-typed parameter.无论功能接口的抽象方法是固定Arity还是可变Arity，都可以使用。（这与方法重写的规则是一致的。）由于从未直接调用lambda表达式int... ，因此在功能接口使用的形式参数中使用lambda表达式int[]不会影响周围的程序。在lambda主体中，可变arity参数的处理方式与数组类型的参数一样。

A lambda expression where all the formal parameters have declared types is said to be explicitly typed. A lambda expression where all the formal parameters have inferred types is said to be implicitly typed. A lambda expression with no formal parameters is explicitly typed.所有形式参数都已声明类型的lambda表达式被称为显式类型。所有形式参数都具有推断类型的lambda表达式被称为隐式类型。没有形式参数的lambda表达式被显式键入。

If a lambda expression is implicitly typed, then its lambda body is interpreted according to the context in which it appears. Specifically, the types of expressions in the body, and the checked exceptions thrown by the body, and the type correctness of code in the body all depend on the types inferred for the formal parameters. This implies that inference of formal parameter types must occur "before" attempting to type-check the lambda body.如果隐式键入了lambda表达式，则将根据其出现的上下文解释其lambda主体。具体来说，主体中表达式的类型，主体引发的检查异常以及主体中代码的类型正确性均取决于为形式参数推断的类型。这意味着形式参数类型的推断必须在“尝试”检查lambda主体的“之前”进行。

It is a compile-time error if a lambda expression declares a formal parameter with a declared type and a formal parameter with an inferred type.这是一个编译时错误，如果lambda表达式声明与声明的类型形参和一个正式的参数与推断的类型。

This rule prevents a mix of inferred and declared types in the formal parameters, such as (x, int y) -> BODY or (var x, int y) -> BODY. Note that if all the formal parameters have inferred types, the grammar prevents a mix of identifiers and var parameter specifiers, such as (x, var y) -> BODY or (var x, y) -> BODY.此规则可防止在形式参数（例如(x, int y) -> BODY 或）中混合使用推断类型和声明类型(var x, int y) -> BODY。请注意，如果所有形式参数都具有推断的类型，则语法会阻止标识符和var参数说明符的混合使用，例如(x, var y) -> BODY或(var x, y) -> BODY。

The rules for annotation modifiers on a formal parameter declaration are specified in §9.7.4 and §9.7.5.  §9.7.4和§9.7.5 中指定了形式参数声明上的注释修饰符规则。

It is a compile-time error if final appears more than once as a modifier for a formal parameter declaration. 如果final多次出现作为形式参数声明的修饰符，则是编译时错误。

It is a compile-time error if the LambdaParameterType of a formal parameter is var and the VariableDeclaratorId of the same formal parameter has one or more bracket pairs. 如果 形式参数的LambdaParameterType为var且 同一形式参数的VariableDeclaratorId具有一个或多个括号对，则是编译时错误。

The scope and shadowing of a formal parameter declaration is specified in §6.3 and §6.4.  §6.3和§6.4中 指定了形式参数声明的范围和阴影。

It is a compile-time error for a lambda expression to declare two formal parameters with the same name. (That is, their declarations mention the same Identifier.) lambda表达式声明两个具有相同名称的形式参数是编译时错误。（也就是说，它们的声明提到了相同的标识符。）

In Java SE 8, the use of _ as the name of a lambda parameter was forbidden, and its use discouraged as the name for other kinds of variable (§4.12.3). As of Java SE 9, _ is a keyword (§3.9) so it cannot be used as a variable name in any context.   Java SE 8中，_禁止将lambda参数用作名称，并且不建议将其用作其他类型的变量的名称（第4.12.3节）。从Java SE 9开始，它 _是一个关键字（第3.9节），因此在任何上下文中都不能将其用作变量名。

It is a compile-time error if a formal parameter that is declared final is assigned to within the body of the lambda expression. 如果将声明的形式参数final分配给lambda表达式的主体内，则是编译时错误 。

When the lambda expression is invoked (via a method invocation expression (§15.12)), the values of the actual argument expressions initialize newly created parameter variables, each of the declared or inferred type, before execution of the lambda body. The Identifier that appears in the LambdaParameter or directly in the LambdaParameterList or LambdaParameters may be used as a simple name in the lambda body to refer to the formal parameter. 调用lambda表达式时（通过方法调用表达式（第15.12节）），实际参数表达式的值会在执行lambda主体之前初始化新创建的参数变量，每个变量都是声明的或推断的类型。在LambdaParameter中或直接在 LambdaParameterList或 LambdaParameters中出现 的标识符可以用作lambda主体中的简单名称，以引用形式参数。

A lambda expression's formal parameter of type float always contains an element of the float value set (§4.2.3); similarly, a lambda expression's formal parameter of type double always contains an element of the double value set. It is not permitted for a lambda expression's formal parameter of type float to contain an element of the float-extended-exponent value set that is not also an element of the float value set, nor for a lambda expression's formal parameter of type double to contain an element of the double-extended-exponent value set that is not also an element of the double value set. Lambda表达式的形式参数类型float始终包含浮点值集的一个元素（第4.2.3节）；同样，lambda表达式的形式参数类型double 始终包含double值集的元素。Lambda表达式的形式参数的类型不允许float 包含float-extended-exponent值集的元素，该元素既不是float值集的元素，也不允许Lambda表达式的形式参数的类型double 包含double-extended-exponent值集的元素，该元素也不是double值集的元素。

### Lambda Body
A lambda body is either a single expression or a block (§14.2). Like a method body, a lambda body describes code that will be executed whenever an invocation occurs. Lambda主体可以是单个表达式或块（第14.2节）。像方法主体一样，lambda主体描述了每次调用都会执行的代码。

```
LambdaBody:
    Expression
    Block
```
Unlike code appearing in anonymous class declarations, the meaning of names and the this and super keywords appearing in a lambda body, along with the accessibility of referenced declarations, are the same as in the surrounding context (except that lambda parameters introduce new names). 与出现在匿名类声明中的代码不同，在lambda正文中出现的名称和thisand super关键字的含义以及引用声明的可访问性与周围环境相同（除了lambda参数引入新名称）。

The transparency of this (both explicit and implicit) in the body of a lambda expression - that is, treating it the same as in the surrounding context - allows more flexibility for implementations, and prevents the meaning of unqualified names in the body from being dependent on overload resolution.  this lambda表达式主体中（无论是显式的还是隐式的）透明性（即与周围环境相同）将为实现提供更大的灵活性，并防止主体中不合格名称的含义依赖于重载分辨率。

Practically speaking, it is unusual for a lambda expression to need to talk about itself (either to call itself recursively or to invoke its other methods), while it is more common to want to use names to refer to things in the enclosing class that would otherwise be shadowed (this, toString()). If it is necessary for a lambda expression to refer to itself (as if via this), a method reference or an anonymous inner class should be used instead. 实际上，lambda表达式需要谈论自己（以递归方式调用其自身或调用其其他方法）是不寻常的，而更常见的情况是希望使用名称来引用封闭类中的内容，否则会被阴影（this，toString()）遮盖。如果有必要让lambda表达式引用自身（如via this），则应改用方法引用或匿名内部类。

A block lambda body is void-compatible if every return statement in the block has the form return;. 如果该块中的每个return语句都具有形式，则该lambda主体是void兼容的return;。

A block lambda body is value-compatible if it cannot complete normally (§14.21) and every return statement in the block has the form return Expression;. 块 lambda body 的身体是价值兼容，如果它不能正常（完成§14.21），并在每块return语句的形式return 表达;

It is a compile-time error if a block lambda body is neither void-compatible nor value-compatible. 如果块lambda主体既不兼容void也不兼容值，则是编译时错误。

In a value-compatible block lambda body, the result expressions are any expressions that may produce an invocation's value. Specifically, for each statement of the form return Expression ; contained by the body, the Expression is a result expression. 在值兼容的块lambda主体中，结果表达式是可能产生调用值的任何表达式。具体地，对于形式的每个语句 return 表达 ;由所述主体包含的，该表达式 是一个结果的表达。

```
// The following lambda bodies are void-compatible: 以下lambda主体与void兼容：
() -> {}
() -> { System.out.println("done"); }
// These are value-compatible:这些是价值兼容的：
() -> { return "done"; }
() -> { if (...) return 1; else return 0; }
// These are both: 这些都是：
() -> { throw new RuntimeException(); }
() -> { while (true); }
// This is neither: 这都不是：
() -> { if (...) return "done"; System.out.println("done"); }
```
The handling of void/value-compatible and the meaning of names in the body jointly serve to minimize the dependency on a particular target type in the given context, which is useful both for implementations and for programmer comprehension. While expressions can be assigned different types during overload resolution depending on the target type, the meaning of unqualified names and the basic structure of the lambda body do not change. 无效/值兼容的处理和主体中名称的含义共同作用，以最小化给定上下文中对特定目标类型的依赖性，这对于实现和程序员理解都是有用的。尽管可以根据目标类型在重载解析期间为表达式分配不同的类型，但不限定名称的含义和lambda主体的基本结构不会改变。

Note that the void/value-compatible definition is not a strictly structural property: "can complete normally" depends on the values of constant expressions, and these may include names that reference constant variables. 请注意，void / value兼容的定义不是严格的结构属性：“可以正常完成”取决于常量表达式的值，并且这些表达式可能包含引用常量变量的名称。

Any local variable, formal parameter, or exception parameter used but not declared in a lambda expression must either be declared final or be effectively final (§4.12.4), or a compile-time error occurs where the use is attempted. 使用的但未在lambda表达式中声明的任何局部变量，形式参数或异常参数都必须声明final或有效地是最终的（第4.12.4节），否则在尝试使用时会发生编译时错误。

Any local variable used but not declared in a lambda body must be definitely assigned (§16 (Definite Assignment)) before the lambda body, or a compile-time error occurs. 必须在lambda主体之前明确分配任何已使用但未在lambda主体中声明的局部变量（第16节（Definite Assignment）），否则会发生编译时错误。

Similar rules on variable use apply in the body of an inner class (§8.1.3). The restriction to effectively final variables prohibits access to dynamically-changing local variables, whose capture would likely introduce concurrency problems. Compared to the final restriction, it reduces the clerical burden on programmers. 关于变量使用的类似规则也适用于内部类的主体（第8.1.3节）。对有效最终变量的限制禁止访问动态变化的局部变量，其捕获可能会引入并发问题。与final限制相比，它减少了程序员的文书负担。

The restriction to effectively final variables includes standard loop variables, but not enhanced-for loop variables, which are treated as distinct for each iteration of the loop (§14.14.2). 对有效最终变量的限制包括标准循环变量，但不包括增强for循环变量，对于循环的每次迭代，它们都被视为不同的变量（第14.14.2节）。

```
// The following lambda bodies demonstrate use of effectively final variables. 以下lambda主体演示了有效使用最终变量的方法。
void m1(int x) {
    int y = 1;
    foo(() -> x+y);
    // Legal: x and y are both effectively final. Legal：x和y都是有效的最终值。
}

void m2(int x) {
    int y;
    y = 1;
    foo(() -> x+y);
    // Legal: x and y are both effectively final. Legal：x和y都是有效的最终值。
}

void m3(int x) {
    int y;
    if (...) y = 1;
    foo(() -> x+y);
    // Illegal: y is effectively final, but not definitely assigned. 非法：y实际上是最终的，但未明确赋值。
}

void m4(int x) {
    int y;
    if (...) y = 1; else y = 2;
    foo(() -> x+y);
    // Legal: x and y are both effectively final. Legal：x和y都是有效的最终值。
}
```
```
void m5(int x) {
    int y;
    if (...) y = 1;
    y = 2;
    foo(() -> x+y);
    // Illegal: y is not effectively final. 非法：y实际上不是最终的。
}

void m6(int x) {
    foo(() -> x+1);
    x++;
    // Illegal: x is not effectively final. 非法：x实际上不是最终的。
}

void m7(int x) {
    foo(() -> x=1);
    // Illegal: x is not effectively final. 非法：x实际上不是最终的。
}

void m8() {
    int y;
    foo(() -> y=1);
    // Illegal: y is not definitely assigned before the lambda. 非法：y不一定在lambda之前赋值。
}

void m9(String[] arr) {
    for (String s : arr) {
        foo(() -> s);
        // Legal: s is effectively final  Legal：s实际上是最终的
        // (it is a new variable on each iteration) （这是每次迭代中的新变量）
    }
}

void m10(String[] arr) {
    for (int i = 0; i < arr.length; i++) {
        foo(() -> arr[i]);
        // Illegal: i is not effectively final 非法：i  实际上不是最终的
        // (it is not final, and is incremented) （不是最终值，并且是递增的）
    }
}
```

###  Type of a Lambda Expression Lambda表达式的类型

A lambda expression is compatible in an assignment context, invocation context, or casting context with a target type T if T is a functional interface type (§9.8) and the expression is congruent with the function type of the ground target type derived from T. 如果T是功能接口类型（第9.8节），并且表达式与从T派生的基础目标类型的功能类型一致，则 Lambda表达式在分配上下文，调用上下文或强制转换上下文中与目标类型T 兼容。

The ground target type is derived from T as follows: 的地面目标类型源自Ť如下：
- If T is a wildcard-parameterized functional interface type and the lambda expression is explicitly typed, then the ground target type is inferred as described in §18.5.3. 如果T是通配符参数化的功能接口类型，并且显式键入了lambda表达式，则将如§18.5.3中所述推断地面目标类型 。

- If T is a wildcard-parameterized functional interface type and the lambda expression is implicitly typed, then the ground target type is the non-wildcard parameterization (§9.9) of T. 如果Ť是一个通配符-参数化功能接口类型和lambda表达式隐式类型，则地面目标类型是非通配符的参数（§9.9）的Ť。

- Otherwise, the ground target type is T. 否则，地面目标类型是Ť。

A lambda expression is congruent with a function type if all of the following are true: 如果满足以下所有条件，则 lambda表达式与函数类型一致：

- The function type has no type parameters. 函数类型没有类型参数。

- The number of lambda parameters is the same as the number of parameter types of the function type. lambda参数的数量与函数类型的参数类型的数量相同。

- If the lambda expression is explicitly typed, its formal parameter types are the same as the parameter types of the function type. 如果lambda表达式是显式类型的，则其形式参数类型与函数类型的参数类型相同。

- If the lambda parameters are assumed to have the same types as the function type's parameter types, then: 如果假定lambda参数与函数类型的参数类型具有相同的类型，则：

    - If the function type's result is void, the lambda body is either a statement expression (§14.8) or a void-compatible block. 如果函数类型的结果为void，则lambda主体为语句表达式（第14.8节）或void-compatible块。

    - If the function type's result is a (non-void) type R, then either (i) the lambda body is an expression that is compatible with R in an assignment context, or (ii) the lambda body is a value-compatible block, and each result expression (§15.27.2) is compatible with R in an assignment context. 如果函数类型的结果是（非void）类型R，则（i）lambda主体是在赋值上下文中与R兼容的表达式，或者（ii）lambda主体是值兼容的块，并且在赋值上下文中，每个结果表达式（第15.27.2节）与R兼容。

If a lambda expression is compatible with a target type T, then the type of the expression, U, is the ground target type derived from T. 如果lambda表达式与目标类型T兼容，则表达式的类型U是从T派生的基础目标类型 。

It is a compile-time error if any class or interface mentioned by either U or the function type of U is not accessible (§6.6) from the class or interface in which the lambda expression appears. 它是一个编译时间错误，如果由任一提及的任何类或接口Ù或功能类型ü不可访问（6.6节）从类或接口，其中λ表达式出现。

For each non-static member method m of U, if the function type of U has a subsignature of the signature of m, then a notional method whose method type is the function type of U is deemed to override m, and any compile-time error or unchecked warning specified in §8.4.8.3 may occur. 对于每一个非static成员方法m的ü，如果功能类型ü具有的签名的子签名m，则名义方法，其方法类型的功能类型û被认为覆盖m，以及任何编译时错误或警告未检查可能会出现第8.4.8.3节中指定的情况。

A checked exception that can be thrown in the body of the lambda expression may cause a compile-time error, as specified in §11.2.3. 可能在lambda表达式的主体中引发的已检查异常可能会导致编译时错误，如§11.2.3中所指定 。

The parameter types of explicitly typed lambdas are required to exactly match those of the function type. While it would be possible to be more flexible - allow boxing or contravariance, for example - this kind of generality seems unnecessary, and is inconsistent with the way overriding works in class declarations. A programmer ought to know exactly what function type is being targeted when writing a lambda expression, so he should thus know exactly what signature must be overridden. (In contrast, this is not the case for method references, and so more flexibility is allowed when they are used.) In addition, more flexibility with parameter types would add to the complexity of type inference and overload resolution. 显式类型的lambda的参数类型必须与函数类型的参数类型完全匹配。虽然可能会更灵活-例如允许装箱或使用方差-这种通用性似乎是不必要的，并且与在类声明中重写工作的方式不一致。程序员在编写lambda表达式时应该确切地知道目标函数类型，因此他应该确切地知道必须重写哪个签名。（相反，方法引用不是这种情况，因此使用它们时可以提供更大的灵活性。）此外，

Note that while boxing is not allowed in a strict invocation context, boxing of lambda result expressions is always allowed - that is, the result expression appears in an assignment context, regardless of the context enclosing the lambda expression. However, if an explicitly typed lambda expression is an argument to an overloaded method, a method signature that avoids boxing or unboxing the lambda result is preferred by the most specific check (§15.12.2.5). 请注意，虽然在严格的调用上下文中不允许装箱，但始终允许对lambda结果表达式进行装箱-也就是说，无论包围lambda表达式的上下文如何，结果表达式都会出现在赋值上下文中。但是，如果显式类型的lambda表达式是重载方法的参数，则最具体的检查方法（避免对lambda结果进行装箱或装箱）的方法签名是首选的（第15.12.2.5节）。

If the body of a lambda is a statement expression (that is, an expression that would be allowed to stand alone as a statement), it is compatible with a void-producing function type; any result is simply discarded. So, for example, both of the following are legal: 如果lambda的主体是一个语句表达式（即，一个可以作为语句独立出现的表达式），则它与void-production函数类型兼容；任何结果都将被简单丢弃。因此，例如，以下两项都是合法的：

```
// Predicate has a boolean result 谓词具有boolean结果
java.util.function.Predicate<String> p = s -> list.add(s);
// Consumer has a void result 消费者有一个void结果
java.util.function.Consumer<String> c = s -> list.add(s);
```
Generally speaking, a lambda of the form () -> expr, where expr is a statement expression, is interpreted as either () -> { return expr; } or () -> { expr; }, depending on the target type. 一般而言，() -> expr形式的lambda（ 其中expr是语句表达式）根据目标类型解释为() -> { return expr; }或() -> { expr; }。
### Run-Time Evaluation of Lambda Expressions Lambda表达式的运行时评估

At run time, evaluation of a lambda expression is similar to evaluation of a class instance creation expression, insofar as normal completion produces a reference to an object. Evaluation of a lambda expression is distinct from execution of the lambda body. 在运行时，只要正常完成生成对对象的引用，对lambda表达式的求值就类似于对类实例创建表达式的求值。Lambda表达式的计算与Lambda主体的执行不同。

Either a new instance of a class with the properties below is allocated and initialized, or an existing instance of a class with the properties below is referenced. If a new instance is to be created, but there is insufficient space to allocate the object, evaluation of the lambda expression completes abruptly by throwing an _OutOfMemoryError_. 分配并初始化具有以下属性的类的新实例，或者引用具有以下属性的类的现有实例。如果要创建一个新实例，但没有足够的空间分配对象，则通过抛出来突然完成lambda表达式的求值OutOfMemoryError。

This implies that the identity of the result of evaluating a lambda expression (or, of serializing and deserializing a lambda expression) is unpredictable, and therefore identity-sensitive operations (such as reference equality (§15.21.3), object locking (§14.19), and the _System.identityHashCode_ method) may produce different results in different implementations of the Java programming language, or even upon different lambda expression evaluations in the same implementation. 这意味着评估lambda表达式（或对lambda表达式进行序列化和反序列化）的结果的身份是不可预测的，因此，身份敏感的操作（如引用相等（第15.21.3节），对象锁定（第14.19节））和 System.identityHashCode方法）可能会在Java编程语言的不同实现中甚至在同一实现中的不同lambda表达式求值时产生不同的结果。

The value of a lambda expression is a reference to an instance of a class with the following properties: lambda表达式的值是对具有以下属性的类的实例的引用：
- The class implements the targeted functional interface type and, if the target type is an intersection type, every other interface type mentioned in the intersection. 该类实现目标功能接口类型，如果目标类型是路口类型，则实现路口中提到的所有其他接口类型。

- Where the lambda expression has type U, for each non-static member method m of U: 对于每个U的非static 成员方法m， 其中lambda表达式的类型为U：
    - If the function type of U has a subsignature of the signature of m, then the class declares a method that overrides m. The method's body has the effect of evaluating the lambda body, if it is an expression, or of executing the lambda body, if it is a block; if a result is expected, it is returned from the method. 如果U的函数类型具有的签名的子签名m，则该类声明一个重写的方法m。该方法的主体具有评估lambda主体（如果是表达式）或执行lambda主体（如果是块）的作用；如果期望结果，则从方法中返回。

    - If the erasure of the type of a method being overridden differs in its signature from the erasure of the function type of U, then before evaluating or executing the lambda body, the method's body checks that each argument value is an instance of a subclass or subinterface of the erasure of the corresponding parameter type in the function type of U; if not, a ClassCastException is thrown. 如果对要重写的方法类型的擦除在签名上与对U函数类型的擦除不同，则在评估或执行lambda主体之前，该方法的主体将检查每个参数值是否是子类或子接口的实例U的函数类型中对应参数类型的擦除；如果不是，ClassCastException则抛出a。
- The class overrides no other methods of the targeted functional interface type or other interface types mentioned above, although it may override methods of the Object class. 该类不会覆盖目标功能接口类型或上述其他接口类型的其他方法，尽管它可以覆盖Object该类的方法。

These rules are meant to offer flexibility to implementations of the Java programming language, in that: 这些规则旨在通过以下方式为Java编程语言的实现提供灵活性：
- A new object need not be allocated on every evaluation. 不必在每次评估中分配一个新对象。

- Objects produced by different lambda expressions need not belong to different classes (if the bodies are identical, for example). 由不同的lambda表达式产生的对象不必属于不同的类（例如，如果主体相同）。

- Every object produced by evaluation need not belong to the same class (captured local variables might be inlined, for example). 评估产生的每个对象不必属于同一类（例如，可以内联捕获的局部变量）。

- If an "existing instance" is available, it need not have been created at a previous lambda evaluation (it might have been allocated during the enclosing class's initialization, for example). 如果“现有实例”可用，则不必在先前的lambda评估中创建它（例如，可能在封闭类的初始化期间分配了它）。

If the targeted functional interface type is a subtype of _java.io.Serializable_, the resulting object will automatically be an instance of a serializable class. Making an object derived from a lambda expression serializable can have extra run time overhead and security implications, so lambda-derived objects are not required to be serializable "by default". 如果目标功能接口类型是的子类型java.io.Serializable，则生成的对象将自动是可序列化类的实例。使从lambda表达式派生的对象可序列化会带来额外的运行时开销和安全隐患，因此，lambda派生的对象不需要“默认情况下”可序列化。


### Lambda表达式的语法
注意，lambda表达式看起来很像方法声明。您可以将lambda表达式视为匿名方法，即没有名称的方法。
Lambda表达式包含以下内容：
- 用括号括起来的形式参数的逗号分隔列表。
    - 可以省略lambda表达式中参数的数据类型。
    - 如果只有一个参数，则可以省略括号。
    - 不允许声明一个与局部变量同名的参数或者局部变量。（一个作用域）
- 箭头标记， ->
- 主体，由单个表达式或语句块组成。
    - 如果指定单个表达式，则Java运行时将评估该表达式，然后返回其值。另外，您可以使用return语句：
    ```
      p -> {
          return p.getGender() == Person.Sex.MALE
              && p.getAge() >= 18
              && p.getAge() <= 25;
      }
    ```
  - return语句不是表达式。在lambda表达式中，必须将语句括在大括号（{}）中。但是，您不必在括号中包含void方法调用。


- lambda表达式对封闭范围的局部变量具有相同的访问权。Lambda 表达式具有词法范围。这意味着它们不会从超类型继承任何名称，也不会引入新的作用域级别。解释lambda表达式中的声明就像在封闭环境中一样。
    - 因为lambda表达式未引入新的作用域范围。因此，您可以直接访问封闭范围的字段，方法和局部变量。

- 从lambda表达式引用的局部变量，必须是final或实际上是final

- 如何确定Lambda表达式的类型：
    - 当Java运行时调用方法时printPersons，它期望的数据类型为CheckPerson，因此lambda表达式为该类型。但是，当Java运行时调用方法时printPersonsWithPredicate，它期望的数据类型为Predicate<Person>，因此lambda表达式就是这种类型。这些方法期望的数据类型称为目标类型。为了确定lambda表达式的类型，Java编译器使用找到lambda表达式的上下文或情况的目标类型。因此，您只能在Java编译器可以确定目标类型的情况下使用lambda表达式：

- 对于方法参数，Java编译器使用其他两种语言功能确定目标类型：重载解析和类型参数推断。









































