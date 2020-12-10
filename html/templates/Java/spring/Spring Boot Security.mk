##### Hello World Spring Boot Security


创建Spring Security配置：

> configureGlobal方法的名称并不重要。然而，仅在与任何注释的类配置AuthenticationManagerBuilder是很重要的@EnableWebSecurity，@EnableGlobalMethodSecurity或@EnableGlobalAuthentication。否则会产生不可预测的结果。

> 自定义身份验证管理器：**AuthenticationManagerBuilder** 非常适合设置内存，JDBC或LDAP用户详细信息，或用于添加自定义UserDetailsService。以下是配置全局（父）的应用程序示例AuthenticationManager：

**认证**

> 身份验证的主要策略接口 **AuthenticationManager** 只有一个方法：**authenticate**

```
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
			.authorizeRequests()
				.antMatchers("/css/**", "/index").permitAll()		
				.antMatchers("/user/**").hasRole("USER")			
				.and()
			.formLogin()
				.loginPage("/login").failureUrl("/login-error");	
	}

	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		auth
			.inMemoryAuthentication()
				.withUser("user").password("password").roles("USER");
	}
}
```
> 请注意，它AuthenticationManagerBuilder是@Autowired一个方法@Bean- 这是使它构建全局（父）的方法AuthenticationManager。相反，如果我们这样做：

```
@Configuration
public class ApplicationSecurity extends WebSecurityConfigurerAdapter {

  @Autowired
  DataSource dataSource;

   ... // web stuff here

  @Override
  public configure(AuthenticationManagerBuilder builder) {
    builder.jdbcAuthentication().dataSource(dataSource).withUser("dave")
      .password("secret").roles("USER");
  }

}
```

> 使用@Override配置器中的方法）然后AuthenticationManagerBuilder仅用于构建“本地” AuthenticationManager，它是全局的子节点。在Spring Boot应用程序中，您可以@Autowired将全局应用程序转换为另一个bean，但除非您自己明确地公开它，否则不能使用本地bean。

> Spring Boot提供了一个默认的全局AuthenticationManager（只有一个用户），除非你通过提供自己的bean类型来抢占它AuthenticationManager。除非您主动需要自定义全局，否则默认设置足够安全，您不必担心它AuthenticationManager。如果您执行任何构建的配置，AuthenticationManager您通常可以在本地执行您正在保护的资源，而不必担心全局默认值。

**授权或访问控制**

> 一旦身份验证成功，我们就可以继续授权，这里的核心策略是AccessDecisionManager。框架提供了三个实现，并且所有三个委托给一个链AccessDecisionVoter，有点像ProviderManager委托AuthenticationProviders。

> 一个AccessDecisionVoter考虑的Authentication（表示主体）和一个安全的Object，其作为装饰有ConfigAttributes：

```
boolean supports(ConfigAttribute attribute);

boolean supports(Class<?> clazz);

int vote(Authentication authentication, S object,
        Collection<ConfigAttribute> attributes);
```

> 该Object是的签名完全通用的，AccessDecisionManager并且AccessDecisionVoter-它代表什么，用户可能要访问（网络资源或在一个Java类中的方法是两种最常见的情况）。该ConfigAttributes也相当一般，较安全的装修Object用一些确定的权限来访问它所需的水平的元数据。ConfigAttribute是一个接口，但它只有一个非常通用的方法并返回一个String，所以这些字符串以某种方式编码资源所有者的意图，表达允许谁访问它的规则。典型的ConfigAttribute是用户角色的名称（如ROLE_ADMIN或ROLE_AUDIT），它们通常具有特殊格式（如ROLE_ 前缀）或表示需要评估的表达式。

**网络安全**

> Spring Security作为Filter链中的单个安装，其概念类型是FilterChainProxy由于很快就会显现的原因。在Spring Boot应用程序中，安全过滤器@Bean位于ApplicationContext，并且默认安装它，以便它应用于每个请求。它安装在一个定义的位置SecurityProperties.DEFAULT_FILTER_ORDER，该位置依次锚定FilterRegistrationBean.REQUEST_WRAPPER_FILTER_MAX_ORDER（Spring Boot应用程序期望过滤器在包装请求时修改其行为的最大顺序）。除此之外还有更多：从容器的角度来看，Spring Security是一个单独的过滤器，但在其中有一些额外的过滤器，每个过滤器都扮演着特殊的角色。这是一张图片：

