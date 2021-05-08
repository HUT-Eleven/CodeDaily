---
typora-copy-images-to: ./images
typora-root-url: ./images
---

# 四、web开发

[SpringBoot-API](https://spring.io/projects/spring-boot#learn)

## 2、静态资源映射规则

```java
//ResourceProperties设置了静态资源相关的参数，缓存时间等
@ConfigurationProperties(prefix = "spring.resources", ignoreUnknownFields = false)
public class ResourceProperties implements ResourceLoaderAware, InitializingBean {
```

```java
//静态资源文件映射规则-源码
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
   if (!this.resourceProperties.isAddMappings()) {
      logger.debug("Default resource handling disabled");
      return;
   }
    //第一种：/webjars/**
   Integer cachePeriod = this.resourceProperties.getCachePeriod();
   if (!registry.hasMappingForPattern("/webjars/**")) {
      customizeResourceHandlerRegistration(registry
            .addResourceHandler("/webjars/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/")
            .setCachePeriod(cachePeriod));
   }
     //第二种：/**
   String staticPathPattern = this.mvcProperties.getStaticPathPattern();
   if (!registry.hasMappingForPattern(staticPathPattern)) {
      customizeResourceHandlerRegistration(
            registry.addResourceHandler(staticPathPattern)
                  .addResourceLocations(
                        this.resourceProperties.getStaticLocations())
                  .setCachePeriod(cachePeriod));
   }
}
```

### 1、/webjars/**

1)、所有的/webjars/**，都到classpath:/META-INF/resources/webjars/找资源（==注：这里的classpath是子jquery-3.3.1-1.jar自身的classpath，所以是在自身jar中查找，并不是到我们/BOOT-INF/classes下查找==）；

[webjars官网](http://www.webjars.org/)

![12.jquery](.\12.jquery.jpg)

举例说明：

如果访问localhost:8080/==webjars/jquery/3.3.1/jquery.js==，
路径丧/webjars，会被springboot标识，所以会去classpath:/META-INF/resources/webjars/中查找==jquery/3.3.1/jquery.js==

### 2、/**

> 拦截所有

**静态资源文件夹：**

```properties
"classpath:/META-INF/resources/", 
"classpath:/resources/",
"classpath:/static/", 
"classpath:/public/",
"/";当前项目的根路径
```

![13.static](./13.static.jpg)





**访问时不需要带/public、/static、/resources**

<img src=".\14.static-css.jpg" alt="14.static-css" style="zoom:67%;" />

### 设置首页

静态资源文件夹下的index.html页面被“/**”映射（但不能放在子文件夹中）；

localhost:8080/  -->index页面

```JAVA
@Bean
public WelcomePageHandlerMapping welcomePageHandlerMapping(
      ResourceProperties resourceProperties) {
   return new WelcomePageHandlerMapping(resourceProperties.getWelcomePage(),
         this.mvcProperties.getStaticPathPattern());
}
```

### 设置favicon图标

```java
//源码
@Configuration
@ConditionalOnProperty(value = "spring.mvc.favicon.enabled", matchIfMissing = true)
public static class FaviconConfiguration {

   private final ResourceProperties resourceProperties;

   public FaviconConfiguration(ResourceProperties resourceProperties) {
      this.resourceProperties = resourceProperties;
   }

   @Bean
   public SimpleUrlHandlerMapping faviconHandlerMapping() {
      SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();
      mapping.setOrder(Ordered.HIGHEST_PRECEDENCE + 1);
	  //任何favicon.ico的图标都在静态文件夹下找
      mapping.setUrlMap(Collections.singletonMap("**/favicon.ico",
            faviconRequestHandler()));
      return mapping;
   }

   @Bean
   public ResourceHttpRequestHandler faviconRequestHandler() {
      ResourceHttpRequestHandler requestHandler = new ResourceHttpRequestHandler();
      requestHandler
            .setLocations(this.resourceProperties.getFaviconLocations());
      return requestHandler;
   }
}
```



## 3、模板引擎

> 像JSP、thymeleaf都是模板引擎，

<img src=".\1592121849629.png" alt="1592121849629" style="zoom:50%;" />

### 1、引入thymeleaf 3

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

> **1.5.19默认导入thymeleaf2，版本太低 所以使用thymeleaf3.**
>
> **2.1.3默认导入thymeleaf3.0.11.RELEASE，可以不更改了**
>
> 这些东西最好看github推荐的开发版本
>

[官方导入办法](https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#howto-use-thymeleaf-3)

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
    <!--thymeleaf 3的导入-->
    <thymeleaf.version>3.0.9.RELEASE</thymeleaf.version>
    <!--布局功能支持 同时支持thymeleaf3主程序 layout2.0以上版本  -->
    <!--布局功能支持 同时支持thymeleaf2主程序 layout1.0以上版本  -->
    <thymeleaf-layout-dialect.version>2.2.2</thymeleaf-layout-dialect.version>
</properties>
```

### 2、Thymeleaf使用和语法

```java
//源码
@ConfigurationProperties(prefix = "spring.thymeleaf")
public class ThymeleafProperties {

   private static final Charset DEFAULT_ENCODING = Charset.forName("UTF-8");

   private static final MimeType DEFAULT_CONTENT_TYPE = MimeType.valueOf("text/html");

   //默认前缀，等价于视图解析器的前缀
   public static final String DEFAULT_PREFIX = "classpath:/templates/";
	//默认后缀
   public static final String DEFAULT_SUFFIX = ".html";
```

 栗子：

```java
@RequestMapping("/success")
    public String success() {
    return "thyme";
}
//返回classpath:/templates/thyme.html
```

使用：

只要把HTML页面放到classpath:/templates/,thymeleaf模板引擎就能自动渲染（即把数据填进页面中，填充前后缀等等）；

1、导入thymeleaf的名称空间

```html
<html xmlns:th="http://www.thymeleaf.org">    
```



### 3、语法规则

#### **1)、标签**

th:任意html属性：替换原生的任何属性**，比如：

```html
<div id="testid" class="testcalss" th:id="${Lion}" th:class="${Lion}" th:text="${hello}">
	前端数据
</div>
作用：直接访问html和通过thymeleaf引擎渲染后的内容不一样了，且前后端可以做到互不影响。
```

**thymeleaf标签表**：

|      | 功能                            | 标签                                 | 功能和jsp对比                                   |
| ---- | ------------------------------- | ------------------------------------ | ----------------------------------------------- |
| 1    | Fragment inclusion              | th:insert th:replace                 | include(片段包含)                               |
| 2    | Fragment iteration              | th:each                              | c:forEach(遍历)                                 |
| 3    | Conditional evaluation          | th:if th:unless th:switch th:case    | c:if(条件判断)                                  |
| 4    | Local variable definition       | th:object  th:with                   | c:set(声明变量)                                 |
| 5    | General attribute modification  | th:attr th:attrprepend th:attrappend | 属性修改支持前面和后面追加内容                  |
| 6    | Specific attribute modification | th:value th:href th:src ...          | 修改任意属性值                                  |
| 7    | Text (tag body modification)    | th:text th:utext                     | 修改标签体内容<br />utext：不转义字符<h1>大标题 |
| 8    | Fragment specification          | th:fragment                          | 声明片段                                        |
| 9    | Fragment removal                | th:remove                            |                                                 |

内联写法注意需要在body上加上 th:inline="text"敲黑板，不然不起作用

```html
<body class="text-center" th:inline="text"></body>
```

th标签的访问优先级

Order Feature Attributes

 **3）、表达式语法**

**五种：${}、*{}、#{}、@{}、~{}**

