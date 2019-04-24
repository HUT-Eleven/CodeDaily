# 一、Spring Boot入门

## 1、Spring Boot简介

简化新Spring应用的初始搭建以及开发过程。

## 2、微服务

微服务：一个应用应该是一组小型服务，可以通过HTTP的方式进行互通

单体应用是“ALL IN ONE”，微服务是每个功能元素最终都是一个可以独立替换和升级的软件单元。

## 3、环境准备

### 3.1、更改MAVEN默认的jdk版本

```xml
<!-- 配置JDK版本 -->
<profile>    
    <id>jdk18</id>    
    <activation>    
        <activeByDefault>true</activeByDefault>    
        <jdk>1.8</jdk>    
    </activation>    
    <properties>    
        <maven.compiler.source>1.8</maven.compiler.source>    
        <maven.compiler.target>1.8</maven.compiler.target>    
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>    
    </properties>     
</profile>
```



## 4、Spring Boot的Hello World

### 1、创建一个Maven工程



### 2、导入Spring Boot的相关依赖

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.3.RELEASE</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!--SpringBoot单元测试模块-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 3、编写个主程序

```java
@SpringBootApplication
public class SpringBoot01HelloQuickApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBoot01HelloQuickApplication.class, args);
    }
}
```

### 4、编写相应的Controller和Service

```java
@Controller
public class HelloController {

    @ResponseBody
    @RequestMapping("/hello")
    public  String  hello(){
        return "hello world";
    }
}
```

### 5、启动主程序

第一种：直接run Java Application

第二种：Spring-boot:run

### 6、简化部署

在pom.xml文件中，导入build插件

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

运行：package，打成jar包

到jar包的目录下，运行**java -jar**  包名称，即可运行

## 5、HelloWorld深度理解

### 1.POM.xml文件

#### 1、父项目

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.1.RELEASE</version>
</parent>
```

这个父项目**spring-boot-starter-parent**又依赖一个父项目

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-dependencies</artifactId>
    <version>2.0.1.RELEASE</version>
    <relativePath>../../spring-boot-dependencies</relativePath>
</parent>
他来真正管理Spring Boot应用里面的所有依赖版本
```

下面有个属性，定义了对应的版本号

```xml
<properties>
    <activemq.version>5.15.3</activemq.version>
    <antlr2.version>2.7.7</antlr2.version>
    <appengine-sdk.version>1.9.63</appengine-sdk.version>
    <artemis.version>2.4.0</artemis.version>
    <aspectj.version>1.8.13</aspectj.version>
    <assertj.version>3.9.1</assertj.version>
    <atomikos.version>4.0.6</atomikos.version>
    <bitronix.version>2.1.4</bitronix.version>
    <build-helper-maven-plugin.version>3.0.0</build-helper-maven-plugin.version>
    。。。。。。。
```

Spring Boot的版本仲裁中心 会自动导入对应的版本

#### 2、场景启动器

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

**spring-boot-starter**：spring-boot的场景启动器

**spring-boot-starter-web:**“web开发场景启动器”（自动导入web开发所依赖的组件）

**spring boot**将所有的**功能场景**都抽取出来，做成一个个的starter(启动器)，只需要在项目里引入这些starter相关场景的所有依赖都会被导入进来，要用什么功能就导入什么场景的启动器。

### 2、主程序入口

```java
@SpringBootApplication
public class SpringBoot01HelloQuickApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBoot01HelloQuickApplication.class, args);
    }
}
```

**以下为1.5.9.RELEASE版本的源码，2.X.X之后有所改变**

**@SpringBootApplication:** 说明这个类是SpringBoot的主配置类，SpringBoot就应该运行这个类的main方法来启动应用	