> 创建和自定义筛选链
Spring Boot应用程序（带有/**请求匹配器的应用程序）中的默认回退过滤器链具有预定义的顺序SecurityProperties.BASIC_AUTH_ORDER。您可以通过设置完全关闭它security.basic.enabled=false，或者您可以将其用作后备，只需使用较低的顺序定义其他规则。要做到这一点，只需添加一个@Bean类型WebSecurityConfigurerAdapter（或WebSecurityConfigurer）并用它来装饰类@Order。例：

```
@Configuration
@Order(SecurityProperties.BASIC_AUTH_ORDER - 10)
public class ApplicationConfigurerAdapter extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.antMatcher("/foo/**")
     ...;
  }
}
```
> 此bean将导致Spring Security添加新的过滤器链并在回退之前对其进行排序。
与另一组资源相比，许多应用程序对一组资源具有完全不同的访问规则。例如，承载UI和支持API的应用程序可能支持基于cookie的身份验证，其中重定向到UI部件的登录页面，而基于令牌的身份验证具有401响应未经身份验证的API部件请求。每组资源都有自己WebSecurityConfigurerAdapter的独特订单和自己的请求匹配器。如果匹配规则重叠，则最早的有序过滤器链将获胜。

**方法安全**

除了支持保护Web应用程序外，Spring Security还支持将访问规则应用于Java方法执行。

启用方法安全性

```
@SpringBootApplication
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SampleSecureApplication {
}
```

装饰方法资源

```
@Service
public class MyService {

  @Secured("ROLE_USER")
  public String secure() {
    return "Hello Security";
  }

}
```

> 此示例是具有安全方法的服务。如果Spring创建了@Bean这种类型，那么它将被代理，并且调用者必须在实际执行该方法之前通过安全拦截器。如果访问被拒绝，则调用者将获得AccessDeniedException而不是实际的方法结果。

> 有可以在方法中使用以执行安全性约束，特别是其他注释@PreAuthorize和@PostAuthorize，它允许你写含有以分别方法参数和返回值引用的表达式。


**经过身份验证的主体**

Spring Security基本上是线程绑定的，因为它需要使当前经过身份验证的主体可供各种下游消费者使用。

```
SecurityContext context = SecurityContextHolder.getContext();
Authentication authentication = context.getAuthentication();
User = (User) authentication.getPrincipal();
assert(authentication.isAuthenticated);
```

HttpServletRequest 类
> getRemoteUser 方法：如果用户已经过身份验证，或者null用户未经过身份验证，则返回发出此请求的用户的登录名。与CGI变量REMOTE_USER的值相同。

> isUserInRole 方法：返回一个布尔值，指示经过身份验证的用户是否包含在指定的逻辑“角色”中。可以使用部署描述符定义角色和角色成员身份。如果用户尚未通过身份验证，则返回该方法false。

> getUserPrincipal 方法：返回java.security.Principal包含当前经过身份验证的用户的名称的对象。如果用户尚未通过身份验证，则返回该方法null。

> login 方法：在为其配置的Web容器登录机制使用的密码验证域中验证提供的用户名和密码

> logout 方法：建立null作为值返回时 getUserPrincipal，getRemoteUser和getAuthType被称为该请求。

HttpSecurity 类

A HttpSecurity类似于命名空间配置中的Spring Security的XML <http>元素。它允许为特定的http请求配置基于Web的安全性。默认情况下，它将应用于所有请求，但可以使用requestMatcher(RequestMatcher)或其他类似方法进行限制 。

> authorizeRequests()：允许根据 HttpServletRequest 使用 限制访问。
>
> csrf()：添加CSRF支持。
>
> httpBasic()：配置HTTP基本身份验证。
>
> rememberMe()：允许配置Remember Me身份验证。允许基于令牌的记住我的身份验证。在验证是否存在名为“remember-me”的HTTP参数时，即使用户HttpSession过期，也会记住该用户 。
>
> formLogin() ：指定支持基于表单的身份验证。
> > 如果 FormLoginConfigurer.loginPage(String)未指定，则将生成默认登录页面。
> > .failureForwardUrl()转发认证失败处理程序。
> > .successForwardUrl()转发认证成功处理程序
> > .passwordParameter(String)执行身份验证时查找密码的HTTP参数。默认为“password”。
> > .usernameParameter(String)执行身份验证时查找用户名的HTTP参数。默认为“username”。
>
> logout（）：提供注销支持。
> > .logoutUrl()触发注销的URL（默认为“/ logout”）。
> >
> > .logoutSuccessUrl(“” )注销后重定向到的URL。
> >
> > .deleteCookies("cookieNamesToClear")允许指定在注销成功时删除的cookie的名称。
>
> sessionManagement()：允许配置会话管理。例：.sessionManagement().maximumSessions(1).expiredUrl("/login?expired")强制一次只验证用户的单个实例。如果用户使用用户名“user”进行身份验证而未注销，并且尝试使用“user”进行身份验证，则第一个会话将被强制终止并发送到“/ login？expired”URL。
>
>  servletApi（）：将HttpServletRequest方法与在上面找到的值 集成SecurityContext。

SecurityContext 接口

> 定义与当前执行线程关联的最小安全信息的接口

> getAuthentication() ：获取当前经过身份验证的主体或身份验证请求令牌。
>
> setAuthentication(Authentication authentication)：更改当前已验证的主体，或删除身份验证信息。

AuthenticationManagerBuilder 类

> 	authenticationProvider：根据AuthenticationProvider传入的自定义添加身份验证。


Authentication 接口

> 当前经过身份验证的主体或身份验证请求令牌。
>
> 一旦请求被方法处理，表示身份验证请求或经过身份验证的主体的令牌 AuthenticationManager.authenticate(Authentication)。
>
> 一旦请求被认证，认证通常将存储在由正在使用的认证机制管理 的线程本地SecurityContext中SecurityContextHolder。通过创建Authentication实例并使用代码，可以实现显式身份验证，而无需使用Spring Security的身份验证机制之一：
>
>  SecurityContextHolder.getContext（）setAuthentication（anAuthentication）。

> getAuthorities（）：授予委托人的权限，或者如果令牌未经过身份验证，则为空集合。永远不会。
>
> getDetails（）：存储有关身份验证请求的其他详细信息 这些可能是IP地址，证书序列号等。
>
> getPrincipal（）：被验证的委托人的身份。对于使用用户名和密码的身份验证请求，这将是用户名。呼叫者应填充身份验证请求的主体。
该AuthenticationManager会执行通常会返回一个 验证含有作为主要供应用程序使用更丰富的信息。许多身份验证提供程序将创建一个 UserDetails对象作为主体。
>
>  isAuthenticated（）：如果令牌已经过身份验证，并且AbstractSecurityInterceptor不需要AuthenticationManager再次将令牌呈现 给重新身份验证，则为true 。


公共接口 AuthenticationProvider

> 表示类可以处理特定的 Authentication实现。

> authenticate(Authentication authentication)：尝试对传递的Authentication对象进行身份验证，Authentication如果成功则返回完全填充的对象（包括授予的权限也就是 凭据）。




#### Spring安全参考