```properties
一、Variable Expressions: ${...}
    	1、获取对象属性、调用方法
    	2、使用内置基本对象：
    	    #ctx : the context object.
            #vars: the context variables.
            #locale : the context locale.
            #request : (only in Web Contexts) the HttpServletRequest object.
            #response : (only in Web Contexts) the HttpServletResponse object.
            #session : (only in Web Contexts) the HttpSession object.
            #servletContext : (only in Web Contexts) the ServletContext object.
         3、内置一些工具对象
        	#execInfo : information about the template being processed.
        	#messages : methods for obtaining externalized messages inside variables expressions, in the same way as they
            would be obtained using #{…} syntax.
            #uris : methods for escaping parts of URLs/URIs
            #conversions : methods for executing the configured conversion service (if any).
            #dates : methods for java.util.Date objects: formatting, component extraction, etc.
            #calendars : analogous to #dates , but for java.util.Calendar objects.
            #numbers : methods for formatting numeric objects.
            #strings : methods for String objects: contains, startsWith, prepending/appending, etc.
            #objects : methods for objects in general.
            #bools : methods for boolean evaluation.
            #arrays : methods for arrays.
            #lists : methods for lists.
            #sets : methods for sets.
            #maps : methods for maps.
            #aggregates : methods for creating aggregates on arrays or collections.
            #ids : methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).
二、Selection Variable Expressions: *{...} //选择表达式：和${}功能一样，补充功能
   # 配合th:object使用，object=${object} 以后获取就可以使用*{a}  相当于${object.a}
  	    <div th:object="${session.user}">
            <p>Name: <span th:text="*{firstName}">Sebastian</span>.</p>
            <p>Surname: <span th:text="*{lastName}">Pepper</span>.</p>
            <p>Nationality: <span th:text="*{nationality}">Saturn</span>.</p>
		</div>
三、Message Expressions: #{...} //获取国际化内容
四、Link URL Expressions: @{...} //定义URL链接
    	#<a href="details.html" th:href="@{/order/details(orderId=${o.id})}">view</a>
五、Fragment Expressions: ~{...}//引入片段文档

####------------###-----------####---
Literals（字面量）
    Text literals: 'one text' , 'Another one!' ,…
    Number literals: 0 , 34 , 3.0 , 12.3 ,…
    Boolean literals: true , false
    Null literal: null
    Literal tokens: one , sometext , main ,…
Text operations:(文本操作)
    String concatenation: +
    Literal substitutions: |The name is ${name}|
Arithmetic operations:（数学运算）
    Binary operators: + , - , * , / , %
    Minus sign (unary operator): -
Boolean operations:（布尔运算）
    Binary operators: and , or
    Boolean negation (unary operator): ! , not
Comparisons and equality:（比较运算）
    Comparators: > , < , >= , <= ( gt , lt , ge , le )
    Equality operators: == , != ( eq , ne )
Conditional operators:（条件运算）
    If-then: (if) ? (then)
    If-then-else: (if) ? (then) : (else)
    Default: (value) ?: (defaultvalue)
Special tokens:（空操作）
	No-Operation: _
```

inline写法（行内写法）

```html
[[]] -->th:text
[()] -->th:utext
```



## 4、SpringMVC自动配置

### 1、SpringMVC的自动导入

