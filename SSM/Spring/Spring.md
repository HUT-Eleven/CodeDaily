# Spring

> 诸如Spring系列，SpringBoot系列这类框架知识的学习，不像一些计算机基础知识的学习，框架是封装，是为了简化开发的难度，提高项目的质量，降低运维的难度，这是一个框架诞生以及能否生存的关键。Spring是为了解决整个JavaEE的开发中会涉及到的东西，所以知识点散乱，并且涉及到的东西也多，所以学习中应注意分模块。

## 1. Introduction

### 1.1 Why use Spring？

这个问题本质上，就是**Spring解决了什么问题？提供了什么帮助？**
首先要明白一点，在Spring出来之前，就已经能开发应用了，所以Spring并不是解决一个0-1的技术，而是**去代替上市面上的一些技术**，进而促进整体技术圈的发展,**简化项目开发与利于维护**，所以不必太神话Spring。
web发展史作为参考：https://blog.csdn.net/bntX2jSQfEHy7/article/details/78898595

- ==**减少侵入式开发**==
  Spring出现以前其他框架技术通常是要**实现特定的接口，继承特定的类才能增强功能**，而Spring一定程度上减小了这种入侵式的开发

- 通过**依赖注入**和**面向接口**实现==**松耦合**==
  所谓“松耦合”，并不是指业务发生变化了，不需要改了代码了。而是指更加的灵活，这归功于“依赖注入”+“接口”，eg:

  ```java
  // Controller调用Service层
  public Class TestController{
      Service s = new ServiceImpl();
  }
  // 现在有个情况：原先的ServiceImpl弃用，使用ServiceImplPlus类，
  1. 因为之前不是注入的方式，所以负责Controller的人也很无奈的跟着改代码：
  	Service s = new ServicePlusImpl();
  2. 但是如果是使用Spring注入的方式：
      @Autowire
      Service s;
  这样的话，Controller层根本不关心Service怎么变化了，因为IOC容器会选好注入给它。
  ```

- **基于切面**和惯例进行声明式编程，==**减少重复代码**==。

### 1.2 Spring6大模块

Spring可以分为6大模块：

<img src="https://img04.sogoucdn.com/app/a/100520146/8f6d326d35295c0a812f6bf8257a669e" alt="image-20200504162333730.png" style="zoom: 50%;" />

- **Spring Core**  spring的核心功能： IOC容器
- **Spring Web**  Spring对web模块的支持(springmvc)
- **Spring DAO**  Spring对jdbc操作的支持
- **Spring ORM**  spring对orm框架(mybatis、hibernate)的支持
- **Spring AOP**  切面编程
- **SpringEE**   spring对javaEE其他模块的支持

## 2. IOC module

### 2.1 引出IOC module

没有Spring之前开发Web项目的步骤大致如下：

- **1. pojo：class User{ }**
- **2. Dao：UserDao{  .. 访问db}**
- **3. Service：class  UserService{  UserDao userDao = new UserDaoImpl();}**
- **4. Controller： UserController{UserService userService = new UserServiceImpl();}** 

**用户访问：Tomcat->servlet->service->dao->DB**

**几个存在的问题**：

- ①：对象数量和创建时间如何控制？(通常会想到单例模式中的懒汉和饿汉)
- ②：对象的依赖关系（通常会想到引入第三方，工厂模式）
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

![image-20200420010945186.png](/../Spring/assets/61bdbee6e74ee715dfd2f776a33ef609.png)

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
// 有参构造函数：
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

- singleton单例(默认)：**在Spring容器初始化之后，就会创建所有单例的对象**;`lazy-init="true"设置延迟初始化，第一次访问时初始化。（联想到懒汉式单例模式）`

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

![image-20200420163225981.png](/../Spring/assets/a4641fa953246f7c50f51173691fb95e.png)

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
> AOP:抽取重复的代码，通过代理的方式动态植入；

### 3.1 代理模式

![image-20200505141942575.png](/../Spring/assets/7c9fc38cf4d0d00d3c2be1042650af0d.png)

图解：

1. Client只调用接口（subject），并不在乎具体是实现类是谁；
2. Client实际调用的实现类是代理类（Proxy）；
3. 代理类（Proxy）对委托类（RealSubject）补充增强代码；

#### 3.1.1 静态代理

