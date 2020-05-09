## Lambda Expressions
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









































