进入**@SpringBootApplication**注解

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(excludeFilters = {@Filter( type = FilterType.CUSTOM, classes = 		  			{TypeExcludeFilter.class} ), @Filter( type = FilterType.CUSTOM, classes =  				{AutoConfigurationExcludeFilter.class})})
public @interface SpringBootApplication {
```

**@SpringBootConfiguration**：SpringBoot的配置类： 标准在某个类上，表示这是一个SpringBoot的配置类,底层是调用**@Configuration**

​		**@Configuration**:配置类上，来标注这个注解；
配置类 ---- 配置文件，也是容器中的一个组件（@Component）
**@EnableAutoConfiguration**:开启自动配置功能
以前需要自动配置的东西，Spring Boot帮我们自动配置；@EnableAutoConfiguration告诉SpringBoot开启自动
配置功能；这样自动配置才能生效。 

```java
@AutoConfigurationPackage
@Import({AutoConfigurationImportSelector.class})
public @interface EnableAutoConfiguration { 
```

**@AutoConfigurationPackage**:自动配置包
**@Import({Registrar.class})**：底层注解，给容器导入组件；
将主配置类（@SpringBootApplication标注的类）的**所在包及下面所有的子包**里面的所有组件扫描到Spring容器； 

**@Import({AutoConfigurationImportSelector.class})：**
给容器导入组件？ 

AutoConfigurationImportSelector：导入组件选择器 

将所有需要导入的组件以及全类名的方式返回；这些组件将以字符串数组 String[] 添加到容器中；

会给容器非常多的自动配置类，（xxxAutoConfiguration）;就是给容器中导入这个场景需要的所有组件，并配置
好这些组件。 

![1.configuration](.\images\1.configuration.jpg)

```java
protected List<String> getCandidateConfigurations(AnnotationMetadata metadata,
AnnotationAttributes attributes) {
	List<String> configurations =
SpringFactoriesLoader.loadFactoryNames(this.getSpringFactoriesLoaderFactoryClass(),
this.getBeanClassLoader());
	Assert.notEmpty(configurations, "No auto configuration classes found in META‐INF/spring.factories. If you are using a custom packaging, make sure that file is correct.");
	return configurations;
} 
```

`SpringFactoriesLoader.loadFactoryNames(this.getSpringFactoriesLoaderFactoryClass(),`
`this.getBeanClassLoader());` 

Spring Boot在启动的时候从类路径下的META-INF/spring.factorys中获取的EnableAutoConfiguration指定的值；

将这些值作为自动配置类导入到容器中，自动配置就生效了。 ![2.factories](.\images\2.factories.jpg)

J2EE的整体解决方案

org\springframework\boot\spring-boot-autoconfigure\2.0.1.RELEASE\spring-boot-autoconfigure-2.0.1.RELEASE.jar 

## 6、使用Spring Initializer创建一个快速向导 

1.IDEA支持使用Spring Initializer

自己选择需要的组件:例如web

默认生成的SpringBoot项目 

- 主程序已经生成好了，我们只需要完成我们的逻辑


- resources文件夹目录结构

  - static:保存所有的静态文件；js css images

  - templates:保存所有的模板页面；（Spring Boot默认使用嵌入式的Tomcat,默认不支持JSP）；可

    以使用模板引擎（freemarker.thymeleaf）;


  整合Junit报错，推荐直接手动导入junit，不使用maven导入的jar

# 二、配置文件 

## 1、配置文件 

Spring Boot使用全局配置文件，配置文件名是固定的；

- application.properties
- application.yml 

配置文件作用：修改Spring Boot在底层封装好的默认值；

YAML（YAML AIN'T Markup Language）

是一个标记语言

又不是一个标记语言 

**标记语言：**

以前的配置文件；大多数使用的是 xxx.xml文件；

以**数据为中心**，比json、xml等更适合做配置文件



## 2、YAML语法 

### 1、基本语法 

k:(空格)v:表示一堆键值对（空格必须有）；

以缩进来控制层级关系；只要是左对齐的一列数据，都是同一层级的 

```yaml
server:
	port: 9000
	path: /hello 
```

属性和值也是**大小写敏感** 

### 2、值的写法

**字面量：普通的值（数字，字符串，布尔）** 

k: v:字面**直接写**；

字符串默认**不用**加上单引号或者双引号

"":**双引号** 不会转义字符串里的特殊字符；特殊字符会作为本身想要表示的意思

`name:"zhangsan\n lisi"` 输出：`zhangsan换行 lisi`

'':**单引号** 会转义特殊字符，特殊字符最终只是一个普通的字符串数据

`name:'zhangsan\n lisi'` 输出：`zhangsan\n lisi` 

**对象、Map（属性和值）键值对** 

k :v ：在下一行来写对象的属性和值的关系；**注意空格**

对象还是k:v的方式 

```yaml
frends:
	lastName: zhangsan
	age: 20 
```

行内写法 

```yaml
friends: {lastName: zhangsan,age: 18} 
```

**数组（List、Set）:**
用-表示数组中的一个元素 

```yaml
pets:
 ‐ cat
 ‐ dog
 ‐ pig 
```

行内写法 

```yaml
pets: [cat,dog,pig] 
```

**组合变量**

多个组合到一起 

## 3、配置文件值注入 

### 1、@ConfigurationProperties

**作用：读取主配置文件的属性，并通过前缀的方式来指定bean，再注入到javabean中**。

**注意，该注解只读取主配置文件，不能直接读取其他配置文件**

源码中大量用到该注解，配合@EnableConfigurationProperties来完成场景启动器的自动配置

1、application.yml 配置文件 

```yaml
person:
  age: 18
  boss: false
  birth: 2017/12/12
  maps: {k1: v1,k2: 12}
  lists:
   - lisi
   - zhaoliu
  dog:
    name: wangwang
    age: 2
  last-name: wanghuahua
```

`application.properties` 配置文件（二选一） 

```properties
person.age=12
person.boss=false
person.last-name=张三
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```



javaBean 

```java
@Component//只有这个组件是Spring容器中的组件(IOC容器中的对象)，才能使用容器中的功能。
@ConfigurationProperties(prefix = "person")
//上面@Component已经在IOC容器中创建了Person对象，@ConfigurationProperties注解就是指把<b>主配置文件</b>的叫“person”的相关信息，映射到这个容器中Person对象上(注：@ConfigurationProperties默认只加载主配置文件的信息)
public class Person {
    private String lastName;
    private Integer age;
    private Boolean boss;
    private Map<String,Object> maps;
    private List<Object> lists;
    private Dog dog;
```

导入配置文件处理器，以后在主配置文件中编写自定义的javabean的配置就有提示了 

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-configuration-processor</artifactId>
	<optional>true</optional>
</dependency> 
```


### 2、@Value

> **作用：Spring的原生注解，用法还是一样，只要是Spring容器读到的配置文件，都可以注入。**

```java
@Component
public class Person {
    /**
     * <bean class="Person">
     *     <property name="lastName" value="${key}从环境变量/#{spEL}/字面量"></property>
     * </bean>
     */
    @Value("${person.last-name}")	//${key}从环境变量
    private String lastName;
    @Value("#{11*2}")				//#{spEL}
    private Integer age;
    @Value("true")					//字面量
    private Boolean boss;
```

|          | @ConfigurationProperties | @Value |
| :------: | :----------------------: | :----: |
|    功能    |        批量注入配置文件属性        |  单个指定  |
| 松散绑定(语法) |            支持            |  不支持   |
|   spEL   |           不支持            |   支持   |
| JSR303校验 |            支持            |  不支持   |
|   复杂类型   |            支持            |  不支持   |

> 松散语法：javaBean中last-name(或者lastName) -->application.properties中的last-name;
>
> spEL语法：#{11*2} 
>
> JSR303：@Value会直接忽略，校验规则

JSR303校验：

```java
@Component
@ConfigurationProperties(prefix = "person")
@Validated
public class Person {
    @Email
    private String lastName;
```

复杂类型栗子：

```java
@Component
public class Person {
    /**
     * <bean class="Person">
     *     <property name="lastName" value="字面量/${key}从环境变量/#{spEL}"></property>
     * </bean>
     */
    private String lastName;
    private Integer age;
    private Boolean boss;
   // @Value("${person.maps}")
    //@Value会报错，不支持复杂类型
    private Map<String,Object> maps;
```



**使用场景分析**

​	如果说，我们只是在某个业务逻辑中获取一下配置文件的某一项值，使用@Value；

如果专门编写了一个javaBean和配置文件进行映射，我们直接使用@ConfigurationProperties

举栗子：

1、编写新的Controller文件

```java
@RestController
public class HelloController {

    @Value("${person.last-name}")
    private String name;
    @RequestMapping("/hello")
    public  String sayHello(){
        return "Hello"+ name;
    }
}
```

2、配置文件

```properties
person.age=12
person.boss=false
person.last-name=李四
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```

3、测试运行

访问 localhost:9000/hello

结果为`Hello 李四`

### 3、@PropertySource
> **作用：加载其他properties配置文件，配合@Value注入**

1、新建一个person.properties文件

```properties
person.age=12
person.boss=false
person.last-name=李四
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```

2、在javaBean中加入@PropertySource注解

```java
@PropertySource(value = {"classpath:person.properties"})
@Component
//@ConfigurationProperties(prefix = "person")
public class Person {
    private String lastName;
```

### 4、@ImportResource（不实用）

> 作用：**导入Spring配置文件**，并且让这个配置文件生效
>

1、新建一个Spring的配置文件，bean.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="HelloService" class="com.wdjr.springboot.service.HelloService"></bean>
</beans>
```

2、编写测试类，检查容器是否加载Spring配置文件写的bean

```java
@Autowired
ApplicationContext ioc;

@Test
public void testHelloService(){
    boolean b = ioc.containsBean("HelloService");
    System.out.println(b);
}
```

> import org.springframework.context.ApplicationContext;

3、运行检测

**结果为false，没有加载配置的内容**

4、使用@ImportResource注解

将@ImportResource标注在主配置类上

```java
@ImportResource(locations={"classpath:beans.xml"})
@SpringBootApplication
public class SpringBoot02ConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBoot02ConfigApplication.class, args);
    }
}
```

5、再次运行检测

**结果为true**

缺点：每次指定xml文件太麻烦

SpringBoot推荐给容器添加组件的方式：

1、配置类=====Spring的xml配置文件（old）

2、全注解方式@Configuration+@Bean（new）

![4.MyAppConfig](.\images\4.MyAppConfig.jpg)



```java
/**
 * @Configuration：指明当前类是一个配置类；就是来代替之前的Spring配置文件
 *
 * 在配置文件中用@bean标签添加组件
 */

