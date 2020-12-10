#### Apache Shiro
Apache Shiro（发音为“shee-roh”，日语中的'castle'）是一个功能强大且易于使用的Java安全框架，可执行身份验证，授权，加密和会话管理，并可用于保护任何应用程序。
##### 核心概念：Subject, SecurityManager, and Realms

###### Subject
Subject这个词是一个安全术语，基本上是指“当前正在执行的用户”。它只是不被称为“用户”，因为“用户”这个词通常与人类有关。在安全的世界，术语“主题”可以指一个人，但也有可能是会谈进程，守护进程帐户，或任何类似。它只是意味着“当前与软件交互的东西”。可以将其视为Shiro的“用户”概念。可以在代码中的任何位置轻松获取Shiro Subject。

例如：

```
import org.apache.shiro.subject.Subject;
import org.apache.shiro.SecurityUtils;
...
Subject currentUser = SecurityUtils.getSubject();
```
获得 Subject 后，您可以立即访问当前用户希望使用Shiro执行的所有操作的90％，例如登录，注销，访问其会话，执行授权检查等等

###### SecurityManager 安全管理器
Subject 的“幕后”对应物是SecurityManager。当Subject表示当前用户的安全操作时，SecurityManager管理所有用户的安全操作。它是Shiro架构的核心，充当一种“伞形”对象，它引用了许多形成对象图的内部嵌套安全组件。但是，一旦配置了SecurityManager及其内部对象图，通常就会将其保留，应用程序开发人员几乎将所有时间花在Subject API上。


###### Realms
Shiro的第三个也是最后一个核心概念是一个领域。Realm充当Shiro与应用程序安全数据之间的“桥接”或“连接器”。也就是说，当实际与安全相关的数据（如用户帐户）进行交互以执行身份验证（登录）和授权（访问控制）时，Shiro会从为应用程序配置的一个或多个领域中查找许多这些内容。

从这个意义上讲，Realm本质上是一个特定于安全性的DAO：它封装了数据源的连接细节，并根据需要使相关数据可用于Shiro。配置Shiro时，必须至少指定一个Realm用于身份验证和/或授权。可以配置多个Realm，但至少需要一个。

Shiro提供了开箱即用的Realms，可以连接到许多安全数据源（也称为目录），如LDAP，关系数据库（JDBC），文本配置源（如INI和属性文件等）。如果默认域不符合您的需要，您可以插入自己的Realm实现来表示自定义数据源。

###### 认证
身份验证是验证用户身份的过程。也就是说，当用户使用应用程序进行身份验证时，他们证明他们实际上是他们所说的人。这有时也被称为“登录”。这通常是一个三步过程。
1. 收集用户的标识信息，称为主体，并支持身份证明，称为凭证。
2. 将主体和凭据提交给系统。
3. 如果提交的凭据与系统对该用户标识（主体）的期望值匹配，则认为该用户已通过身份验证。如果它们不匹配，则不会将用户视为已通过身份验证。

Shiro有一个以 Subject 为中心的API - 几乎所有你在运行时用Shiro做的事都是通过与当前正在执行的 Subject 进行交互来实现的。因此，要登录 Subject ，只需调用其登录方法，传递一个AuthenticationToken实例，该实例表示提交的主体和凭据（在本例中为用户名和密码）。

例如：

```
//1. Acquire submitted principals and credentials:
AuthenticationToken token =
new UsernamePasswordToken(username, password);

//2. Get the current Subject:
Subject currentUser = SecurityUtils.getSubject();

//3. Login:
currentUser.login(token);
```
如您所见，Shiro的API很容易反映出常见的工作流程。您将继续将此简单性视为所有主题操作的主题。调用login方法时，SecurityManager将接收AuthenticationToken并将其分派给一个或多个已配置的域，以允许每个域根据需要执行身份验证检查。每个Realm都能够根据需要对提交的AuthenticationTokens做出反应。

如果登录尝试失败会发生什么？如果用户指定了错误的密码该怎么办？您可以通过对Shiro的运行时AuthenticationException作出反应来处理故障

可以选择捕获其中一个AuthenticationException子类并进行具体反应。