[Spring框架的自动配置](https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#boot-features-developing-web-applications)

以下是SpringBoot对SpringMVC的默认配置“**WebMvcAutoConfiguration**”

- Inclusion of `ContentNegotiatingViewResolver` and `BeanNameViewResolver` beans.

  - 自动配置了ViewResolver(视图解析器：根据方法的返回值得到视图对象（View）,视图对象决定如何渲染（转发？重定向？等等）)
  - `ContentNegotiatingViewResolver`组合所有视图解析器
  - 如何定制：我们可以自己给容器中添加一个视图解析器；自动将其整合进来

- Support for serving static resources, including support for WebJars (see below).--静态资源配置

- Static `index.html` support.--主页配置

- Custom `Favicon` support (see below).--favicon.ico配置

- 自动注册 了`Converter`, `GenericConverter`, `Formatter` beans.

  - `Converter`：类型转换 文本转为字面量

  - `Formatter` ：格式化器 转换后格式转换

    ```java
    @Bean
    @ConditionalOnProperty(prefix = "spring.mvc", name = "date-format")//在文件配置格式化的规则
    public Formatter<Date> dateFormatter() {
       return new DateFormatter(this.mvcProperties.getDateFormat());//日期格式化组件
    }
    ```

    自己添加的格式化转换器，只需要放在容器中即可

- Support for `HttpMessageConverters` (see below).

  - `HttpMessageConverters` ：转换HTTP转换和响应：User - json

  - `HttpMessageConverters` ：是从容器中确定；获取所有的`HttpMessageConverters`  ，将自己的组件注册在容器中@Bean 

  - If you need to add or customize converters you can use Spring Boot’s `HttpMessageConverters` class:

    ```java
    import org.springframework.boot.autoconfigure.web.HttpMessageConverters;
    import org.springframework.context.annotation.*;
    import org.springframework.http.converter.*;
    
    @Configuration
    public class MyConfiguration {
    
        @Bean
        public HttpMessageConverters customConverters() {
            HttpMessageConverter<?> additional = ...
            HttpMessageConverter<?> another = ...
            return new HttpMessageConverters(additional, another);
        }
    
    }
    ```

- Automatic registration of `MessageCodesResolver` (see below).

  - 定义错误代码生成规则

- Automatic use of a `ConfigurableWebBindingInitializer` bean (see below).

  - ```java
    @Override
    protected ConfigurableWebBindingInitializer getConfigurableWebBindingInitializer() {
       try {
          return this.beanFactory.getBean(ConfigurableWebBindingInitializer.class);
       }
       catch (NoSuchBeanDefinitionException ex) {
          return super.getConfigurableWebBindingInitializer();
       }
    }
    ```

    在beanFactory：中可以自己创建一个，初始化webDataBinder

    请求数据 ==》javaBean

If you want to keep Spring Boot MVC features, and you just want to add additional [MVC configuration](https://docs.spring.io/spring/docs/4.3.16.RELEASE/spring-framework-reference/htmlsingle#mvc) (interceptors, formatters, view controllers etc.) you can add your own `@Configuration` class of type `WebMvcConfigurerAdapter`, but **without** `@EnableWebMvc`. If you wish to provide custom instances of `RequestMappingHandlerMapping`, `RequestMappingHandlerAdapter` or `ExceptionHandlerExceptionResolver` you can declare a `WebMvcRegistrationsAdapter` instance providing such components.

If you want to take complete control of Spring MVC, you can add your own `@Configuration` annotated with `@EnableWebMvc`.



### 2、扩展SpringMVC

通过**继承WebMvcConfigurerAdapter**来给容器**扩展**SpringMVC的配置。

```java
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
//        super.addViewControllers(registry);
        //浏览器发送wdjr请求，也来到success页面
        registry.addViewController("/wdjr").setViewName("success");
    }
}
```

原理：

1）、WebMvcAutoConfiguration是SpringMVC的自动配置类

2）、在做其他自动配置时会导入；@Import(EnableWebMvcConfiguration.class)

```java
@Configuration
public static class EnableWebMvcConfiguration extends DelegatingWebMvcConfiguration {
    private final WebMvcConfigurerComposite configurers = new WebMvcConfigurerComposite();

	//从容器中获取所有webMVCconfigurer
	@Autowired(required = false)
	public void setConfigurers(List<WebMvcConfigurer> configurers) {
		if (!CollectionUtils.isEmpty(configurers)) {
			this.configurers.addWebMvcConfigurers(configurers);
            
            	@Override
                protected void addViewControllers(ViewControllerRegistry registry) {
                    this.configurers.addViewControllers(registry);
                }
            //一个参考实现,将所有的webMVCconfigurer相关配置一起调用（包括自己的配置类）
            	@Override
               // public void addViewControllers(ViewControllerRegistry registry) {
                   // for (WebMvcConfigurer delegate : this.delegates) {
				 //delegate.addViewControllers(registry);
                    //}
                }
		}
	}
```



3）、自己的配置被调用

效果：SpringMVC的自动配置和我们的扩展配置都会起作用

**注：SpringBoot2.X开始WebMvcConfigurerAdapter已经过时，因为2.x开始用的是spring5，Spring5已经弃用WebMvcConfigurerAdapter**

可以使用以下两种方式替代：

```java
@Configuration
public class WebMvcConfg implements WebMvcConfigurer {
  //一系列实现方法
}

//继承WebMvcConfigurationSupport类是会导致静态资源自动配置失效(不推荐)
@Configuration
public class WebMvcConfg extends WebMvcConfigurationSupport {
  @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/user/login");
        super.addInterceptors(registry);
    }
}
```



### 3、全面接管mvc

使用**@EnableWebMvc**可以完全不使用SpringBoot对SpringMVC的自动配置。（**不推荐**）

```java
@EnableWebMvc
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {

@Override
public void addViewControllers(ViewControllerRegistry registry) {

//        super.addViewControllers(registry);
        //浏览器发送wdjr请求，也来到success页面
        registry.addViewController("/wdjr").setViewName("success");
    }
}
```

**@EnableWebMvc原理**：

为什么@EnableWebMvc注解，SpringBoot对SpringMVC的控制就失效了

1）、核心配置

```java
@Import(DelegatingWebMvcConfiguration.class)
public @interface EnableWebMvc {
}
```

2）、DelegatingWebMvcConfiguration

```java
@Configuration
public class DelegatingWebMvcConfiguration extends WebMvcConfigurationSupport {
```

3）、WebMvcAutoConfiguration

```java
@Configuration
@ConditionalOnWebApplication
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class,
      WebMvcConfigurerAdapter.class })
//容器没有这个组件的时候，这个自动配置类才生效
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class,
      ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {
```

4）、@EnableWebMvc将WebMvcConfigurationSupport导入进来了；

5）、导入的WebMvcConfigurationSupport只是SpringMVC最基本的功能



## 5、修改SpringMVC默认配置

模式:

​	1）、SpringBoot在自动配置很多组件的时候，先看容器中有没有用户自己配置的（@Bean、@Component）如果有就用用户配置的，如果没有，才自动配置；如果有些组件允许有多个（ViewResolver）将用户配置的和自己默认的组合起来；

​	2）、在SpringBoot中会有 xxxConfigurer帮助我们扩展配置。

​	3）、在SpringBoot中会有 xxxCustomizer帮助我们定制配置。

### 1、设置首页

第一种：放在resources静态资源文件夹下即可，（前面有提及）

第二种：写个controller，拦截"/"和“/index.html"...,跳转到index，这样会经过thymeleaf引擎解析。

第三种：

```java
//这个是SpringBoot1.X版本的方式（过时）
@Configuration
public  class MyMvcConfig extends WebMvcConfigurerAdapter{
    //所有的webMvcConfigurerAdapter组件都会起作用
    @Bean //记得註冊到容器去
    public WebMvcConfigurerAdapter webMvcConfigurerAdapter(){
        //匿名内部类的方式
        return new WebMvcConfigurerAdapter() {
            @Override
            public void addViewControllers(ViewControllerRegistry registry) {
                registry.addViewController("/").setViewName("login");
                registry.addViewController("/login.html").setViewName("login");
            }
        };
    }
}
```



```java
//这个是SpringBoot2.X版本的方式，实现WebMvcConfigurer接口
@Override
public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/").setViewName("login");
    registry.addViewController("/index.html").setViewName("login");
}
```



### 2、国际化

#### **1、编写国际化配置文件**

抽取页面需要的显示的国际化消息(**eclipse插件：ResourceBundleEditor**)

zh是语言代码；
CN是国家代码；

![16.national](.\16.national.jpg)

#### 2、配置：spring.messages.basename

spring.messages.basename=i18n/login

#### **SpringBoot自动配置国际化配置的源码解析**

```java
@ConfigurationProperties(prefix = "spring.messages")
public class MessageSourceAutoConfiguration {
     /**If it doesn't contain a package
	 * qualifier (such as "org.mypackage"), it will be resolved from the classpath root.
	 如果我们没有配置spring.messages.basename的话就会直接在classpath下找默认的basename（messages.properties）*/
         
    private String basename = "messages";
    @Bean
	public MessageSource messageSource() {
		ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
		if (StringUtils.hasText(this.basename)) {
            //设置国际化文件的基础名，去掉语言国家代码
			messageSource.setBasenames(StringUtils.commaDelimitedListToStringArray(
					StringUtils.trimAllWhitespace(this.basename)));
		}
		if (this.encoding != null) {
			messageSource.setDefaultEncoding(this.encoding.name());
		}
		messageSource.setFallbackToSystemLocale(this.fallbackToSystemLocale);
		messageSource.setCacheSeconds(this.cacheSeconds);
		messageSource.setAlwaysUseMessageFormat(this.alwaysUseMessageFormat);
		return messageSource;
	}
```

**这步很关键**：

如果使用默认的basename，就是是message.properties;

如果自定义了文件夹存放国际化的信息，（比如：/i18n/message.properties或者/i18n/login.properties），则在主配置文件中设置:spring.messages.basename=i18n/message（或i18n/login）

```yaml
spring:
  messages:
    basename: i18n/login
```

3、对IDEA的编码进行设置（输出乱码时，可能是因为properties的编码格式不对）

4、在页面用thymeleaf表达式取出自定义的国际化信息（这里可以理解为：springboot加载到了配置文件，这样容器中就有我们需要的值了，所以我们用一些表达式注入。很多地方都是这个道理：**容器有什么就能注入什么**）

```html
th:text="#{login.welcome}"//取出国际化信息：#{}
或
[[#{login.rememberMe}]]---行内式
```

##### 

##### **原理：**

LocaleResolver(区域信息解析器)：

```java
@Bean
@ConditionalOnMissingBean
@ConditionalOnProperty(prefix = "spring.mvc", name = "locale")
public LocaleResolver localeResolver() {
    if (this.mvcProperties.getLocaleResolver() == WebMvcProperties.LocaleResolver.FIXED) {
        return new FixedLocaleResolver(this.mvcProperties.getLocale());
    }
    AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
    localeResolver.setDefaultLocale(this.mvcProperties.getLocale());
    return localeResolver;
}            
默认的区域信息解析器就是根据请求头带来的区域信息获取local国际化信息
```

<img src="/image-20200614211746088.png" alt="image-20200614211746088" style="zoom: 67%;" />



自己编写localResolver，加到容器中

1、更改HTML代码

```html
<p class="mt-5 mb-3 text-muted">© 2017-2018</p>
  <a href="#" class="btn btn-sm" th:href="@{/index.html?lg=zh_CN}">中文</a>
  <a href="#" class="btn btn-sm" th:href="@{/index.html?lg=en_US}">English</a>

也可以用：@{/index.html(lg=en_US)}
```

2、新建一个MyLocaleResolver.class

```java
public class MyLocaleResolver implements LocaleResolver {

    //解析区域信息
    @Override
    public Locale resolveLocale(HttpServletRequest request) {
        String l = request.getParameter("al");
        Locale locale = Locale.getDefault();//获取默认的区域信息解析器
        if(!StringUtils.isEmpty(l)){		//SpringBoot自带String工具类
            String[] split = l.split("_");
            locale = new Locale(split[0], split[1]);//更换区域信息解析器（语言代码+国家代码）
        }
        return locale;
    }

    @Override
    public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {

    }
}
```

3、将MyLocaleResolver加入到容器中，就可以替换掉默认的localeResolver

```java
@Bean//这里的bean的id必须是localeResolver
public LocaleResolver localeResolver(){
    return new MyLocalResolver();
}
```



### 3、登录拦截器

开发技巧

```properties
#1、禁用thymeleaf模板引擎的缓存（开发时关闭）
spring.thymeleaf.cache=false
#2、Ctrl+F9重新build(IDEA需要。eclipse不需要)
```



1、新建一个LoginController

2、登录错误消息显示

```html
<!--判断，登录失败时候显示，#strings是thymeleaf的内置对象-->
<p style="color: red" th:text="${errorMsg}" th:if="${not #strings.isEmpty(msg)}"></p>
```

3、防止表单重复提交

现象：登录成功后，按F5会重新刷新页面，会重新提交表单。

解决办法：登录成功后使用重定向来到某个url-》视图控制器拦截url--》模板引擎解析--》成功页面

（不能直接重定向到成功页面，因为成功界面在templates文件夹中，不能直接访问）

```java
if(!StringUtils.isEmpty(username) && "123456".equals(password)){
    //登录成功,防止重复提交
    return "redirect:/main.html";
}else{
    map.put("msg", "用户名密码错误");
    return "login";
}
//这种实现“间接跳转”的思路很实用
```

模板引擎解析

```java
@Override
public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/").setViewName("login");
    registry.addViewController("/index.html").setViewName("login");
    registry.addViewController("/main.html").setViewName("dashboard");
}
```

### 4、拦截器

1、在component下新建一个LoginHandlerInterceptor拦截器

```java
public class LoginHandlerInterceptor implements HandlerInterceptor {

    //目标方法执行之前
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Object user = request.getSession().getAttribute("loginUser");
        if(user!=null){
            //已经登录
            return true;
        }
        //未经过验证
        request.setAttribute("errorMsg", "没权限请先登录");
        request.getRequestDispatcher("/index.html").forward(request, response);
        return false;
    }
//方法后，页面渲染前
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }
//页面渲染后
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
    }
}
```

2、在MyMvcConfig配置中重写拦截器方法，加入到容器中

```java
//所有的拦截器组件会一起起作用
@Bean //註冊到容器去

        //注册拦截器
        @Override
        public void addInterceptors(InterceptorRegistry registry) {
       //Spring2.0之前，自动放行静态文件夹的位置，Springboot2.0之后静态文件夹的也会被拦截器拦截。
       registry.addInterceptor(new LoginHandlerInterceptor()).addPathPatterns("/**").
                    excludePathPatterns("/index.html","/","/user/login","这里要加上静态资源的位置，并且不能带/static,比如可以写：/css/**,/js/**");     
        }
    };
    return adapter;
//!!!Spring2.0之前，自动放行静态文件夹的位置，Springboot2.0之后静态文件夹的也会被拦截器拦截。
```

3、在LoginHandler中添加登录成功写入session



## 6、CRUD中的一些要点

实验要求：

1）、**Restful**

**URI:/资源名称/资源标识+HTTP操作**

|      | 普通CRUD                | RestfulCRUD                            |
| ---- | ----------------------- | -------------------------------------- |
| 查询 | getEmp                  | emp -- GET    （@GetMapping）          |
| 添加 | addEmp?xxx              | emp --POST   （@PostMapping）          |
| 修改 | updateEmp?id=xxx&xxx=xx | emp/{id} -- PUT   （@PutMapping）      |
| 删除 | deleteEmp?id=1          | emp/{id} --DELETE   （@DeleteMapping） |

2、实验的请求架构

|              | 请求URI  | 请求方式 |
| ------------ | -------- | -------- |
| 查询员工     | emp/{id} | GET      |
| 添加员工     | emp      | POST     |
| 来到修改页面 | emp/{id} | GET      |
| 修改员工     | emp/{id} | PUT      |
| 删除员工     | emp/{id} | DELETE   |

以上都是单个员工，如果要多个是则把emp该为emps，方便理解。

#### 1、thymeleaf抽取公共页面

使用方法：

```html
1、抽取公共片段：
	<div id="footid" th:fragment="copy">xxx</div>

2、引入公共片段(两种方法：th:fragment或id)
一：~{模板名::片段名称}
	<div th:insert=~{footer::copy}>
    
二：~{模板名::选择器}
	<div th:insert=~{footer::footid}></div>
备注：这里的“模板名“是指可以templates文件夹下的”文件夹名/路径名“，
除了th:insert还有th:replace/th:include
```

**三种引用方式**(th:insert/th:replace /th:include)

**th:insert** :加个外层标签 +1

**th:replace** :完全替换 0**（推荐）**

**th:include**：就替换里面的内容 -1

**区别如下：**

公共页面

```html
<body>
	...
    <div th:insert="footer :: copy"></div>
    <div th:replace="footer :: copy"></div>
    <div th:include="footer :: copy"></div>
</body>
```

结果

```html
<body>
...
    <!-- th:insert -->
    <div>
        <footer>
            &copy; 2011 The Good Thymes Virtual Grocery
        </footer>
    </div>
    
    <!--th:replace-->
    <footer>
   		&copy; 2011 The Good Thymes Virtual Grocery
    </footer>
    
    <!--th:include-->
    <div>
        &copy; 2011 The Good Thymes Virtual Grocery
    </div>
</body>
```



#### 2、列表点击切换高亮

新建一个commons文件夹存储公共页面bar.html

思路：在引入片段的时候传出参数给片段，片段通过参数的不同，三元运算符判断，来改变class样式

效果：点击dashboard则高亮，点击员工管理则其高亮，其他变暗，

​	Bootstrap高亮为“nav-link active“，不高亮则为”nav-link“

两个要点：1. thymeleaf中可以用三元运算，并且写法和java一样；

​			2.通过引入片段的同时传递参数给片段



dashboard.html定义好参数，引入片段的同时，把参数传到片段中

```html
<div th:replace="commons/bar :: sidebar(activeUri='emps')"></div>
```

bar.html

```html
<a th:class="${activeUri}=='emps'?'nav-link active':'nav-link'"/>
```



#### 3、thymeleaf的遍历

```html
<tr th:each="prod : ${prods}">
    <td th:text="${prod.name}">Onions</td>
    <td th:text="${prod.price}">2.41</td>
    <td th:text="${prod.inStock}? #{true} : #{false}">yes</td>
</tr>
th:each循环的是它所在的标签，这里就是循环tr。
属性： index 、count、size、current、even/odd、first、last
```

#### 4、日期格式化

```html
#dates.format(emp.birth,'yyyy-MM-dd HH:mm:ss')
#dates是thymeleaf的内置对象
```



#### 5、转发和重定向

```java
如果直接写return "/emps";thymeleaf引擎解析后会添加前后缀，
如果是return "redirect:/emps"   或  return "forward:/emps" ;thymeleaf解析后会会找controller。

//ThymeleafViewResolver是thymeleaf的视图解析器，转发和重定向也会被解析，但渲染是调用了servlet原生的sendredirect和forward方法。所以可以用转发和重定向从一个controller跳转到另一个controller。
```



#### 6、 可以用属性.属性传参

SpringMvc支持这样的方式。

```html
<select class="form-control"  name="department.id">
```



#### 7、修改SpringBoot默认的接收的日期格式

```java
//springboot默认的日期格式
/**
* Date format to use (e.g. dd/MM/yyyy).
*/
private String dateFormat;

//修改：
spring.mvc.date-format=yyyy-MM-dd HH:mm
```



#### 8、/emp/{id}

**@{/emp/}+${emp.id}**

```html
<a th:href="@{/emp/}+${emp.id}">编辑</a>
```

**@PathVariable**

```java
@GetMapping(value = "/emp/{id}")
public String toEditPage(@PathVariable("id") Integer id ,Model model){}
```

#### 9、HiddenHttpMethodFilter接收更多请求方式

```html
<from method="from表单的method只支持post和get，SpringMvc提供HiddenHttpMethodFilter来接收更多请求"></from>

步骤：
<!--1.SpringMVC配置HiddenHttpMethodFilter（SpringBoot已经配置好的）
    2.页面创建一个post表单
    3.创建一个input项，name="_method",value的值就是我们请求的方式(PUT/DELETE)-->
<input type="hidden" name="_method" value="put" th:if="${emp!=null}">
<input type="hidden" name="id" th:value="${emp.id}" th:if="${emp!=null}">
或者用三元运算替代上面
<input type="hidden" name="_method" th:value="${emp!=null}?'put'">
<input type="hidden" name="id" th:value="${emp!=null}?${emp.id}">
```
#### 10、员工删除

删除的要点就在于：1.以delete方式；2.传递id

上面的PUT方式修改时，可以根据emp是否为空来改变提交方式，但是delete没有办法通过条件判断，所以可以给delete按钮外面在套一层form表单，这样就和外面的互不影响，并且可以以delete方式提交empid。如下：

```html
<form action="@{/emp/}+${emp.empid}" method="post">
     <input type="hidden" name="_method" value="delete">
     <button type="submit">删除</button>
</form>
```

但是上面的做法会让页面显得很重，每一个删除按钮都有一个表单。所以把表单移到外面，按钮还是普通按钮，通过js点击按钮提交这个表单。

按钮：

```html
<button th:attr="del_uri=@{/emp/}+${emp.id}" class="deleteBtn">删除</button>
<!--th:attr 给html标签加任意自定义属性-->
```

表单：

```html
<form id="deleteEmpForm" method="post">
       <input type="hidden" name="_method" value="delete">
</form>
```

2.给”删除“绑定事件，并携带/emp/id 

```html
<script>
    $(".deleteBtn").click(function () {
        if(confirm('你确定要删除吗?')) {
            //获取表单信息，更改action，提交。
        	$("#deleteEmpForm").attr("action",$(this).attr("del_uri")).submit();
        }
        return false;//禁用btn提交效果???
    })
</script>
```



# (以下未看，44~52集)

## 7、错误机制的处理

### 1、默认的错误处理机制

默认错误页面

![20.error](.\images\20.error.jpg)

原理参照

ErrorMvcAutoConfiguration:错误处理的自动配置

```
org\springframework\boot\spring-boot-autoconfigure\1.5.12.RELEASE\spring-boot-autoconfigure-1.5.12.RELEASE.jar!\org\springframework\boot\autoconfigure\web\ErrorMvcAutoConfiguration.class

```

- DefaultErrorAttributes

  帮我们在页面共享信息

  ```java
  @Override
  public Map<String, Object> getErrorAttributes(RequestAttributes requestAttributes,
        boolean includeStackTrace) {
     Map<String, Object> errorAttributes = new LinkedHashMap<String, Object>();
     errorAttributes.put("timestamp", new Date());
     addStatus(errorAttributes, requestAttributes);
     addErrorDetails(errorAttributes, requestAttributes, includeStackTrace);
     addPath(errorAttributes, requestAttributes);
     return errorAttributes;
  }
  ```

- BasicErrorController

  ```java
  @Controller
  @RequestMapping("${server.error.path:${error.path:/error}}")
  public class BasicErrorController extends AbstractErrorController {
      //产生HTML数据
      @RequestMapping(produces = "text/html")
  	public ModelAndView errorHtml(HttpServletRequest request,
  			HttpServletResponse response) {
  		HttpStatus status = getStatus(request);
  		Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
  				request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
  		response.setStatus(status.value());
  		ModelAndView modelAndView = resolveErrorView(request, response, status, model);
  		return (modelAndView == null ? new ModelAndView("error", model) : modelAndView);
  	}
  	//产生Json数据
  	@RequestMapping
  	@ResponseBody
  	public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
  		Map<String, Object> body = getErrorAttributes(request,
  				isIncludeStackTrace(request, MediaType.ALL));
  		HttpStatus status = getStatus(request);
  		return new ResponseEntity<Map<String, Object>>(body, status);
  	}
  ```

- ErrorPageCustomizer

  ```java
  @Value("${error.path:/error}")
  private String path = "/error";//系统出现错误以后来到error请求进行处理，(web.xml)
  ```

- DefaultErrorViewResolver

  ```java
  @Override
  public ModelAndView resolveErrorView(HttpServletRequest request, HttpStatus status,
        Map<String, Object> model) {
     ModelAndView modelAndView = resolve(String.valueOf(status), model);
     if (modelAndView == null && SERIES_VIEWS.containsKey(status.series())) {
        modelAndView = resolve(SERIES_VIEWS.get(status.series()), model);
     }
     return modelAndView;
  }
  
  private ModelAndView resolve(String viewName, Map<String, Object> model) {
      //默认SpringBoot可以找到一个页面？error/状态码
     String errorViewName = "error/" + viewName;
      //如果模板引擎可以解析地址，就返回模板引擎解析
     TemplateAvailabilityProvider provider = this.templateAvailabilityProviders
           .getProvider(errorViewName, this.applicationContext);
     if (provider != null) {
         //有模板引擎就返回到errorViewName指定的视图地址
        return new ModelAndView(errorViewName, model);
     }
      //自己的文件 就在静态文件夹下找静态文件 /静态资源文件夹/404.html
     return resolveResource(errorViewName, model);
  }
  ```

一旦系统出现4xx或者5xx错误 ErrorPageCustomizer就回来定制错误的响应规则,就会来到 /error请求,BasicErrorController处理，就是一个Controller

1.响应页面,去哪个页面是由 DefaultErrorViewResolver 拿到所有的错误视图

```java
protected ModelAndView resolveErrorView(HttpServletRequest request,
      HttpServletResponse response, HttpStatus status, Map<String, Object> model) {
   for (ErrorViewResolver resolver : this.errorViewResolvers) {
      ModelAndView modelAndView = resolver.resolveErrorView(request, status, model);
      if (modelAndView != null) {
         return modelAndView;
      }
   }
   return null;
}
```

l浏览器发送请求 accpt:text/html

客户端请求：accept:/*

### 2、如何定制错误响应

​	1）、如何定制错误的页面

​		1.有模板引擎：静态资源/404.html,什么错误什么页面；所有以4开头的 4xx.html 5开头的5xx.html

​		有精确的404和4xx优先选择404

​		页面获得的数据

​			timestamp：时间戳

​			status：状态码

​			error：错误提示

​			exception：异常对象

​			message：异常信息

​			errors:JSR303有关

​		2.没有放在模板引擎，放在静态文件夹，也可以显示，就是没法使用模板取值

​		3.没有放模板引擎，没放静态，会显示默认的错误

​	2）、如何定义错误的数据



举例子：新建4xx和5xx文件

![21.error-static](.\images\21.error-static.jpg)



```html
<body >
    <p>status: [[${status}]]</p>
    <p>timestamp: [[${timestamp}]]</p>
    <p>error: [[${error}]]</p>
    <p>message: [[${message}]]</p>
    <p>exception: [[${exception}]]</p>
</body>
```

![22.4xxhtml](.\images\22.4xxhtml.jpg)

### 3、如何定制Json数据

#### 1、仅发送json数据

```java
public class UserNotExitsException extends  RuntimeException {
    public UserNotExitsException(){
        super("用户不存在");
    }
}
```

```java
/**
 * 异常处理器
 */
@ControllerAdvice
public class MyExceptionHandler {

    @ResponseBody
    @ExceptionHandler(UserNotExitsException.class)
    public Map<String ,Object> handlerException(Exception e){
        Map<String ,Object> map =new HashMap<>();
        map.put("code", "user not exist");
        map.put("message", e.getMessage());
        return map;
    }
}
```

无法自适应 都是返回的json数据

#### 2、转发到error自适应处理

```java
@ExceptionHandler(UserNotExitsException.class)
public String handlerException(Exception e, HttpServletRequest request){
    Map<String ,Object> map =new HashMap<>();
    //传入自己的状态码
    request.setAttribute("javax.servlet.error.status_code", 432);
    map.put("code", "user not exist");
    map.put("message", e.getMessage());
    //转发到error
    return "forward:/error";
}
```

程序默认获取状态码

```java
protected HttpStatus getStatus(HttpServletRequest request) {
   Integer statusCode = (Integer) request
         .getAttribute("javax.servlet.error.status_code");
   if (statusCode == null) {
      return HttpStatus.INTERNAL_SERVER_ERROR;
   }
   try {
      return HttpStatus.valueOf(statusCode);
   }
   catch (Exception ex) {
      return HttpStatus.INTERNAL_SERVER_ERROR;
   }
```

没有自己写的自定义异常数据

#### 3、自适应和定制数据传入

Spring 默认的原理，出现错误后回来到error请求，会被BasicErrorController处理,响应出去的数据是由BasicErrorController的父类AbstractErrorController(ErrorController)规定的方法getAttributes得到的；

1、编写一个ErrorController的实现类【或者AbstractErrorController的子类】，放在容器中；

2、页面上能用的数据，或者是json数据返回能用的数据都是通过errorAttributes.getErrorAttributes得到；

容器中的DefaultErrorAtrributes.getErrorAtrributees();默认进行数据处理

```java
public class MyErrorAttributes extends DefaultErrorAttributes {
    @Override
    public Map<String, Object> getErrorAttributes(RequestAttributes requestAttributes, boolean includeStackTrace) {
        Map<String, Object> map = super.getErrorAttributes(requestAttributes, includeStackTrace);
        map.put("company", "wdjr");
        return map;
    }
}
```

异常处理：把map方法请求域中

```java
    @ExceptionHandler(UserNotExitsException.class)
    public String handlerException(Exception e, HttpServletRequest request){
        Map<String ,Object> map =new HashMap<>();
        //传入自己的状态码
        request.setAttribute("javax.servlet.error.status_code", 432);
        map.put("code", "user not exist");
        map.put("message", e.getMessage());
        request.setAttribute("ext", map);
        //转发到error
        return "forward:/error";
    }
}
```

在上面的MyErrorAttributes类中加上

```java
//我们的异常处理器
Map<String,Object> ext = (Map<String, Object>) requestAttributes.getAttribute("ext", 0);
map.put("ext", ext);
```

## 8、配置嵌入式servlet容器

### 1、定制和修改Servlet容器

SpringBoot默认使用Tomcat作为嵌入式的Servlet容器（还支持jetty等等）；

![23.tomcat emd](.\images\23.tomcat emd.jpg)

#### 修改servlet的配置

第一种： 修改Server相关的配置文件（**ServerProperties**）

```properties
#通用的servlet容器配置
server.xxx
#tomcat的配置
server.tomcat.xxxx
```

第二种：编写一个EmbeddedServletContainerCustomizer;（嵌入式的Servlet容器的定制器）；来修改Servlet的容器配置

```java
@Bean
public EmbeddedServletContainerCustomizer embeddedServletContainerCustomizer(){
    return new EmbeddedServletContainerCustomizer() {
        //定制嵌入式Servlet的容器相关规则
        @Override
        public void customize(ConfigurableEmbeddedServletContainer container) {
            container.setPort(8999);
        }
    };
}
```

**其实同理，都是实现EmbeddedServletContainerCustomizer（推荐第一种）**

### 2、注册Servlet三大组件

三大组件 Servlet Filter Listener

由于SprringBoot默认是以jar包启动嵌入式的Servlet容器来启动SpringBoot的web应用，没有web.xml

注册三大组件

#### ServletRegistrationBean

```java
@Bean
public ServletRegistrationBean myServlet(){
    ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new MyServlet(),"/servlet");
    return servletRegistrationBean;
}
```

MyServlet

```java
public class MyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.getWriter().write("Hello Servlet");
    }
}
```

#### FilterRegistrationBean

```java
@Bean
public FilterRegistrationBean myFilter(){
    FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
    filterRegistrationBean.setFilter(new MyFilter());
    filterRegistrationBean.setUrlPatterns(Arrays.asList("/hello","/myServlet"));
    return filterRegistrationBean;
}
```

MyFilter

```java
public class MyFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        System.out.println("MyFilter process");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
```

#### ServletListenerRegistrationBean

```java
@Bean
public ServletListenerRegistrationBean myListener(){
    ServletListenerRegistrationBean<MyListener> registrationBean = new ServletListenerRegistrationBean<>(new MyListener());
    return registrationBean;
}
```

MyListener

```java
public class MyListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println(".........web应用启动..........");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println(".........web应用销毁..........");
    }
}
```



SpringBoot帮助我们自动配置SpringMVC的时候，自动注册SpringMVC的前端控制器；DispatcherServlet;

```java
@Bean(name = DEFAULT_DISPATCHER_SERVLET_REGISTRATION_BEAN_NAME)
@ConditionalOnBean(value = DispatcherServlet.class, name = DEFAULT_DISPATCHER_SERVLET_BEAN_NAME)
   public ServletRegistrationBean dispatcherServletRegistration(
         DispatcherServlet dispatcherServlet) {
      ServletRegistrationBean registration = new ServletRegistrationBean(
            dispatcherServlet, this.serverProperties.getServletMapping());
       //默认拦截 /所有请求 包括静态资源 不包括jsp
       //可以通过server.servletPath来修改SpringMVC前端控制器默认拦截的请求路径
      registration.setName(DEFAULT_DISPATCHER_SERVLET_BEAN_NAME);
      registration.setLoadOnStartup(
            this.webMvcProperties.getServlet().getLoadOnStartup());
      if (this.multipartConfig != null) {
         registration.setMultipartConfig(this.multipartConfig);
      }
      return registration;
   }

}
```

### 3、切换其他的Servlet容器

在ServerProperties中

```java
private final Tomcat tomcat = new Tomcat();