@Configuration
public class MyAppConfig {

    //将方法的返回值添加到容器中；容器这个组件id就是方法名
    @Bean
    public HelloService helloService01(){
        System.out.println("配置类给容器添加了HelloService组件");
        return new HelloService();
    }
}
```

```java
@Autowired		//直接获得容器（测试时非常实用的方法）
ApplicationContext ioc;

@Test
public void testHelloService(){
    boolean b = ioc.containsBean("helloService01");
    System.out.println(b);
}
```

 ***容器这个组件id就是方法名*** 

## 4、配置文件占位符

#### 1、随机数

```properties
${random.value} 、${random.int}、${random.long}
${random.int(10)}、${random.int[100,200]}
```

#### 2、获取配置值

```properties
person.age=${random.int}
person.boss=false
person.last-name=张三${random.uuid}
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=${person.last-name}'s wanghuahu
person.dog.age=15
```

没有声明`person.last-name`会报错，新声明的需要加默认值

```properties
person.age=${random.int}
person.boss=false
person.last-name=张三${random.uuid}
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=${person.hello:hello}'s wanghuahu
person.dog.age=15
```

结果：输出`hello's wanghuahua`

## 5、Profile

### 1、多Profile文件

我们在主配置文件编写的时候，文件名可以是 application-{profile}.properties/yml

