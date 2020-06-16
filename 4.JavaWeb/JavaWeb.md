---
typora-copy-images-to: ./images
typora-root-url: ./images
---

# ==Servlet==

## 简介

> 1. sun公司定义了==JAVA处理网络请求的接口规范==：Servlet，位置：javax.servlet.*，不在rt.jar中，需另外导入。Servlet = Service  Applet，表示服务小程序。
> 2. Servlet的具体实现由Servlet容器决定，如Tomcat、JBoss。这种设计概念形同JDBC
>
> 3. 从原理上讲，Servlet可以响应任何类型的请求，但绝大多数情况下Servlet只用来扩展基于HTTP协议的Web服务器。

### Servlet接口规范方法

> 以下是Servlet接口定义的所有方法，这是**Servlet的核心,是Servlet的规范，所有的子类/扩展类都是以此为基础**。

![image-20200615105954590](/image-20200615105954590.png)



### Servlet结构体系

> 以下是JAVA EE中，Servlet的结构设计体系。

在IDEA中，show Diagrams-->ctrl+shift+B,全选。

![image-20200615140058527](/image-20200615140058527.png)

ctrl+shift+B查看最底下的HttpServlet实现类，可以发现是没有任何实现的。

![image-20200615140223755](/image-20200615140223755.png)



## Servlet核心API

### 1）Servlet接口

![image-20200615141140668](/image-20200615141140668.png)

### 2）HttpServlet类

doXXX()：doGet()/doPost()

service()

### 3）HttpServletRequest接口

> 封装了Http的请求

### 4）HttpServletResponse接口

> 封装了Http的响应

## 生命周期

### servlet容器与servlet的关系

==重点==：首先明确两点，我们在程序中编写的Servlet类，**一没有new Servlet对象**，**二没有main方法启动程序**。

所以：**Servlet是就交给Servlet容器(Tomcat)进行处理的**，servlet的生命周期由web容器控制。

servlet就好比子弹，Servlet容器就好比枪。这便是二者的关系

### 几个方法

1.构造方法（这也间接说明了java程序中的.class文件不是程序一启动类加载器就会去加载，而是按需加载）

2.init(ServletConfig config)

3.service(**ServletRequest** req, **ServletResponse** res)

4.destroy()

**构造方法**和**init**只在==第一次访问==时调用（说明了==servlet是**单实例**，**多线程**==运行）,
service()在每次访问都会被调用，
destory()在应用在服务器上卸载时调用。

Demo演示:

```xml
<!-- 浏览器访问： http://localhost:8080/day10/hello -->
<!—该servlet的配置信息 -->
<servlet>
	<servlet-name>HelloServlet</servlet-name>
    <servlet-class>gz.itcast.a_servlet.HelloServlet</servlet-class>
<!--作用：tomcat服务器启动的时候就创建servlet对象。数值越小表示优先级越高-->
    <load-on-startup>1</load-on-startup>
</servlet>

<!—该servlet的映射配置 -->
<servlet-mapping>
	<servlet-name>HelloServlet</servlet-name>
	<url-pattern>/hello</url-pattern>  //servlet的路径映射。
</servlet-mapping>
```

![执行过程泳道图](/wps3.png)

### 单实例多线程

单例，是因为不可能每个人访问，都创建一个servlet对象，堆压力会很大。这个对象中的成员变量，就成了“共享数据”，所以会产生多线程安全问题。尽量不要在servlet类中使用成员变量。

## 重要对象

### ServletConfig

**创建时机**：init(ServletConfig config),说明在调用init方法之前创建。

**作用**：一个ServletConfig对象就封装了当前servlet的配置信息。

**功能即所存信息**：

![image-20200417001519681](/image-20200417001519681.png)

```java
<servlet>
    <!--  servlet初始化参数配置-->
    <init-param>
    	<param-name>path</param-name>
    	<param-value>e:/bbs.txt</param-value>
    </init-param>
</servlet>
```



### ServletContext

**创建时机**：在tomcat服务器加载完当前web应用后创建出来

**作用**：表示当前的web应用环境信息，一个web应用只会创建一个ServletContext对象。
			获取ServletContext对象：查看**GenericServlet**源码：通过ServletConfig对象来获取到ServletContext对象的.
![image-20200417004229025](/image-20200417004229025.png)

**功能**：非常之多,具体看源码。

1. 获取web应用的全局参数

   ```java
   <!-- web应用全局的参数配置 -->
   <context-param>
   	<param-name>AAA</param-name>//里面的写法和ServletConfig一样
   	<param-value>AAA's value</param-value>
   </context-param>
   ```

2. 作域对象保存数据

## 转发和重定向

- 转发

```java
this.getServletContext().getRequestDispatcher("/xxxServlet").forward(request, response);
简写：request.getRequestDispatcher("/GetDateServlet").forward(request, response);
```

- 重定向：**response**.sendRedirect(路径);
  区别：

