## Lambda Expressions

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
Unlike code appearing in anonymous class declarations, the meaning of names and the this and super keywords appearing in a lambda body, along with the accessibility of referenced declarations, are the same as in the surrounding context (except that lambda parameters introduce new names).

The transparency of this (both explicit and implicit) in the body of a lambda expression - that is, treating it the same as in the surrounding context - allows more flexibility for implementations, and prevents the meaning of unqualified names in the body from being dependent on overload resolution.

Practically speaking, it is unusual for a lambda expression to need to talk about itself (either to call itself recursively or to invoke its other methods), while it is more common to want to use names to refer to things in the enclosing class that would otherwise be shadowed (this, toString()). If it is necessary for a lambda expression to refer to itself (as if via this), a method reference or an anonymous inner class should be used instead.

A block lambda body is void-compatible if every return statement in the block has the form return;.

A block lambda body is value-compatible if it cannot complete normally (§14.21) and every return statement in the block has the form return Expression;.

It is a compile-time error if a block lambda body is neither void-compatible nor value-compatible.

In a value-compatible block lambda body, the result expressions are any expressions that may produce an invocation's value. Specifically, for each statement of the form return Expression ; contained by the body, the Expression is a result expression.

```
// The following lambda bodies are void-compatible:
() -> {}
() -> { System.out.println("done"); }
// These are value-compatible:
() -> { return "done"; }
() -> { if (...) return 1; else return 0; }
// These are both:
() -> { throw new RuntimeException(); }
() -> { while (true); }
// This is neither:
() -> { if (...) return "done"; System.out.println("done"); }
```
The handling of void/value-compatible and the meaning of names in the body jointly serve to minimize the dependency on a particular target type in the given context, which is useful both for implementations and for programmer comprehension. While expressions can be assigned different types during overload resolution depending on the target type, the meaning of unqualified names and the basic structure of the lambda body do not change.

Note that the void/value-compatible definition is not a strictly structural property: "can complete normally" depends on the values of constant expressions, and these may include names that reference constant variables.

Any local variable, formal parameter, or exception parameter used but not declared in a lambda expression must either be declared final or be effectively final (§4.12.4), or a compile-time error occurs where the use is attempted.

Any local variable used but not declared in a lambda body must be definitely assigned (§16 (Definite Assignment)) before the lambda body, or a compile-time error occurs.

Similar rules on variable use apply in the body of an inner class (§8.1.3). The restriction to effectively final variables prohibits access to dynamically-changing local variables, whose capture would likely introduce concurrency problems. Compared to the final restriction, it reduces the clerical burden on programmers.

The restriction to effectively final variables includes standard loop variables, but not enhanced-for loop variables, which are treated as distinct for each iteration of the loop (§14.14.2).

```
// The following lambda bodies demonstrate use of effectively final variables.
void m1(int x) {
    int y = 1;
    foo(() -> x+y);
    // Legal: x and y are both effectively final.
}

void m2(int x) {
    int y;
    y = 1;
    foo(() -> x+y);
    // Legal: x and y are both effectively final.
}

void m3(int x) {
    int y;
    if (...) y = 1;
    foo(() -> x+y);
    // Illegal: y is effectively final, but not definitely assigned.
}

void m4(int x) {
    int y;
    if (...) y = 1; else y = 2;
    foo(() -> x+y);
    // Legal: x and y are both effectively final.
}
```
```
void m5(int x) {
    int y;
    if (...) y = 1;
    y = 2;
    foo(() -> x+y);
    // Illegal: y is not effectively final.
}

void m6(int x) {
    foo(() -> x+1);
    x++;
    // Illegal: x is not effectively final.
}

void m7(int x) {
    foo(() -> x=1);
    // Illegal: x is not effectively final.
}

void m8() {
    int y;
    foo(() -> y=1);
    // Illegal: y is not definitely assigned before the lambda.
}

void m9(String[] arr) {
    for (String s : arr) {
        foo(() -> s);
        // Legal: s is effectively final
        // (it is a new variable on each iteration)
    }
}

void m10(String[] arr) {
    for (int i = 0; i < arr.length; i++) {
        foo(() -> arr[i]);
        // Illegal: i is not effectively final
        // (it is not final, and is incremented)
    }
}
```









































