- application.properties
- application-dev.properties
- application-prod.properties

**默认使用application.properties，可在主配置文件通过spring.profiles.active=xxx来激活其他主配置文件**

```properties
#激活application-dev.properties
spring.profiles.active=dev
```

### 2、YAML文档块

.yml文件的特有功能，这就相当于写多个properties文件

```yaml
#文档1
server:
  port: 8081
#激活dev文档块
spring:
  profiles:
    active: dev

---
#文档2
server:
  port: 9000
spring:
  profiles: dev

---
#文档3
server:
  port: 80
spring:
  profiles: prod
```

### 3、激活指定profile

1、在配置文件中激活

2、命令行：

--spring.profiles.active=dev

![5.comandLine](.\images\5.comandLine.jpg)

优先级大于配置文件

打包 成jar后

`java -jar spring-boot-02-config-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev`

虚拟机参数

`-Dspring.profiles.active=dev`

## 6、主配置文件位置

SpringBoot启动扫描以下位置的application.properties或者application.yml文件作为Spring boot的默认配置文件

- file:./config/   --项目根目录的config目录
- file./              --项目根目录
- classpath:/config/
- classpath:/

优先级**从高到低顺序**，高优先级会覆盖低优先级的相同配置；互补配置

也可以通过spring.config.location来改变默认配置

> ```
> server.servlet.context-path=/boot03
> ```

注：spring boot1x 是server.context.path=/boot02



![7.priority](.\images\7.priority.jpg)