要求：Java中的静态代理要求代理类(ProxySubject)和委托类(RealSubject)都**实现同一个接口**(Subject)。

**接口subject**

```java
public interface HelloService {
	void method();
}
```

**委托类(RealSubject)**

```java
public class HelloServiceImpl implements HelloService {
	@Override
	public void method() {
		System.out.println("原本的业务逻辑");
	}
}
```

**代理类(ProxySubject)**

```java
public class StaticProxy implements HelloService{
	private HelloService helloService;
	public StaticProxy(HelloService helloService) {
		this.helloService=helloService;
	}
	@Override
	public void method() {
		System.out.println("新增业务逻辑--1");
		helloService.method();
		System.out.println("新增业务逻辑--2");
	}
    // 测试：
	public static void main(String[] args) {
		HelloService serviceImpl = new HelloServiceImpl();
        //获取代理对象
		HelloService serviceProxy = new StaticProxy(serviceImpl);
		serviceProxy.method();
	}
}
//输出：
    //新增业务逻辑--1
    //原本的业务逻辑
    //新增业务逻辑--2
```

#### 3.1.2 jdk动态代理

核心：java.lang.reflect.**Proxy**的newProxyInstance(loader, interfaces, handler)方法；
**与静态代理的区别**：ProxySubject不需要与RealSubject继承同一接口。

subject和RealSubject和上面一样

**代理类(ProxySubject)**

```java
public class DynamicProxyFactory {
	
	public static Object getProxyObject(Object obj) {
		
		// 方法执行器
		InvocationHandler handler = new InvocationHandler() {
			
			@Override
			public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
				System.out.println("新增业务逻辑--1");
				Object result = method.invoke(obj, args);	//执行原有方法
				System.out.println("新增业务逻辑--2");
				return result;
			}
		};
      
		Class<?>[] interfaces = obj.getClass().getInterfaces();	//对象的所有的接口,所以jdk动态代理的委托类必须有实现接口，其实底层生成的代理类也会实现这个接口
		ClassLoader loader = obj.getClass().getClassLoader();	//类加载器
		Object proxyInstance = Proxy.newProxyInstance(loader, interfaces, handler);
		return proxyInstance;
	}
	
	// 测试：
	public static void main(String[] args) {
		HelloService serviceImpl = new HelloServiceImpl();
        //获取代理对象
		HelloService proxyObject = (HelloService)DynamicProxyFactory.getProxyObject(serviceImpl);
		proxyObject.method();
	}
}
```

#### 3.1.3 cglib动态代理

核心：CGLib动态代理是**代理类继承目标类**，然后重写其中目标类的方法。所以**委托类不能是final，被代理的方法不能是static/final**.需要实现net.sf.cglib.proxy.**MethodInterceptor**接口

```java
//需要实现MethodInterceptor接口
public class CglibProxyFactory implements MethodInterceptor{

	@Override
	public Object intercept(Object object, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
		System.out.println("新增业务逻辑--1");
		Object result = methodProxy.invokeSuper(object, args);
		System.out.println("新增业务逻辑--2");
		return result;
	}
	// 测试:
	public static void main(String[] args) {
		// 工具类
		Enhancer enhancer = new Enhancer();
		// 设置父类
		enhancer.setSuperclass(HelloServiceImpl.class);
		// 设置回调函数
		enhancer.setCallback(new CglibProxyFactory());
		// 获取获取代理对象
		HelloServiceImpl serviceProxy = (HelloServiceImpl) enhancer.create();
		serviceProxy.method();
	}
}
```

#### 总结比较

1. 静态代理：代理类在编译期就生成，效率高。缺点是代理类和委托类需要实现同一接口，会生成大量的代理类，gc负担，维护困难。
2. jdk动态代理：委托类要有接口，代理类不需要我们手动去实现接口，其实底层生成的代理类也会实现这个接口；通过反射原理，消耗系统性能；是在**运行时期**生成代理类
3. cglib动态代理：不需要委托类有接口,因此弥补了jdk动态代理的不足....（有空再研究原理吧）

### 3.2 AOP术语

- 关注点/通知：重复代码就叫做关注点/通知；

- 切面：关注点形成的类，就叫切面**(**类**)**;

- 切入点表达式：匹配需要增强的方法；