private final Jetty jetty = new Jetty();

private final Undertow undertow = new Undertow();
```

tomcat(默认支持)

jetty（长连接）

undertow（多性能，并发性能好，不支持jsp）

切换容器 仅仅需要修改pom文件的依赖就可以

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <exclusions>
                //排除tomcat
                <exclusion>
                    <artifactId>spring-boot-starter-tomcat</artifactId>
                    <groupId>org.springframework.boot</groupId>
                </exclusion>
            </exclusions>
        </dependency>
//引入其他servlet容器
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>
<!--        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-undertow</artifactId>
        </dependency>-->
```

### 4、嵌入式Servlet容器自动配置原理

```java
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE)
@Configuration
@ConditionalOnWebApplication
@Import(BeanPostProcessorsRegistrar.class)
//给容器导入组件 后置处理器 在Bean初始化前后执行前置后置的逻辑 创建完对象还没属性赋值进行初始化工作
public class EmbeddedServletContainerAutoConfiguration {
    @Configuration
	@ConditionalOnClass({ Servlet.class, Tomcat.class })//当前是否引入tomcat依赖
    //判断当前容器没有用户自定义EmbeddedServletContainerFactory，就会创建默认的嵌入式容器
	@ConditionalOnMissingBean(value = EmbeddedServletContainerFactory.class, search = SearchStrategy.CURRENT)
	public static class EmbeddedTomcat {

		@Bean
		public TomcatEmbeddedServletContainerFactory tomcatEmbeddedServletContainerFactory() {
			return new TomcatEmbeddedServletContainerFactory();
		}
```