还可以通过spring.config.location来改变配置文件的位置

项目打包好了以后，可以使用**命令行参数**的形式，启动项目的时候来指定配置文件的新位置；**指定配置文件和默认的配置文件会共同起作用，互补配置**(配置文件之间不会覆盖，只会互补)

`java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar --spring.config.location=E:/work/application.properties`

运维比较有用，从外部加载，不用修改别的文件

## 7.从外部引入主配置

> 方便运维

**SpringBoot也可以从以下位置加载配置；优先级从高到低；互补配置**

1. 命令行参数

   java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar --server.port=9005 --server.context-path=/abc

   中间一个空格

2. 来自java:comp/env的JNDI属性

3. java系统属性（System.getProperties()）

4. 操作系统环境变量

5. RandomValuePropertySource配置的random.*属性值


   **优先加载profile,    由jar包外到jar包内**

6. **jar包外部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

7. **jar包内部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

8. **jar包外部的application.properties或application.yml(带Spring.profile)配置文件**

9. **jar包内部的application.properties或application.yml(不带spring.profile)配置文件**


10. @Configuration注解类的@PropertySource

11. 通过SpringApplication.setDefaultProperties指定的默认属性

[官方文档](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#boot-features-external-config)

## 8、自动配置

配置文件到底怎么写？

[Spring的所有配置参数](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#common-application-properties)

自动配置原理很关键

### 1、自动配置原理

1）、SpringBoot启动的时候加载主配置类，开启自动配置功能:**@EnableAutoConfiguration**

2）、@EnableAutoConfiguration 作用：

- 利用AutoConfigurationImportSelector给容器中导入一些组件？
- 可以查看selectImports()方法的内容
- 获取候选的配置

```java
List<String> configurations = this.getCandidateConfigurations(annotationMetadata, attributes);
```


- 扫描类路径下的
```java
  SpringFactoriesLoader.loadFactoryNames(）
  扫描所有jar包类路径下的 MATA-INF/spring.factories
  把扫描到的这些文件的内容包装成properties对象
  从properties中获取到EnableAutoConfiguration.class类（类名）对应的值，然后把他们添加到容器中
```
将类路径下 MATE-INF/spring.factories里面配置的所有的EnableAutoConfiguration的值加入到了容器中；

3）、每一个自动配置类进行自动配置功能；

4）、以**HttpEncodingAutoConfiguration** 为例

```java
@Configuration //表示是一个配置类，以前编写的配置文件一样，也可以给容器中添加组件
@EnableConfigurationProperties({HttpEncodingProperties.class})//启动指定类的Configurationproperties功能；将配置文件中的值和HttpEncodingProperties绑定起来了；并把HttpEncodingProperties加入ioc容器中
@ConditionalOnWebApplication//根据不同的条件，进行判断，如果满足条件，整个配置类里面的配置就会失效，判断是否为web应用；
(
    type = Type.SERVLET
)
@ConditionalOnClass({CharacterEncodingFilter.class})//判断当前项目有没有这个类，解决乱码的过滤器
@ConditionalOnProperty(
    prefix = "spring.http.encoding",
    value = {"enabled"},
    matchIfMissing = true
)//判断配置文件是否存在某个配置 spring.http.encoding，matchIfMissing = true如果不存在也是成立，即使不配置也生效
public class HttpEncodingAutoConfiguration {
   //给容器添加组件，这个组件的值需要从properties属性中获取
    private final HttpEncodingProperties properties;
	//只有一个有参数构造器情况下，参数的值就会从容器中拿
    public HttpEncodingAutoConfiguration(HttpEncodingProperties properties) {
        this.properties = properties;
    }

    @Bean
    @ConditionalOnMissingBean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new OrderedCharacterEncodingFilter();
        filter.setEncoding(this.properties.getCharset().name());
        filter.setForceRequestEncoding(this.properties.shouldForce(org.springframework.boot.autoconfigure.http.HttpEncodingProperties.Type.REQUEST));
        filter.setForceResponseEncoding(this.properties.shouldForce(org.springframework.boot.autoconfigure.http.HttpEncodingProperties.Type.RESPONSE));
        return filter;
    }

```

5）、所有在配置文件中能配置的属性都是在xxxProperties类中封装着；配置文件能配置什么就可以参照某个功能对应的这个属性类

```java
@ConfigurationProperties(prefix = "spring.http.encoding")//从配置文件中的值进行绑定和bean属性进行绑定
public class HttpEncodingProperties {
```

根据当前不同条件判断，决定这个配置类是否生效？

一旦这个配置类生效；这个配置类会给容器添加各种组件；这些组件的属性是从对应的properties中获取的，这些类里面的每个属性又是和配置文件绑定的



### 2、所有的自动配置组件

每一个xxxAutoConfiguration这样的类都是容器中的一个组件，都加入到容器中；

作用：用他们做自动配置

```properties
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
org.springframework.boot.autoconfigure.cassandra.CassandraAutoConfiguration,\
org.springframework.boot.autoconfigure.cloud.CloudAutoConfiguration,\
org.springframework.boot.autoconfigure.context.ConfigurationPropertiesAutoConfiguration,\
org.springframework.boot.autoconfigure.context.MessageSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.context.PropertyPlaceholderAutoConfiguration,\
org.springframework.boot.autoconfigure.couchbase.CouchbaseAutoConfiguration,\
org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.solr.SolrRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.rest.RepositoryRestMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.data.web.SpringDataWebAutoConfiguration,\
org.springframework.boot.autoconfigure.elasticsearch.jest.JestAutoConfiguration,\
org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration,\
org.springframework.boot.autoconfigure.freemarker.FreeMarkerAutoConfiguration,\
org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration,\
org.springframework.boot.autoconfigure.h2.H2ConsoleAutoConfiguration,\
org.springframework.boot.autoconfigure.hateoas.HypermediaAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastJpaDependencyAutoConfiguration,\
org.springframework.boot.autoconfigure.http.HttpMessageConvertersAutoConfiguration,\
org.springframework.boot.autoconfigure.http.codec.CodecsAutoConfiguration,\
org.springframework.boot.autoconfigure.influx.InfluxDbAutoConfiguration,\
org.springframework.boot.autoconfigure.info.ProjectInfoAutoConfiguration,\
org.springframework.boot.autoconfigure.integration.IntegrationAutoConfiguration,\
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JdbcTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JndiDataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.XADataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JmsAutoConfiguration,\
org.springframework.boot.autoconfigure.jmx.JmxAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JndiConnectionFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.activemq.ActiveMQAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.artemis.ArtemisAutoConfiguration,\
org.springframework.boot.autoconfigure.groovy.template.GroovyTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jersey.JerseyAutoConfiguration,\
org.springframework.boot.autoconfigure.jooq.JooqAutoConfiguration,\
org.springframework.boot.autoconfigure.jsonb.JsonbAutoConfiguration,\
org.springframework.boot.autoconfigure.kafka.KafkaAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.embedded.EmbeddedLdapAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.LdapAutoConfiguration,\
org.springframework.boot.autoconfigure.liquibase.LiquibaseAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderValidatorAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.MongoReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.mustache.MustacheAutoConfiguration,\
org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
org.springframework.boot.autoconfigure.quartz.QuartzAutoConfiguration,\
org.springframework.boot.autoconfigure.reactor.core.ReactorCoreAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration,\
org.springframework.boot.autoconfigure.security.reactive.ReactiveSecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.reactive.ReactiveUserDetailsServiceAutoConfiguration,\
org.springframework.boot.autoconfigure.sendgrid.SendGridAutoConfiguration,\
org.springframework.boot.autoconfigure.session.SessionAutoConfiguration,\
org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientAutoConfiguration,\
org.springframework.boot.autoconfigure.solr.SolrAutoConfiguration,\
org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.TransactionAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.jta.JtaAutoConfiguration,\
org.springframework.boot.autoconfigure.validation.ValidationAutoConfiguration,\
org.springframework.boot.autoconfigure.web.client.RestTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.web.embedded.EmbeddedWebServerFactoryCustomizerAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.HttpHandlerAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.ReactiveWebServerFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.WebFluxAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.error.ErrorWebFluxAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.function.client.WebClientAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.DispatcherServletAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.ServletWebServerFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.HttpEncodingAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.MultipartAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.reactive.WebSocketReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketServletAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketMessagingAutoConfiguration,\
org.springframework.boot.autoconfigure.webservices.WebServicesAutoConfiguration

```

### 3、精髓：

1）、SpringBoot启动会加载大量的自动配置类（xxxAutoConfiguration），比如RedisAutoConfiguration,这些配置类会加载很多使用Redis框架需要的组件（类），

2）、这些配置类添加组件的时候，会从里头对应的xxxProperties类（比如：RedisProperties）中获取属性，来初始化这些组件，我们可以在xxxProperties类查看默认值，并可以通过主配置文件来修改这些默认的属性



xxxAutoConfiguration:自动配置类,给容器中添加组件；

xxxProperties:封装组件的默认属性,；



### 4、细节

#### 1、@Conditional派生注解（条件注解） 

> 利用Spring注解版原生的@Conditional作用

作用：必须是@Conditional指定的条件成立，才给容器中添加组件，配置配里面的所有内容才生效；

| @Conditional派生注解                | 作用（判断是否满足当前指定条件）               |
| ------------------------------- | ------------------------------ |
| @ConditionalOnJava              | 系统的java版本是否符合要求                |
| @ConditionalOnBean              | 容器中存在指定Bean                    |
| @ConditionalOnMissBean          | 容器中不存在指定Bean                   |
| @ConditionalOnExpression        | 满足spEL表达式                      |
| @ConditionalOnClass             | 系统中有指定的类                       |
| @ConditionalOnMissClass         | 系统中没有指定的类                      |
| @ConditionalOnSingleCandidate   | 容器中只有一个指定的Bean,或者这个Bean是首选Bean |
| @ConditionalOnProperty          | 系统中指定的属性是否有指定的值                |
| @ConditionalOnResource          | 类路径下是否存在指定的资源文件                |
| @ConditionalOnWebApplication    | 当前是web环境                       |
| @ConditionalOnNotWebApplication | 当前不是web环境                      |
| @ConditionalOnJndi              | JNDI存在指定项                      |

#### 2、自动配置报告

自动配置类必须在一定条件下生效

我们可以通过启用debug=true属性，配置文件，打印自动配合报告，这样就可以知道自动配置类生效

```properties
debug=true
```

自动配置报告

```java
============================

CONDITIONS EVALUATION REPORT
============================


Positive matches:（启动的，匹配成功的）
-----------------

   CodecsAutoConfiguration matched:
      - @ConditionalOnClass found required class 'org.springframework.http.codec.CodecConfigurer'; @ConditionalOnMissingClass did not find unwanted class (OnClassCondition)
        ......
        
 Negative matches:（没有启动的，没有匹配成功的）
-----------------

   ActiveMQAutoConfiguration:
      Did not match:
         - @ConditionalOnClass did not find required classes 'javax.jms.ConnectionFactory', 'org.apache.activemq.ActiveMQConnectionFactory' (OnClassCondition)
.....
```

# 三、日志

> Spring Boot2对日志有更改

### 1、日志框架

小张：开发一个大型系统；

1、System.out.println("");将关键数据打印在控制台；去掉？卸载文件中

2、框架记录系统的一些运行信息；日志框架zhanglog.jar

3、高大上功能，异步模式？自动归档？xxx?zhanglog-good.jar?

4、将以前的框架卸下来？换上新的框架，重新修改之前的相关API;zhanglog-perfect.jar;

5、JDBC--数据库驱动；

​	写了一个统一的接口层；日志门面（日志的一个抽象层）；logging-abstract.jar;

​	给项目中导入具体的日志实现就行；我们之前的日志框架都是实现的抽象层；

市面上的日志框架

| 日志抽象层（日志门面）                                       | 日志实现                                                    |
| ------------------------------------------------------------ | ----------------------------------------------------------- |
| ~~JCL(Jakarta Commons Logging)~~ <br />SLF4j(Simple Logging Facade for Java)<br /> ~~JL(jboss-logging)~~ | Log4j <br />~~JUL(java.util.logging)~~ <br />Log4j2 Logback |

我们的选择是：

**SLF4J  -- Logback**

Spring Boot:底层是Spring框架，**Spring默认框架是JCL**；

​	**SpringBoot选用SLF4J和logback**

### 2、SLF4J使用

#### 1、如何在系统中使用SLF4j

以后开发的时候，日志记录方法的调用，不应该来直接调用日志的实现类，而是调用日志抽象层里面的方法；

应该给系统里面导入slf4j的jar包和logback的实现jar

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(HelloWorld.class);
    logger.info("Hello World");
  }
}
```

![8.slf4j](.\images\8.slf4j.jpg)

每个日志框架的实现框架都有自己的配置文件。使用slf4j以后，配置文件还是使用日志**实现框架本身的配置文件**；

#### 2、统一问题

"各框架自带的日志框架不一样"：

Spring（commons-logging）、Hibernate（jboss-logging）、Mybatis......



统一日志框架，统一使用(slf4j+logback)：进行输出；

![1551703080968](.\images\统一日志框架.png)

核心：

1、将系统中其他日志框架排除出去；

2、用中间包来替换原有的日志框架;(狸猫换太子)

3、导入slf4j的其他实现

### 3、SpingBoot日志框架解析

打开IDEA ，打开pom文件的依赖图形化显示

![9.IDEAdependencies](.\images\9.IDEAdependencies.jpg)



SpringBoot的日志功能场景启动器

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
    <version>2.0.1.RELEASE</version>
    <scope>compile</scope>
</dependency>
```



