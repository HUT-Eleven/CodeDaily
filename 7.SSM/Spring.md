---
typora-copy-images-to: ./images
typora-root-url: ./images
---

# Spring

## 1. Introduction

### 1.1 Why use Spring？

这个问题本质上，就是**Spring解决了什么问题？提供了什么帮助？**
首先要明白一点，在Spring出来之前，就已经能开发应用了，所以Spring并不是解决一个0-1的技术，而是**去代替上市面上的一些技术**，进而促进整体技术圈的发展。
web发展史作为参考：https://blog.csdn.net/bntX2jSQfEHy7/article/details/78898595

- ==**减少侵入式开发**==
  其他框架技术通常是要**实现特定的接口，继承特定的类才能增强功能**，而Spring一定程度上减小了这种入侵式的开发

- 通过**依赖注入**和**面向接口**实现==**松耦合**==
  所谓“松耦合”，并不是指业务发生变化了，不需要改了代码了。而是指更加的灵活，这归功于“依赖注入”+“接口”，eg:

  ```java
  // Controller调用Service层
  public Class TestController{
      Service s = new ServiceImpl();
  }
  // 现在有个情况：原先的ServiceImpl弃用，使用ServicePlusImpl类，
  1. 因为之前不是注入的方式，所以负责Controller的人也很无奈的跟着改代码：
  	Service s = new ServicePlusImpl();
  2. 但是如果是使用Spring注入的方式：
      @Autowire
      Service s;
  这样的话，Controller层根本不关心Service怎么变化了，因为IOC容器会选好注入给它。
  ```

- **基于切面**和惯例进行声明式编程，==**减少重复代码**==

### 1.2 Spring6大模块

Spring可以分为6大模块：

<img src="/image-20200504162333730.png" alt="image-20200504162333730" style="zoom: 33%;" />

- **Spring Core**  spring的核心功能： IOC容器
- **Spring Web**  Spring对web模块的支持(springmvc)
- **Spring DAO**  Spring对jdbc操作的支持
- **Spring ORM**  spring对orm框架(mybatis、hibernate)的支持
- **Spring AOP**  切面编程
- **SpringEE**   spring对javaEE其他模块的支持

## 2. IOC module

### 2.1 引出IOC module

没有Spring之前开发Web项目的步骤大致如下：

- **1. pojo--->class User{ }**
- **2. Dao-->  UserDao{  .. 访问db}**
- **3. Service--->class  UserService{  UserDao userDao = new UserDaoImpl();}**
- **4. Controller--->  UserController{UserService userService = new UserServiceImpl();}** 

**用户访问：Tomcat->servlet->service->dao->DB**

**几个存在的问题**：

- ①：对象数量和创建时间如何控制？
- ②：对象的依赖关系
  - Controller依赖 service
  - service依赖 dao 

**Spring框架中的IOC一定程度上可以解决上面的问题**

### 2.2 IOC introduction

```wiki
在面向对象设计的软件系统中，绝对是通过N个对象构成的，这些对象之间相互合作，最终实现系统地业务逻辑。这些对象之间的耦合关系就像手表汽车中的齿轮，相互的啮合。对象之间的耦合关系是无法避免的，也是必要的，这是协同工作的基础。但如果耦合度太高的话，则会导致“牵一发而动全身”的情景。而IOC就是用来降低对象之间的耦合度，IOC全称“Iversion of control"，也翻译为”控制反转“，之所以称为控制反转，也正是因为创建对象的主动权发生了变化，之前由本身去创建，现在由IOC容器来创建。
“那么到底是“哪些方面的控制被反转了呢？”答案是：”获得依赖对象的过程被反转了“.
DI技术是IOC思想的落地实现技术，也就是依赖注入Dependency Injection。
```

https://blog.csdn.net/ivan820819/article/details/79744797
https://www.zhihu.com/question/23277575

![image-20200420010945186](/image-20200420010945186.png)

### 2.3 入门Demo

1. 配置Bean

```xml
<bean id="student" class="org.hut.Student"></bean>
```

2. 获取Bean

```java
ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
Student s = ioc.getBean("student",Student.class);
```

IOC在**使用层面**上就这两个步骤，但方式多样。

**要点1：配置Bean及依赖关系注入**
**要点2：得到IOC容器对象,取出Bean**

### 2.4 配置Bean及依赖关系注入

大致有四种方式：

- **xml方式**
- **注解方式**
- javaconfig
- groovy监本DSL

#### 2.4.1 XML方式

##### 配置bean

1. 空参构造方式

调用了无参构造函数

```xml
<bean id="customer1" class="org.hut.Customer">
```
2. 有参构造方式

```java
// 构造函数：
public Customer(String name, int age) {
    super();
    this.name = name;
    this.age = age;
}
// 配置：
<bean id="customer2" class="org.hut.Customer">
    <constructor-arg index="0" name="name" type="java.lang.String" value="小明"></constructor-arg>
    <constructor-arg index="1" name="age" value="2"></constructor-arg>
</bean>

注意：此处age为int类型，如果type="java.lang.Integer",会报错。所以基础数据类型就不需要指定type了
```

3. 静态工厂

```java
// 工厂
public class BeanFactory {
    // 静态方法
	public static Customer getCustomer() {
		return new Customer();
	}
    // ....
}
// 配置：
<bean id="customer3" class="org.hut.BeanFactory" factory-method="getCustomer"></bean>
```

4. 非静态工厂