```java
转发是服务器行为，重定向是浏览器行为.
请求重定向：
    1）地址栏改变为重定向的地址
    2）可以重定向到当前web应用，其他web应用，甚至是其他站点资源。
    3）处于两次不同的请求。不可以使用request域对象来共享数据。
请求转发：
    1）地址栏不会改变。
    2）只能转发到当前web应用内部资源。
    3）处于同一次请求。可以使用request域对象来共享数据
```

<img src="/wps4.jpg" alt="img" style="zoom:67%;" />

## 路径

### 映射规则

| 规则                         |                     |
| ---------------------------- | ------------------- |
| 精确匹配                     | /hello  /demo/order |
| 路径模糊匹配                 | /*   /hello/*       |
| 前缀模糊匹配                 | *.jsp               |
| 默认匹配(**DefaultServlet**) | /                   |

**优先级**： 精确匹配  >  路径模糊匹配  >  后缀模糊匹配  >  默认匹配

**需要注意的问题**

1. 路径匹配和扩展名匹配无法同时设置  eg: /order/*.action 这是非法的

2. **/***  和 **/** 的区别

***两者都会拦截所有资源***，/* 属于路径模糊匹配，优先级很高，所以/*往往是用在Filter，而/优先级低，由于比JspServlet的匹配路径\*.jsp低，所以不会拦截.jsp。

任何访问（无论静态、jsp、servlet等等）都是会经过tomcat服务器，由servlet来处理。

 ***参考：***https://juejin.im/post/5af3b6cf518825671d20939a

附上SpringMvc做静态资源映射的三种办法：

参考网站：https://www.cnblogs.com/caoyc/p/5639078.html

一：激活Tomcat的defaultServlet来处理静态文件

```xml
<servlet-mapping>
	<servlet-name>default</servlet-name>
	<url-pattern>*.jpg</url-pattern>
<servlet-mapping>
    css、js等等其他静态资源同理
```

二：在spring3.0.4以后版本提供了mvc:resources 

<mvc:resources mapping="/images/**" location="/images/" />

mapping指要映射到哪里，location指哪些地址要被映射

三：使用\<mvc:default-servlet-handler/>

一行搞定所有

### 缺省路径	

在**tomcat的%conf%web.xml**中有配置了一个DefaultServlet，url-pattern就是：/

**浏览器输入一个资源名称时，查找资源的顺序是：**

​			1）首先，在当前web应用下的web.xml文件中查找是否有匹配的url-pattern	

​			2）如果匹配到，执行对应的servlet（动态资源）

​			3）如果没有匹配到，就交给tomcat服务器的DefaultServlett去处理

​			4）DefaultServlet会到当前web应用下读取对应名称的静态资源文件。

​			5）如果读到对应的静态资源文件，那么就把内容返回给浏览器

​			6）如果读不到对应的静态资源文件，那么就返回404的错误页面。

# ==Filter==

> Servlet过滤器

## 作用

对请求和响应进行过滤

# ==Listener==

> Servlet监听器

观察者设计模式，web程序中的监听器主要用于对 HttpSession、ServletRequest、ServletContext进行监控。

## 种类

 servlet规范中共有 8 种监听器(接口),可分为三类:

### 1. 生命周期监听器

- ServletRequestListener
- HttpSessionListener
- ServletContextListener

### 2. 属性监听器

- ServletRequestAttributeListener 
- HttpSessionAttributeListener 
- ServletContextAttributeListener    

### 3. Session固有监听器

- HttpSessionBindingListener
- HttpSessionActivationListener

---

# ==会话管理==

web应用程序，是基于http协议进行传输数据的。Http协议是无状态的协议(此处不涉及长连接场景)，无状态就等于每次请求对于服务器来说，都是一次**陌生**的请求。所以就引入了**会话管理机制**；

**会话管理**: 管理 浏览器客户端  和 服务器端 之间会话过程中产生的会话数据。

引入：**context**域，全局唯一；**request**域，重定向场景下，不能共享数据；都不适合保存会话数据。

## Cookie

### 创建机制

1. 服务器创建Cookies，通过**set-cookie响应头**发送给客户端；

2. 客户端得到cookie后，保存在内存/硬盘中；（**客户端保存cookie**）

3. 再次访问该域名时，携带此cookie数据。

### 特点

1. 数据保存在客户端
2. 数据可被修改不安全
3. 会话数据容量有限制

## Session

> Session是用于服务器端记录客户端状态的其中一种机制，Session相当于程序在服务器上建立的一份会话档案。

### 创建机制

**Session对象是在客户端第一次请求服务器Servlet的时候底层自动创建的，名为JSESSIONID的Cookie**，只访问HTML、IMAGE等静态资源并不会创建Session,因为不需要访问服务器。

### 特点

1. 会话数据放在服务器端；
2. 数据类型任意类型，没有大小限制的；
3. 相对安全
4. Session对象其实就是“域对象”

---

- 