1）、EmbeddedServletContainerFactory（嵌入式Servlet容器工厂）

```java
public interface EmbeddedServletContainerFactory {
	//获取嵌入式的Servlet容器
   EmbeddedServletContainer getEmbeddedServletContainer(
         ServletContextInitializer... initializers);

}
```

继承关系

![24.EmdServletFactory](.\images\24.EmdServletFactory.jpg)

2）、EmbeddedServletContainer:(嵌入式的Servlet容器)

![25.EmdServletContainer](.\images\25.EmdServletContainer.jpg)

3）、TomcatEmbeddedServletContainerFactory为例 

```java
@Override
public EmbeddedServletContainer getEmbeddedServletContainer(
      ServletContextInitializer... initializers) {
   Tomcat tomcat = new Tomcat();
    //配置tomcat的基本环节
   File baseDir = (this.baseDirectory != null ? this.baseDirectory
         : createTempDir("tomcat"));
   tomcat.setBaseDir(baseDir.getAbsolutePath());
   Connector connector = new Connector(this.protocol);
   tomcat.getService().addConnector(connector);
   customizeConnector(connector);
   tomcat.setConnector(connector);
   tomcat.getHost().setAutoDeploy(false);
   configureEngine(tomcat.getEngine());
   for (Connector additionalConnector : this.additionalTomcatConnectors) {
      tomcat.getService().addConnector(additionalConnector);
   }
   prepareContext(tomcat.getHost(), initializers);
    //将配置好的tomcat传入进去；并且启动tomcat容器
   return getTomcatEmbeddedServletContainer(tomcat);
}
```