- 切入点：植入的位置；

### 3.3 Spring AOP实现

Spring AOP**采用了jdk动态代理+cglib代理两种**，有接口实现时使用jdk动态代理，否则使用cglib。
Spring简化了我们创建代理对象的方式。

#### 3.3.1 注解方式

导包+名称空间，略；

1. 在配置文件中开启AOP注解方式

```xml
<context:component-scan base-package="aa"/>
<!-- 开启aop注解方式 -->
<aop:aspectj-autoproxy />
```

2. 切面类

```java
@Aspect	// 标注这个是切面类
@Component	// 必须注入到IOC容器中
public class MyAdvice {
	@Pointcut("execution(* org.hut.service.UserServiceImpl.*())")// 提取切点表达式
	public void pointCut() {}
    
	@Before("execution(* org.hut.service.UserServiceImpl.*())")
	public void before() {
		System.out.println("-----前置通知: 目标方法之前执行-----");
	}
	
	@After("MyAdvice.pointCut()")
	public void after() {
		System.out.println("-----后置通知：目标方法之后执行（始终执行）-----");
	}
	
	@AfterReturning("MyAdvice.pointCut()")
	public void afterReturning() {
		System.out.println("-----返回后通知： 执行方法结束前执行(异常不执行)-----");
	}
	
	@AfterThrowing("MyAdvice.pointCut()")
	public void afterThrowing() {
		System.out.println("-----异常通知:  出现异常时候执行-----");
	}
	
	@Around("MyAdvice.pointCut()")
	public void around() {
		System.out.println("-----环绕通知： 环绕目标方法执行-----");
	}
}
```

3. 1 委托类有接口实现时

```java
@Service
public class UserServiceImpl implements UserService {
	@Override
	public void show() {
		System.out.println("UserService的show原有业务逻辑");
	}
}

测试：
public class APP {
	@Test
	public void testAOP() throws Exception {
		ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("spring/applicationContext-aop.xml");
		// ！！！细节1：必须用UserService去获取bean，不能使用UserServiceImpl,虽然UserServiceImpl上有@Service，但实际注入到IOC容器的对象是代理对象。
		UserService userService = ioc.getBean(UserService.class);
		System.out.println("所实现的接口是："+userService.getClass());;
		userService.show();
	}
}
// 1. 委托类有接口实现时，代理对象是：class com.sun.proxy.$Proxy15--->使用的是jdk的动态代理
```

3. 2 委托类无接口实现时

```java
@Service
public class UserServiceImpl{
	public void show() {
		System.out.println("UserService的show原有业务逻辑");
	}
}

测试：
public class APP {
	@Test
	public void testAOP() throws Exception {
		ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("spring/applicationContext-aop.xml");
		// ！！！因为cglib是继承的方式实现代理，所以这里得到的代理对象可以用父类接收
		UserServiceImpl userServiceImpl = ioc.getBean(UserServiceImpl.class);
		System.out.println("所实现的接口是："+userServiceImpl.getClass());;
		userServiceImpl.show();
	}
}
// 1. 委托类无接口实现时，代理对象是：class org.hut.service.UserServiceImpl$$EnhancerBySpringCGLIB$$57feaeae--->使用cglib动态代理
```

##### 1. 切入点表达式

 ```c++
execution(modifiers-pattern? return-type-pattern declaring-type-pattern? name-pattern(param-pattern) throws-pattern?)
 ```
**符号讲解：**

- ? : 可以不指定

- “*”：通配

- ..:多层路径/任意参数列表

**参数讲解：**

  - modifiers-pattern?【修饰的类型，可以不写】
  - return-type-pattern【方法返回值类型，必写】
  - declaring-type-pattern?【方法声明的类型，可以不写】
  - name-pattern(param-pattern)【要匹配的名称，括号里面是方法的参数】
  - throws-pattern?【方法抛出的异常类型，可以不写】

##### 2. 通知的执行顺序

```java
try{
    @Before
    method.invoke(obj,args);
    @AfterReturning
}catch{
    @AfterThrowing
}finally{
    @After
}
// 正常执行：before-after-afterReturning
// 异常执行：before-after-AfterThrowing
```

**@Around：环绕通知**，可以其中加入其它通知，功能是最为强大。

