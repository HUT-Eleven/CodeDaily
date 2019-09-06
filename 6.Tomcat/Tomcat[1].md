#### 1.2 服务器

```
从物理上来说，就是一台PC机器，配置比较高。不同功能衍生出了不同的服务器，例如：
1.web服务器：在PC机器安装web服务软件，提供web服务
2.数据库服务器：在PC机器安装了数据库软件，提供数据管理服务
3.邮件服务器：在PC机器上安装了可以收发邮件服务软件
```



#### 1.3 web服务软件

```
web服务软件：也说成web服务器,	最大作用就是： 把本地资源文件共享给外部访问
javaweb： B/S   浏览器- >web服务软件
```



# 2.Tomcat服务器

#### 1 tomcat服务器如何共享文件

```java
规则：把文件拷贝到webappps目录下，不能单独共享文件，必须以目录（网站）形式共享

URL：统一资源定位符。用于定位基于http协议的资源。

http协议执行流程:
        1) 本地hosts文件，  ip地址 域名 （c:/windows/System32/drivers/etc/hosts）
        2）在hosts文件中找不到，到网络运营商的DNS服务器中找域名对应的IP地址。
        3）找到，访问对应的ip地址的PC机器.
```

#### 2 tomcat启动常见问题

```
tomcat的启动步骤：startup.bat-->查找JAVA_HOME环境变量-->查找CATALINA_HOME环境变量
1）闪退
        原因： tomcat服务器是用java写的，启动时需要JVM运行，所以会在本地环境变量中查找一个叫JAVA_HOME的环境变量。
        解决办法： 在本地环境变量中添加JAVA_HOME
        		JAVA_HOME= C:\Program Files\Java\jdk1.6.0_30 （不要加bin）		
2）CATALINA_HOME环境变量
		原因： tomcat在启动后会通过CATALINA_HOME环境变量加装tomcat的根目录下的文件（例如conf、webapps）
        解决办法：建议不要设置CATALINA_HOME环境变量,它自动会在所点击startup.bat所在目录中。
        注意：安装版的tomcat会自动设置CATALINA_HOME环境变量 
```

####  3 Tomcat服务器目录结构（7个）

```
|-bin:存放tomcat操作命令。bat是window版本，sh是linux版本。
            startup.bat： 等价于命令窗口中调用catalina.bat start
            shutdown.bat  : catalina.bat stop
|-conf: 存放tomcat服务器软件的配置文件。server.xml文件是核心配置文件。
|-lib：支撑tomcat软件运行的jar包。(因为tomcat本身就是用java开发的)
|-logs:存放日志信息。出现错误可以找该目录
|-temp:存放临时文件。
|-webapps： 存放web应用的目录
|-work：tomcat运行目录。存放jsp页面翻译和编译后的文件。
```

#### 4 web应用目录结构

```
|-webapps：存放各种web应用
    |-WebRoot（名称自定义）： 根目录。对应一个web应用。
        |-静态资源： html+css+javascript+images+xml
        |-WEB-INF： 目录
            |-classes： (可选) 目录。存放class字节码
            |-lib： （可选）目录。存放jar包。不能有子目录，全部jar包放在根目录下。
            |-web.xml：web应用的配置文件。
注意：
1）不做任何配置的情况下，WEB-INF目录下的文件不能直接通过浏览器访问。在web.xml文件中进行配置，那么WEB-INF目录下的内容就可以被外部访问到！！！

总结：webapps目录中是存放我们做的网站（web应用），每个web应用都用一个目录（webRoot名称自定义）存放，webRoot下可以存放“静态资源”+“WEB-INF",其中WEB-INF目录中的classes目录用来存放class文件，lib目录存放jar包，web.xml文件是配置文件。
```

#### 5 web应用部署三种方法

**web应用想要运行，首先要部署，部署的目的：是为了让tomcat服务软件能够找到你所写的web应用。**

1）直接把web应用拷贝到webapps目录下