在成功登录主题后，它们将被视为已通过身份验证，通常您允许它们使用您的应用程序。但仅仅因为用户证明了他们的身份并不意味着他们可以在您的应用程序中做任何他们想做的事情。这引出了下一个问题，“我如何控制允许用户做什么？”决定允许用户做什么称为 Authorization （授权）。

###### Authorization
授权本质上是访问控制 - 控制用户可以在应用程序中访问的内容，例如资源，网页等。大多数用户通过使用角色和权限等概念来执行访问控制。也就是说，通常允许用户基于分配给他们的角色和/或许可来做某事或不做某事。然后，您的应用程序可以根据对这些角色和权限的检查来控制公开的功能。正如您所料，Subject API允许您非常轻松地执行角色和权限检查。

例如：

```
//角色检查
if ( subject.hasRole(“administrator”) ) {
    //show the ‘Create User’ button
} else {
    //grey-out the button?
} 
```
**Permission （权限）**

为此，Shiro支持其 Permission （权限） 概念。权限是一个原始的功能声明，例如“打开一扇门”，“创建一个博客条目”，“删除'jsmith'用户'等。通过拥有反映应用程序原始功能的权限，您只需要更改权限更改应用程序的功能时检查。反过来，您可以在运行时根据需要为角色或用户分配权限。

例如：

```
//权限检查
if ( subject.isPermitted(“user:create”) ) {
    //show the ‘Create User’ button
} else {
    //grey-out the button?
} 
```
“user：create”字符串是遵循某些解析约定的权限字符串的示例。Shiro通过WildcardPermission开箱即用，支持这种约定。instance-level

WildcardPermission在创建安全策略时非常灵活，甚至支持instance-level (实例级)访问控制等内容。

例如：

```
//实例级权限检查
if ( subject.isPermitted(“user:create:jsmith”) ) {
    //show the ‘Create User’ button
} else {
    //grey-out the button?
} 
```

###### Session Management 会话管理
Subject 的 Session ：

```
Session session = subject.getSession（）; 
//该参数确定是否将创建新的Session（如果它尚不存在）
Session session = subject.getSession（boolean create）;
```

###### Cryptography 加密
密码学是隐藏或混淆数据的过程，因此窥探眼睛无法理解它。Shiro在加密方面的目标是简化并使JDK的加密支持变得可用。

重要的是要注意密码学一般不是特定于受试者，因此它是Shiro API的一个非特定主题的区域。您可以在任何地方使用Shiro的加密支持，即使没有使用主题。Shiro真正关注其加密支持的两个领域是加密哈希（也称为消息摘要）和加密密码。

Shiro简化了散列和编码的程度。


###### 下面是实际代码：

- 认证 Subjects
    - 第1步：收集主题的主体和凭据

```
//Example using most common scenario of username/password pair:
UsernamePasswordToken token = new UsernamePasswordToken(username, password);

//"Remember Me" built-in: 
token.setRememberMe(true);
```

> 这里需要注意的是，Shiro并不关心如何获取这些信息：数据可能是由提交HTML表单的用户获取的，也可能是从HTTP头中检索的，或者可能是从Swing或Flex中读取的GUI密码表单，或者可能通过命令行参数。

-
    - 第2步：提交委托人和凭证

```
Subject currentUser = SecurityUtils.getSubject();
//对login方法的调用表示认证尝试。
currentUser.login(token);
```
> 在收集了主体和凭据并将其表示为AuthenticationToken实例之后，我们需要将令牌提交给Shiro以执行实际的身份验证尝试。

-
    - 第3步：处理成功或失败
>     Shiro具有丰富的运行时AuthenticationException层次结构，可以准确指示尝试失败的原因。


-
    - 第4步：注销

```
//removes all identifying information and invalidates their session too.
currentUser.logout(); 

```

>    调用 logout 时，任何现有的Session将被取消，并且任何身份将被取消关联（例如，在Web应用程序中，RememberMe cookie也将被删除）。强烈建议在调用后立即将最终用户重定向到新的视图或页面


###### Realm

实现 AuthenticatingRealm 覆盖 doAuthenticationInfo 方法
```

```