![image-20200505200034976.png](/../Spring/assets/b2b8542c46cdf08123c457ee703235fd.png)

```java
// 环绕通知：优先于普通通知。
try{
    [环绕前置]
    @Before
    method.invoke(obj,args);
    [环绕返回]
    @AfterReturning
}catch{
    [环绕异常]
    @AfterThrowing
}finally{
    [环绕后置]
    @After
}
// 环绕和普通有一处区别：环绕是[环绕返回]-->[环绕后置],
所以总体顺序：
    正常：环绕前置+@Before-->[环绕返回]-->[环绕后置]-->@After-->@AfterReturning
    异常：环绕前置+@Before-->[环绕后置]-->@After-->[环绕异常]-->@AfterThrowing
```

##### 3. JoinPoint对象

包含当前目标方法的详细信息

##### 4. 多切面运行顺序

**注解方式：@Order进行排序，顺序相同则以类名排序**

**xml方式：Order进行排序，顺序相同则以书写顺序排序**

多切面时通知的执行顺序：**先进后出**

![image-20200505215344013.png](/../Spring/assets/8c54853d9eaaee4c41dac81d57e63d3b.png)

### 3.3.2 XML方式

导包-->名称空间-->准备通知，略

xml配置切点和通知，并织入到目标对象中：

```xml
<context:component-scan base-package="org.hut"/>
<!-- <aop:aspectj-autoproxy /> -->
<!-- 通知&目标对象 使用注解方式注入到IOC容器中-->
<aop:config>
    <aop:pointcut expression="execution(* org.hut.service..*(..))" id="pointCut"/>
    <aop:aspect ref="myAdvice">
        <aop:before method="before" pointcut-ref="pointCut"/>
        <!-- 其他类型通知略 -->
    </aop:aspect>
    <!-- 可配置多个切面 -->
    <!-- <aop:aspect>...</aop:aspect> -->
</aop:config>
```

使用原则：重要的用xml配置，其余用注解。

## 4. Spring事务

> Spring提供的平台事务管理器**PlatformTransactionManager**。无论使用Spring的哪种事务管理策略(编程式或声明式)，事务管理器都是必须的。**AOP的关键就是“通知+切点表达式”**，但**事务管理器中已经把通知写好了**，并提供了可配置的信息，所以我们只需要配切点。
> 注：因为有了Spring进行事务控制，所以IOC容器中保存的是**代理对象**
- Jdbc技术、Mybatis：DataSourceTransactionManager

- Hibernate技术：HibernateTransactionManager

![wps1.jpg](/../Spring/assets/029f40de63a446b9c870e86d56ab22a3.jpg)

### 4.1 事务控制分类

- 编程式事务控制

> 手动控制事务，就叫做编程式事务控制。

特点：**细粒度的事务控制： 可以对指定的方法、指定的方法的某几行添加事务控制**

- 声明式事务控制

> Spring AOP提供对事务的控制管理就叫做声明式事务控制
>

### 4.2 声明式事务控制

#### 4.2.1 注解方式

```xml
<!-- 配置事务管理器,管理事务就是在管理数据源，所以需要数据源 -->
<bean id="tm"class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
	<property name="dataSource" ref="dataSource"/>	  
</bean>

<!-- 启用注解式事务管理器驱动 -->
<tx:annotation-driven transaction-manager="tm"/>

在需要进行事务控制的方法上加注解@Transactional
```

#### 4.2.2 XML形式

- 配置事务通知的属性
  ![image-20200506003753601.png](/../Spring/assets/c164f222a242ec2c3e5ae21d39491146.png)
- 组合事务通知和切点表达式
  ![image-20200506003858978.png](assets/4158caa685814b92deec1535b5e25f53.png)

### 4.3 事务属性

- 传播行为propagation
  是指多个事务嵌套执行时（Service方法调用Service方法），如何控制。
  多数都是用：`Propagation.REQUIRED`

  ![wps2-1588698159017.jpg](assets/cd75fe3db661f3c1e44a1f91030838ca.jpg)

- 异常回滚
  spring默认是只回滚RuntimeException发生的异常的事务，当发生Exception时不回滚的。
  解决办法：

  1. 将Exception转为RuntimeException；
  2. rollbackFor = Exception.class

- 只读
  默认false，readOnly=true，表示只读。

- 超时控制
  timeout



















