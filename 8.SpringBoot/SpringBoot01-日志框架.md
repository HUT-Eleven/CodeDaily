---
typora-copy-images-to: ./images
typora-root-url: ./images
---

## 1. 日志实现框架使用简介

### 前言引导

1. 目前流行的日志**实现**框架有：

    - JUL（jdk自带的日志框架，在java.util.logging中）
    - log4j（也叫log4j1）
    - log4j2
    - logback
2. 目前用于实现日志统一的框架（**接口门面**）：
    - JCL（apache Jakarta commons-logging）
    - SLF4J（Simple Logging Facade for JAVA，java简单日志门面）

| 日志门面                                                     | 日志实现                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| JCL(Jakarta Commons Logging) <br />SLF4j(Simple Logging Facade for Java) | Log4j <br />JUL(java.util.logging) <br />Log4j2 <br />Logback |

### JUL

#### 使用案例

jdk内置：

```java
import java.util.logging.Level;
import java.util.logging.Logger;

public class Demo_JUL {

    private final static Logger logger = Logger.getLogger(Demo_JUL.class.getName());

    public static void main(String[] args) {
        logger.log(Level.INFO, "这是一条日志");
    }
}
```

### Log4j

#### 使用案例

1. 引入依赖

   ```xml
   <dependency>
       <groupId>log4j</groupId>
       <artifactId>log4j</artifactId>
       <version>1.2.17</version>
   </dependency>
   ```

2. 引入log4j.properties配置文件

   ```properties
   log4j.rootLogger = debug, console
   log4j.appender.console = org.apache.log4j.ConsoleAppender
   log4j.appender.console.layout = org.apache.log4j.PatternLayout
   log4j.appender.console.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss} %m%n
   # 本次不在此深入了解配置文件的内容
   ```

3. 使用

   ```java
   import org.apache.log4j.Logger;
   
   public class Demo_Log4j {
       private final static Logger LOGGER = Logger.getLogger(Demo_Log4j.class);
       public static void main(String[] args) {
           LOGGER.info("log4j info messgae");
       }
   }
   ```

### log4j2

#### 背景介绍

log4j2也是日志的实现框架，但曾经也想像SLF4j,commons-logging一样，可以充当日志门面，来统一日志市场。

所以log4j2分成2个部分：

- **log4j-api**:	作为日志接口层，用于统一底层日志系统
- **log4j-core**:  作为上述日志接口的实现，是一个实际的日志框架

#### 使用案例

1. 引入依赖

   ```xml
   <!-- 看背景介绍，可知需要导入两个包 -->
   <dependency>
       <groupId>org.apache.logging.log4j</groupId>
       <artifactId>log4j-api</artifactId>
       <version>2.2</version>
   </dependency>
   <dependency>
   	<groupId>org.apache.logging.log4j</groupId>
   	<artifactId>log4j-core</artifactId>
   	<version>2.2</version>
   </dependency>
   ```

2. log4j2.xml配置文件（可支持xml/json/yaml,不支持properties）

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <Configuration status="WARN">
     <Appenders>
       <Console name="Console" target="SYSTEM_OUT">
         <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
       </Console>
     </Appenders>
     <Loggers>
       <Root level="debug">
         <AppenderRef ref="Console"/>
       </Root>
     </Loggers>
   </Configuration>
   ```

3. 测试

   ```java
   import org.apache.logging.log4j.LogManager;
   import org.apache.logging.log4j.Logger;
   
   public class Demo_Log4j2 {
       private final static Logger LOGGER = LogManager.getLogger(Demo_Log4j2.class);
       public static void main(String[] args) {
           LOGGER.debug("这是log4j2的日志信息");
       }
   }
   ```

### logback

#### 使用案例

1. 引入依赖

   - **logback-core**
   - **logback-classic**
   - **slf4j-api**  （logback原本就是面向SLF4j编写的）

   ```xml
   <dependency> 
   	<groupId>ch.qos.logback</groupId> 
   	<artifactId>logback-core</artifactId> 
   	<version>1.1.3</version> 
   </dependency> 
   <dependency> 
       <groupId>ch.qos.logback</groupId> 
       <artifactId>logback-classic</artifactId> 
       <version>1.1.3</version> 
   </dependency>
   <dependency>
   	<groupId>org.slf4j</groupId>
   	<artifactId>slf4j-api</artifactId>
   	<version>1.7.12</version>
   </dependency>
   ```

2. logback.xml配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
     <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
       <encoder>
         <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
       </encoder>
     </appender>
   
     <root level="DEBUG">          
       <appender-ref ref="STDOUT" />
     </root>  
   </configuration>
   ```