![10.slf4jandlogback](.\images\10.slf4jandlogback.jpg)

总结：

1. SpringBoot底层也是使用SLF4J+log4jback

2. SpringBoot也把其他日志替换成了slf4j

3. 起着commons.loggings的名字其实new的SLF4J替换中间包

   SpringBoot2中改成了bridge

4. 如果要引入其他框架？一定要把这个框架的日志依赖移除掉.

### 4、日志的使用

#### 1、默认配置

**日志级别： trace < debug < info < warn < error**

一、调整日志级别（可以具体到哪个包，springboot默认root包，info级别）

```properties
logging.level.org.hut=trace
```

二、调整日志控制台输出格式

```properties
#控制台输出的日志格式 
#%d：日期
#%thread：线程号 
#%-5level：靠左 级别 
#%logger{50}：全类名50字符限制,否则按照句号分割
#%msg：消息+换行
#%n：换行
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n
```

 三、调整日志文件的格式和位置

```properties
#logging.file=springboot.log #不常用，在项目根目录生成springboot.log，F5可以看到
logging.path=/demo/log  #在项目的所在磁盘的根路径（D盘）下创建spring/log文件夹，默认文件名为spring.log

#指定文件中日志输出的格式
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n
```



```java
//记录器（了解）
Logger logger = LoggerFactory.getLogger(getClass());
@Test
public void contextLoads() {

    //几个方法（了解）
    logger.trace("这是trace日志");
    logger.debug("这是debug信息");
    //SpringBoot默认给的是info级别
    logger.info("这是info日志");
    logger.warn("这是warn信息");
    logger.error("这是Error信息");
}
```

