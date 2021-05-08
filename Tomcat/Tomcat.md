---
typora-copy-images-to: ../pictures
typora-root-url: ../pictures
---

# Tomcat

## 1. 基础概念

### 1.1 服务器

从物理上来说，就是一台电脑，配置比较高。不同功能衍生出了不同的服务器，例如：
1.web服务器：在PC机器安装web服务软件，提供web服务
2.数据库服务器：在PC机器安装了数据库软件，提供数据管理服务

### 1.2 web服务软件

web服务软件：也说成web服务器,	最大作用就是：把本地资源文件共享给外部访问。

常见的有：Tomcat、Jboss、webLogic、GlassFish...

## 2.Tomcat使用

> **tomcat是java语言开发。**
> **解压即可使用**

### 2.1 Tomcat目录结构

```
|-bin:存放tomcat操作命令。bat是window版本，sh是linux版本。
            startup.bat： 等价于catalina.bat start/run
            shutdown.bat  : catalina.bat stop
|-conf: 存放tomcat服务器软件的配置文件。
	- server.xml 核心配置文件
	- ...
|-lib：tomcat运行时需要的第三方jar包。(因为tomcat本身就是用java开发的)
	- servlet.jar
	- jsp.jat
	- ...
|-logs:存放日志信息。
|-temp:存放临时文件。
|-webapps： 存放web应用的目录
	- WEB-INF
		- web.xml
|-work：tomcat运行目录。存放jsp页面翻译和编译后的文件。
```

### 2.2 tomcat启动常见问题

```
tomcat的启动步骤：startup.bat-->查找JAVA_HOME环境变量-->查找CATALINA_HOME环境变量
1）闪退
        原因： tomcat服务器是用java写的，启动时需要JVM运行，所以会在本地环境变量中查找一个叫JAVA_HOME的环境变量。
        解决办法： 在本地环境变量中添加JAVA_HOME
        		JAVA_HOME= C:\Program Files\Java\jdk1.6.0_30 （不要加bin）		
2）CATALINA_HOME环境变量
		原因： 点击start.sh后会先加载JAVA_HOME环境变量，再加载CATALINA_HOME环境变量（tomcat的家）
        解决办法：建议不要设置CATALINA_HOME环境变量,它自动会在所点击startup.bat所在目录中。
        注意：安装版的tomcat会自动设置CATALINA_HOME环境变量 
```

### 2.3 部暑web工程的方式

第一种：直接复制到webapps下，不能单独共享文件，必须以**目录**（网站）形式共享.

```xml
补充知识：webapps目录下的ROOT目录是tomcat服务软件的默认访问web应用，那个猫的网页就是在ROOT目录下“index.html”(主页)，访问ROOT目录是不需要指明web应用目录，所以直接写“http://localhost:8080"意为：访问ROOT目录下的主页地址，这个主页地址可以在ROOT/WEB-INF/web.xml中修改.
再补充：浏览网页服务默认的端口号都是80，如果在server.xml文件中把端口号改成80，就连端口号都不用写了。
```

第二种：在Tomcat的\conf\Catalina\localhost下创建文件abc.xml：

```xml
<!-- Context 表示一个工程上下文 path 表示工程的访问路径:/abc docBase 表示你的工程目录在哪里
 注意文件名与path一致--> 
<Context path="/abc" docBase="E:\book" /> path可省略
```

第三种：配置虚拟网站+修改server.xml

```java
<Host>      
	<Context docBase="C:\projects\myweb" path="/itcast"/>
</Host>
注释：	docBase: web应用所在的绝对路径位置。 path: 访问web应用使用的名称。名称可以自定义
注意：如果path为空字符串，那么也不需要名称就可以访问该web应用，而且优先于ROOT应用。
补充理解：可以理解为先根据docBase找到web应用的所在目录，在根据path找到web应用。
弊端：需要修改server.xml核心配置文件，风险较高。
```

### 2.4 web应用目录结构

```
|-webapps：存放各种web应用
    |-WebRoot（名称自定义）： 根目录。对应一个web应用。
        |-静态资源： html+css+js+images+xml
        |-WEB-INF： 目录(也为安全目录，WEB-INF目录下的文件不能直接通过浏览器访问)
            |-classes： (可选) 目录。存放class字节码
            |-lib： （可选）目录。存放jar包。不能有子目录，全部jar包放在根目录下。
            |-web.xml：web应用的配置文件。
```

### 2.5 配置站点

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

## 3. tomcat核心配置

待补充

## 4. 源码分析