4）、嵌入式配置修改

```
ServerProperties、EmbeddedServletContainerCustomizer
```

EmbeddedServletContainerCustomizer:定制器帮我们修改了Servlet容器配置？

怎么修改？



5）、容器中导入了**EmbeddedServletContainerCustomizerBeanPostProcessor**

```java
@Override
public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata,
      BeanDefinitionRegistry registry) {
   if (this.beanFactory == null) {
      return;
   }
   registerSyntheticBeanIfMissing(registry,
         "embeddedServletContainerCustomizerBeanPostProcessor",
         EmbeddedServletContainerCustomizerBeanPostProcessor.class);
   registerSyntheticBeanIfMissing(registry,
         "errorPageRegistrarBeanPostProcessor",
         ErrorPageRegistrarBeanPostProcessor.class);
}
```

```java
@Override
public Object postProcessBeforeInitialization(Object bean, String beanName)
      throws BeansException {
    //如果当前初始化的是一个ConfigurableEmbeddedServletContainer
   if (bean instanceof ConfigurableEmbeddedServletContainer) {
      postProcessBeforeInitialization((ConfigurableEmbeddedServletContainer) bean);
   }
   return bean;
}

private void postProcessBeforeInitialization(
    ConfigurableEmbeddedServletContainer bean) {
    //获取所有的定制器，调用每个定制器的customer方法给Servlet容器进行赋值
    for (EmbeddedServletContainerCustomizer customizer : getCustomizers()) {
        customizer.customize(bean);
    }
}

private Collection<EmbeddedServletContainerCustomizer> getCustomizers() {
    if (this.customizers == null) {
        // Look up does not include the parent context
        this.customizers = new ArrayList<EmbeddedServletContainerCustomizer>(
            this.beanFactory
            //从容器中获取所有的这个类型的组件：EmbeddedServletContainerCustomizer
            //定制Servlet,给容器中可以添加一个EmbeddedServletContainerCustomizer类型的组件
            .getBeansOfType(EmbeddedServletContainerCustomizer.class,
                            false, false)
            .values());
        Collections.sort(this.customizers, AnnotationAwareOrderComparator.INSTANCE);
        this.customizers = Collections.unmodifiableList(this.customizers);
    }
    return this.customizers;
}
```