3. 测试

   ```java
   import ch.qos.logback.classic.LoggerContext;
   import ch.qos.logback.core.util.StatusPrinter;
   import org.slf4j.Logger;
   import org.slf4j.LoggerFactory;
   
   public class Demo_Logback {
       private static final Logger logger = LoggerFactory.getLogger(Demo_Logback.class);
   
       public static void main(String[] args) {
           if (logger.isDebugEnabled()) {
               logger.debug("slf4j-logback debug message");
           }
           if (logger.isInfoEnabled()) {
               logger.debug("slf4j-logback info message");
           }
           if (logger.isTraceEnabled()) {
               logger.debug("slf4j-logback trace message");
           }
           LoggerContext lc = (LoggerContext) LoggerFactory.getILoggerFactory();
           StatusPrinter.print(lc);
       }
   }
   ```

## 2. 日志门面集成日志框架

### 起因

> 各常用框架如spring、mybatis、hibernate等等，使用的日志实现框架可能是不一样的，这样在系统应用中就可能出现出错，或者日志格式变化等问题。并且使用具体的日志框架也不便于应用系统之后更换日志系统，所以==日志门面==应运而生，也即面向接口编程。
>
> 现在市面上常用的日志门面：SLF4J、JCL (apache Jakarta commons logging)

### JCL

#### 使用案例

1. 依赖

   ```xml
   <dependency>
   	<groupId>commons-logging</groupId>
   	<artifactId>commons-logging</artifactId>
   	<version>1.2</version>
   </dependency>
   ```

2. 测试

   ```java
   import org.apache.commons.logging.Log;
   import org.apache.commons.logging.LogFactory;
   
   public class Demo05_CommonsLogging {
       private final static Log LOGGER = LogFactory.getLog(Demo05_CommonsLogging.class);
       public static void main(String[] args) {
           if(LOGGER.isTraceEnabled()){
               LOGGER.trace("commons-logging-jcl trace message");
           }
           if(LOGGER.isDebugEnabled()){
               LOGGER.debug("commons-logging-jcl debug message");
           }
           if(LOGGER.isInfoEnabled()){
               LOGGER.info("commons-logging-jcl info message");
           }
       }
   }
   ```

#### 源码分析

主要就是分析：

1. 如何得到Log对象？
2. Log对象的具体是哪个实现类？

```java
private final static Log LOGGER = LogFactory.getLog(Demo05_CommonsLogging.class);

进入getLog方法：
public static Log getLog(Class clazz) throws LogConfigurationException {
    return getFactory().getInstance(clazz);
}
```

从这段代码可以看出，获取Log，两个步骤：

1. getFactory()得到LogFactory对象；
2. getInstance得到Log实例；

- **==获取LogFactory==**

  > 按以下顺序去获取LogFactory

  1. 系统属性中获取，如下:

     ```java
     System.getProperty("org.apache.commons.logging.LogFactory")
     ```

  2. 使用java的SPI机制，来搜寻对应的实现

     对于java的SPI机制，详细内容可以自行搜索，这里不再说明。搜寻路径如下：

     ```java
     META-INF/services/org.apache.commons.logging.LogFactory
     ```

  3. 从commons-logging的配置文件中读取

     ```java
     commons-logging也是可以拥有自己的配置文件的，名字为commons-logging.properties，只不过目前大多数情况下，我们都没有去使用它。如果使用了该配置文件，尝试从配置文件中读取属性"org.apache.commons.logging.LogFactory"对应的值
     ```

  4. 最后就是使用默认的org.apache.commons.logging.impl.**LogFactoryImpl**,这是commons-logging中默认的对LogFactory的实现类。

     <img src="/image-20200613204307544.png" alt="image-20200613204307544" style="zoom: 67%;" />