```java
// 工厂
public class BeanFactory {
    // 非静态方法
    public Customer getCustomer2() {
        return new Customer();
    }
}
// 配置：
	// 先配置工厂
<bean id="beanFactory" class="org.hut.BeanFactory"></bean>
    // 指定工厂对象和方法
<bean id="customer4" class="org.hut.Customer" factory-bean="beanFactory" factory-method="getCustomer2"></bean>
```

**==注意点==**：

1. **id和name**：name相同的bean，编译不报错。无论是name还是id都不要重复。所以尽量使用id属性。
   特殊：name可以带特殊字符

##### 依赖关系注入

- 通过bean的setXxx()方法赋值--`<property>`

- 有参构造函数

- p名称空间注入（原理：setXxx()方法注入）
  名称空间：在xml中名称空间用来防止标签重复，独立区分出来。如：\<c:foreach\>  和 \<jsp:foreach\>  

  ```xml
  <bean id="student" class="org.hut.Student" p:stuName="Eleven" p:age="18" />
  ```

- spEL注入
  使用**#{…}**作为定界符

  ```xml
  <bean id="student" class="org.hut.Student"/>
  	<property name="stuName" value=#{customer.name}/>
  </bean>
  ```

- 复杂类型注入

  - Collection与数组

    ```xml
    <property name= "categoryList">
        <list>
            <value> 历史</value >
            <value> 军事</value >
            <ref bean= "book02"/>
        </list>
    </property>
    ```

  - Map

    ```xml
    <property name="bookMap">
        <map>
            <entry>
                <key>
                    <value>bookKey01</value>
                </key>
                <ref bean="book01"/>
            </entry>
            <entry>
                <key>
                    <value>bookKey02</value>
                </key>
                <ref bean="book02"/>
            </entry>
        </map>
    </property>
    // 可简化
    ```

  - properties

    ```xml
    <property name="properties">
        <props>
            <prop key="userName">root</prop>
            <prop key="password">root</prop>
        </props>
    </property>
    ```

- 内部bean
- util名称空间：复用集合bean，相当于new LinkedHashMap<>();

##### Bean属性

1. **scope--作用范围控制**

- singleton单例(默认)：在Spring容器初始化之后，就会创建所有单例的对象;`lazy-init="true"设置延迟初始化，第一次访问时初始化`

- prototype多例：每次在获取时都会创建
  - request:web环境下.对象与request生命周期一致；
  - session:web环境下,对象与session生命周期一致.

2. **生命周期控制**

   - lazy-init：默认false，不延迟加载，所以该属性只针对单例有效

   - init-method：构造方法执行之后执行init-method；

   - destory-method：对象销毁之前调用;

   - **bean的后置处理器**:
     接口：org.springframework.beans.factory.config.**BeanPostProcessor**（post process：后期处理）
     实现接口，编写自定义的后置处理器，并注入到IOC中。
     两个方法：

     - postProcessBeforeInitialization ：在init-method之前执行
     - postProcessAfterInitialization：在init-method之后执行

     总体的生命周期：构造方法--postProcessBeforeInitialization -- init-method--postProcessAfterInitialization-- detory-method

3. abstract：配置抽象类的bean

4. 引入外部配置文件

   ```xml
   <!-- classpath:xxx 表示属性文件位于类路径下 -->
   <context:property-placeholder location="classpath:jdbc.properties"/>
   ```

5. xml形式的自动装配`autowire`
   

#### 2.4.2 注解方式

首先需要开启注解扫描器：

```xml
<context:component-scan base-package="org.hut" />
//1. 需要扫描多个包时可以使用逗号分隔
//2. 如果仅希望扫描特定的类而非基包下的所有类，可使用resource-pattern属性过滤特定的类:
<context:component-scan base-package="org.hut" resource-pattern="*xxx*.class/>
```

##### 配置bean

- @Component   指定把一个对象加入IOC容器--->@Name也可以实现相同的效果【一般少用】
- @Repository    在持久层使用
- @Service
- @Controller
- @Scope
- @PostConstruct  == init-method
- @PreDestory  == destory-method

##### 依赖关系注入

- 值类型注入 	--	@Value 

  ```java
  @Value("tom")	//原理：通过反射的Field赋值,破坏了封装性
  private String name;
  
  @Value("tom")	//原理：通过set方法赋值,推荐使用.
  public void setName(String name){...}
  ```

- 引用类型注入

  - @Autowire
    **根据类型自动装配**，当某个类型在IOC容器中存在多个时，可以@Qualifier("beanId")来指定。reqired属性：找不到对应bean时不报错。

  - @Resource
    **@Autowire和@Resource的区别？**

    ...待补充....

  - @Inject
    和@Autowired一样也是按类型注入,但没有reqired属性.

### 2.5 获取IOC容器对象

#### 2.5.1 继承体系

![image-20200420163225981](/image-20200420163225981.png)

Spring提供了IOC容器的两种实现方式:

##### 1. BeanFactory

​	spring原始接口.针对原始接口的实现类功能较为单一
​	特点：每次在获得对象时才会创建对象

##### 2. ApplicationContext

​	特点：每次容器启动时就会创建容器中配置的所有对象.并提供一些其他功能
​	实现类：**ClassPathXmlApplicationContext(classpath路径下查找配置文件)、FileSystemXmlApplicationContext(系统路径下查找配置文件)**

## 3. AOP module

> AOP:Aspect Oriented Programming
> OOP:Object Oriented Programming