```java
补充知识：webapps目录下的ROOT目录是tomcat服务软件的默认访问web应用，那个猫的网页就是在ROOT目录下“index.html”(主页)，访问ROOT目录是不需要指明web应用目录，所以直接写“http://localhost:8080"意为：访问ROOT目录下的主页地址，这个主页地址可以在ROOT/WEB-INF/web.xml中修改.
再补充：浏览网页服务默认的端口号都是80，如果在server.xml文件中把端口号改成80，就连端口号都不用写了。
```



2)配置虚拟网站+修改server.xml

```java
<Host>      
	<Context docBase="C:\projects\myweb" path="/itcast"/>
</Host>
注释：	docBase: web应用所在的绝对路径位置。 path: 访问web应用使用的名称。名称可以自定义

注意：如果path为空字符串，那么也不需要名称就可以访问该web应用，而且优先于ROOT应用。

补充理解：可以理解为先根据docBase找到web应用的所在目录，在根据path找到web应用。
```

弊端：需要修改server.xml核心配置文件，风险较高。

3）配置虚拟网站+添加配置文件（推荐使用）

```
在%tomcat%/conf/Catalina/localhost目录下，添加xxxx.xml文件(这个文件名就是要访问的web应用名称)
<?xml version="1.0" encoding="utf-8"?>
<Context docBase="C:\projects\myweb"/>

补充理解：可以理解为文件名拿到web应用的名字，在进入这个文件找这个web应用的所在目录，然后执行该目录下的web应用。
```

#### 6 配置站点

站点和网站之间的关系：一个站点底下多个网站。（例如：webapps就是一个站点，它的底下有多个网站）

```
1）新建一个站点目录，拷贝其路径
2）修改%tomcat%/conf/server.xml
    <Host name="hut.eleven.com"  appBase="C:\newsite"
        unpackWARs="true" autoDeploy="true"
        xmlValidation="false" xmlNamespaceAware="false">
    </Host>
	name: 站点的名称     appBase：站点的根目录
3）修改本地域名和ip的映射文件hosts文件
127.0.0.1   hut.eleven.com

访问：http://hut.eleven.com:8080/bbs/adv.html
```

# 3.手动开发动态网页

```
动态网页：当用户多次访问该资源时，资源的源代码可能会发生改变的资源。（servlet+jsp）

静态网页：当用户多次访问该资源时，资源的源代码永远不会发送改变的资源。（html+css+javascript）
```

Servlet技术： 用java语言开发动态资源的技术。

```
1）编写继承HttpServlet的servlet程序。
2）把servlet交给web服务器软件运行
    2.1 把class字节码文件（包括包）拷贝到web应用的WEB-INF/classes目录下
    2.2 在web应用的web.xml文件配置servlet
3）浏览器访问servlet：http://10.1.7.156:8080/myweb/hello
				
web.xml文件代码栗子：
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" version="2.5">

	<!--配置一个servlet -->
	<servlet>
		<!-- servet的内部名称。可以自定义-->
		<servlet-name>HelloServlet</servlet-name>
		<!--- servlet程序的全名：包名+简单类名 -->
		<servlet-class>gz.itcast.b_servlet.HelloServlet</servlet-class>
	</servlet>

	<!-- servlet的映射配置-->
	<servlet-mapping>
		<!--servet的内部名称，和上面内部名称保持一致！！！ -->	
		<servlet-name>HelloServlet</servlet-name>
		<!-- servlet映射路径： 表示在浏览器上访问该servlet程序的名称。该名称可以自定义 -->
		<url-pattern>/hello</url-pattern>
	</servlet-mapping>
</web-app>
```



# 3.使用工具开发动态网页

```
1）创建一个web proejct
2）（可选）在WebRoot下编写静态网页（html+css+javascript）
3）在src目录下编写servlet动态网页：右键src- > new -> 点击”servlet“。url (可以设为/+类名，比较好记)
	点击finished之后，生成servlet的代码和web.xml的配置信息
4）关联tomcat服务器（就是把tomcat所在目录告诉eclipse）
5）部署项目（就是把eclipse中写的web应用复制到tomcat目录中的webapps目录中）
6）eclipse中可以直接启动tomcat，浏览器访问测试。
```



```
其他知识：
4.继承HttpServlet类之后，其中的doget()、dopost()方法可以看做是一个被触发的动作，当浏览发出请求时，请求会被封装成对象（响应也是会被封装成对象）。
```