ServerProperties也是EmbeddedServletContainerCustomizer定制器

步骤：

1）、SpringBoot根据导入的依赖情况，给容器中添加响应的容器工厂 例：tomcat

EmbeddedServletContainerFactory【TomcatEmbeddedServletContainerFactory】

2）、容器中某个组件要创建对象就要通过后置处理器；

```java
EmbeddedServletContainerCustomizerBeanPostProcessor
```

只要是嵌入式的Servlet容器工厂，后置处理器就工作；

3）、后置处理器，从容器中获取的所有的EmbeddedServletContainerCustomizer，调用定制器的定制方法

### 5、嵌入式Servlet容器启动原理

什么时候创建嵌入式的Servlet的容器工厂？什么时候获取嵌入式的Servlet容器并启动Tomcat;

获取嵌入式的容器工厂

1）、SpringBoot应用启动Run方法

2）、刷新IOC容器对象【创建IOC容器对象，并初始化容器，创建容器的每一个组件】；如果是web环境AnnotationConfigEmbeddedWebApplicationContext,如果不是AnnotationConfigApplicationContext

```JAVA
if (contextClass == null) {
   try {
      contextClass = Class.forName(this.webEnvironment
            ? DEFAULT_WEB_CONTEXT_CLASS : DEFAULT_CONTEXT_CLASS);
   }
```

3）、refresh(context);刷新创建好的IOC容器

```java
try {
   // Allows post-processing of the bean factory in context subclasses.
   postProcessBeanFactory(beanFactory);

   // Invoke factory processors registered as beans in the context.
   invokeBeanFactoryPostProcessors(beanFactory);

   // Register bean processors that intercept bean creation.
   registerBeanPostProcessors(beanFactory);

   // Initialize message source for this context.
   initMessageSource();

   // Initialize event multicaster for this context.
   initApplicationEventMulticaster();

   // Initialize other special beans in specific context subclasses.
   onRefresh();

   // Check for listener beans and register them.
   registerListeners();

   // Instantiate all remaining (non-lazy-init) singletons.
   finishBeanFactoryInitialization(beanFactory);

   // Last step: publish corresponding event.
   finishRefresh();
}
```

4）、 onRefresh();web的ioc容器重写了onRefresh方法

5）、webioc会创建嵌入式的Servlet容器；createEmbeddedServletContainer

6）、获取嵌入式的Servlet容器工厂；

```java
EmbeddedServletContainerFactory containerFactory = getEmbeddedServletContainerFactory();
```

从ioc容器中获取EmbeddedServletContainerFactory组件；