- **==获取Log实例==**

  > 按以下顺序去获取Log实例

  1. 从commons-logging的配置文件中寻找Log实现类的类名。属性为"org.apache.commons.logging.Log"；

  2. 从系统属性中寻找Log实现类的类名
  
     ```java
   System.getProperty("org.apache.commons.logging.Log"); -Dorg.apache.commons.logging.Log=xxxxxx
     ```

  3. 从classesToDiscover属性中寻找，也即Log的默认实现类：

     classesToDiscover属性值如下：它会尝试根据下面的类名，依次进行创建，如果能创建成功，则使用该Log，然后返回给用户。
  
     ```java
     private static final String[] classesToDiscover = {
         LOGGING_IMPL_LOG4J_LOGGER,		// "org.apache.commons.logging.impl.Log4JLogger"
         "org.apache.commons.logging.impl.Jdk14Logger",
         "org.apache.commons.logging.impl.Jdk13LumberjackLogger",
         "org.apache.commons.logging.impl.SimpleLog"
     };
     ```

<img src="/image-20200613204307544.png" alt="image-20200613204307544" style="zoom:67%;" />

----------------==略过commons-logging与各日志实现框架的集成案例及原理分析==-------附上[地址](https://my.oschina.net/pingpangkuangmo/blog/407895)-----------------------

### SLF4J

#### 使用案例

1. 依赖

   ```xml
   <dependency>
       <groupId>org.slf4j</groupId>
       <artifactId>slf4j-api</artifactId>
       <version>1.7.12</version>
   </dependency>
   ```

2. 测试

   ```java
   import org.slf4j.Logger;
   import org.slf4j.LoggerFactory;
   
   public class Demo06_slf4j {
       private static Logger logger= LoggerFactory.getLogger(Demo06_slf4j.class);
   
       public static void main(String[] args){
           if(logger.isDebugEnabled()){
               logger.debug("slf4j-log4j debug message");
           }
           if(logger.isInfoEnabled()){
               logger.debug("slf4j-log4j info message");
           }
           if(logger.isTraceEnabled()){
               logger.debug("slf4j-log4j trace message");
           }
       }
   }
   ```

#### 源码分析

有空再看： https://my.oschina.net/pingpangkuangmo/blog/408382

## 3. 大总结

### jar包总结

- log4j:

  - log4j：log4j的全部内容

- log4j2:

  - log4j-api:log4j2定义的API
  - log4j-core:log4j2上述API的实现

- logback:

  - logback-core: logback的核心包
  - logback-classic：logback实现了slf4j的API
  - slf4j-api：slf4j的API

- commons-logging:

  - commons-logging:commons-logging的原生全部内容
  - log4j-jcl:commons-logging到log4j2的桥梁
  - jcl-over-slf4j：commons-logging到slf4j的桥梁

- 某个实际的日志框架转向slf4j：

  场景介绍：如 使用log4j1的API进行编程，但是想最终通过logback来进行输出，所以就需要先将log4j1的日志输出转交给slf4j来输出，slf4j再交给logback来输出。将log4j1的输出转给slf4j，这就是**log4j-over-slf4j**做的事

  这一部分主要用来进行实际的日志框架之间的切换（下文会详细讲解）

  - jul-to-slf4j：jdk-logging到slf4j的桥梁
  - log4j-over-slf4j：log4j1到slf4j的桥梁
  - jcl-over-slf4j：commons-logging到slf4j的桥梁
  - 对于logback，则不需要转换包来转换到slf4j，因为本身就是面向slf4j开发的。

- slf4j转向某个实际的日志框架:

  场景介绍：如 使用slf4j的API进行编程，底层想使用log4j1来进行实际的日志输出，这就是slf4j-log4j12干的事。

  - slf4j-jdk14：slf4j到jdk-logging的桥梁
  - slf4j-log4j12：slf4j到log4j的桥梁
  - log4j-slf4j-impl：slf4j到log4j2的桥梁
  - logback-classic：slf4j到logback的桥梁
  - slf4j-jcl：slf4j到commons-logging的桥梁

![](/8.slf4j.jpg)

### 集成总结

### 日志框架之间的切换

#### log4j->logback

> 思路：需要先将log4j的日志输出转交给slf4j来输出，slf4j再交给logback来输出。

1. 去掉log4j的jar包
2. 加入以下包：
   - log4j-over-slf4j： log4j转接到slf4j上
   - slf4j-api
   - logback-classic && logback-core
3. logback的配置文件

#### JUL->logbak

#### JCL->logback

#### 实际日志场景图解

> 左1：其他日志转为logback输出
>
> 左2：其他日志转为JUL输出
>
> 右1：其他日志转为log4j输出

![1551703080968](.\统一日志框架.png)