#### 2、指定配置

**作用：给类路径下放上每个日志框架自己的配置框架；SpringBoot就不会使用自己默认的配置，暂作为了解吧，spring自带的日志配置挺好用了，没必要在自己配置**

| logging System         | Customization                                                |
| ---------------------- | ------------------------------------------------------------ |
| Logback                | **logback-spring.xml** ,logback-spring.groovy,**logback.xml** or logback.groovy |
| Log4J2                 | log4j2-spring.xml or log4j2.xml                              |
| JDK(Java Util Logging) | logging.properties                                           |

**logback.xml和logback-spring.xml的区别：**

logback.xml直接被日志框架识别 ，

(推荐)**logback-spring.xml**日志框架就不直接加载日志配置项，由SpringBoot加载

```xml
<springProfile name="dev">
	<!-- 可以指定某段配置只在某个环境下生效 -->
</springProfile>
<springProfile name!="dev">
	<!-- 可以指定某段配置只在某个环境下生效 -->
</springProfile>
```

如何调试开发环境,输入命令行参数

--spring.profiles.active=dev

如果不带后面的xx-spring.xml就会报错

### 3、切换日志框架

可以根据slf4j的日志适配图，进行相关切换；

#### 1、log4j

slf4j+log4j的方式；

![11.log4j](.\images\11.log4j.jpg)

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <artifactId>logback-classic</artifactId>
            <groupId>ch.qos.logback</groupId>
        </exclusion>
    </exclusions>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
</dependency>
```

不推荐使用仅作为演示

#### 2、log4j2

切换为log4j2

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <artifactId>spring-boot-starter-logging</artifactId>
            <groupId>org.springframework.boot</groupId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j2</artifactId>
</dependency>
```

### 