```java
@Bean
public TomcatEmbeddedServletContainerFactory tomcatEmbeddedServletContainerFactory() {
return new TomcatEmbeddedServletContainerFactory();
}
```
TomcatEmbeddedServletContainerFactory创建对象，后置处理器看这个对象，就来获取所有的定制器来定制Servlet容器的相关配置；

7）、使用容器工厂获取嵌入式的Servlet容器

8）、嵌入式的Servlet容器创建对象并启动Servlet容器；

先启动嵌入式的Servlet容器，在将ioc容器中剩下的没有创建出的对象获取出来

ioc启动创建Servlet容器

## 9、使用外置的Servlet容器

嵌入式的Servlet容器：应用达成jar包

​	优点：简单、便携

​	缺点：默认不支持JSP、优化定制比较复杂（使用定制器【ServerProperties、自定义定制器】，自己来编写嵌入式的容器工厂）

外置的Servlet容器：外面安装Tomcat是以war包的方式打包。

### 1、IDEA操作外部Servlet

1、创建程序为war程序

![26.tomcat1](.\images\26.tomcat1.jpg)

2、选择版本

![27.tomcat2](.\images\27.tomcat2.jpg)

3、添加tomcat

![28.tomcat3](.\images\28.tomcat3.jpg)

4、选择tomcat

![30.tomcat4](.\images\30.tomcat4.jpg)

5、选择本地的Tomcat

![31.tomcat5](.\images\31.tomcat5.jpg)

6、配置tomcat路径

![32.tomcat6](.\images\32.tomcat6.jpg)

7、添加服务器

![33.tomcat7](.\images\33.tomcat7.jpg)

8、添加exploded的war配置，应用OK tomcat配置完成

![34.tomcat8](.\images\34.tomcat8.jpg)

二、配置webapp文件夹

1、点击配置

![35.tomcat9](E:\工作文档\SpringBoot\images\35.tomcat9.jpg)

2、添加webapp目录

![36.tomcat10](E:\工作文档\SpringBoot\images\36.tomcat10.jpg)

3、默认配置就可以

![37.tomcat11](E:\工作文档\SpringBoot\images\37.tomcat11.jpg)

4、配置web.xml文件

![38.tomcat12](E:\工作文档\SpringBoot\images\38.tomcat12.jpg)

5、文档目录结构

![39.tomcat13](E:\工作文档\SpringBoot\images\39.tomcat13.jpg)

### 2、运行一个示例

1、项目目录

![40.demo1](E:\工作文档\SpringBoot\images\40.demo1.jpg)

2、配置文件写视图解析前后缀

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/

spring.mvc.view.suffix=.jsp
```

3、HelloController

```java
@Controller
public class HelloController {
    @GetMapping("/hello")
    public String hello(Model model){
        model.addAttribute("message","这是Controller传过来的message");
        return "success";
    }
}
```

4、success.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Success</title>
</head>
<body>
<h1>Success</h1>
message:${message}
</body>
</html>
```

5、运行结果

![41.demo2](.\images\41.demo2.jpg)

步骤

1、必须创建一个war项目；

2、将嵌入式的Tomcat指定为provided

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```

3、必须编写一个SpringBootServletInitializer的子类，并调用configure方法里面的固定写法

```java
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        //传入SpringBoot的主程序，
        return application.sources(SpringBoot04WebJspApplication.class);
    }

}
```

4、启动服务器就可以；

### 3、原理

jar包：执行SpringBoot主类的main方法，启动ioc容器，创建嵌入式的Servlet的容器；

war包：启动服务器，服务器启动SpringBoot应用，【SpringBootServletInitializer】启动ioc容器

servlet3.0规范

 8.2.4 共享库和运行时插件

规则：

1、服务器启动（web应用启动），会创建当前的web应用里面每一个jar包里面ServletContrainerInitializer的实现类的实例

2、SpringBootServletInitializer这个类的实现需要放在jar包下的META-INF/services文件夹下，有一个命名为javax.servlet.ServletContainerInitalizer的文件，内容就是ServletContainerInitializer的实现类全类名

3、还可以使用@HandlerTypes注解，在应用启动的时候可以启动我们感兴趣的类



流程：

1、启动Tomcat服务器

2、spring web模块里有这个文件

![42.servletContainerInit](E:\工作文档\SpringBoot\images\42.servletContainerInit.jpg)

```java
org.springframework.web.SpringServletContainerInitializer
```

3、SpringServletContainerInitializer将handlerTypes标注的所有类型的类传入到onStartip方法的Set<Class<?>>;为这些感兴趣类创建实例

4、每个创建好的WebApplicationInitializer调用自己的onStratup

5、相当于我们的SpringBootServletInitializer的类会被创建对象，并执行onStartup方法

6、SpringBootServletInitializer执行onStartup方法会创建createRootApplicationContext

```java
protected WebApplicationContext createRootApplicationContext(ServletContext servletContext) {
    SpringApplicationBuilder builder = this.createSpringApplicationBuilder();
    //环境构建器
    StandardServletEnvironment environment = new StandardServletEnvironment();
    environment.initPropertySources(servletContext, (ServletConfig)null);
    builder.environment(environment);
    builder.main(this.getClass());
    ApplicationContext parent = this.getExistingRootWebApplicationContext(servletContext);
    if (parent != null) {
        this.logger.info("Root context already created (using as parent).");
        servletContext.setAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE, (Object)null);
        builder.initializers(new ApplicationContextInitializer[]{new ParentContextApplicationContextInitializer(parent)});
    }
	
    builder.initializers(new ApplicationContextInitializer[]{new ServletContextApplicationContextInitializer(servletContext)});
    builder.contextClass(AnnotationConfigEmbeddedWebApplicationContext.class);
    //调用Configure,子类重写了这个方法，将SpringBoot的主程序类传入进来
    builder = this.configure(builder);
    //创建一个spring应用
    SpringApplication application = builder.build();
    if (application.getSources().isEmpty() && AnnotationUtils.findAnnotation(this.getClass(), Configuration.class) != null) {
        application.getSources().add(this.getClass());
    }

    Assert.state(!application.getSources().isEmpty(), "No SpringApplication sources have been defined. Either override the configure method or add an @Configuration annotation");
    if (this.registerErrorPageFilter) {
        application.getSources().add(ErrorPageFilterConfiguration.class);
    }
	//最后启动Spring容器
    return this.run(application);
}
```

7、Spring的应用就启动完了并且创建IOC容器；

```java
public ConfigurableApplicationContext run(String... args) {
   StopWatch stopWatch = new StopWatch();
   stopWatch.start();
   ConfigurableApplicationContext context = null;
   FailureAnalyzers analyzers = null;
   configureHeadlessProperty();
   SpringApplicationRunListeners listeners = getRunListeners(args);
   listeners.starting();
   try {
      ApplicationArguments applicationArguments = new DefaultApplicationArguments(
            args);
      ConfigurableEnvironment environment = prepareEnvironment(listeners,
            applicationArguments);
      Banner printedBanner = printBanner(environment);
      context = createApplicationContext();
      analyzers = new FailureAnalyzers(context);
      prepareContext(context, environment, listeners, applicationArguments,
            printedBanner);
      refreshContext(context);
      afterRefresh(context, applicationArguments);
      listeners.finished(context, null);
      stopWatch.stop();
      if (this.logStartupInfo) {
         new StartupInfoLogger(this.mainApplicationClass)
               .logStarted(getApplicationLog(), stopWatch);
      }
      return context;
   }
   catch (Throwable ex) {
      handleRunFailure(context, listeners, analyzers, ex);
      throw new IllegalStateException(ex);
   }
}
```

