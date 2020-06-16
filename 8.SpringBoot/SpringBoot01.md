# 一、Spring Boot入门

## 1、简介

> 整合了多个Spring技术栈；
>
> 着眼于整个J2EE开发，涉及企业级应用中的方方面面，提供一站式解决方案；

## 2、微服务

> 微服务：一个应用应该是一组小型服务，每个服务都运行在各自的进程中，应用之间通过HTTP/RPC互相访问；
>

## 3、环境准备

- 更改MAVEN默认的jdk版本,修改settings.xml

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

## 4、Hello World

1. 创建一个Maven工程

2. 导入Spring Boot的相关依赖

   ```xml
   <parent>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-parent</artifactId>
       <!-- 2.1.3.RELEASE -->
       <version>1.5.9.RELEASE</version>
   </parent>
   
   <dependencies>
       <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-web</artifactId>
       </dependency>
   
       <!--单元测试启动器，可不用-->
       <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-test</artifactId>
           <scope>test</scope>
       </dependency>
   </dependencies>
   ```

3. 编写个主程序

   ```java
   @SpringBootApplication	// 标注这是主程序
   public class MainkApplication {
       public static void main(String[] args) {
           SpringApplication.run(MainkApplication.class, args);
       }
   }
   ```

4. 编写Controller
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


5. 启动主程序

   - 第一种：直接run main方法

   - 第二种：mvn spring-boot:run

   - 第三种：打成jar包。使用java -jar运行

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

     运行：clean package，打成jar包。到jar包的目录下，运行**java -jar**  xxx.jar。

## 5、HelloWorld探究

1. **版本控制中心**

   ```xml
   -- 自身导入的父工程
   <parent>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-parent</artifactId>
       <version>1.5.9.RELEASE</version>
   </parent>
   
   -- 父工程的父工程的父工程,定义了SpringBoot中使用到的依赖版本：
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-dependencies</artifactId>
   <version>1.5.9.RELEASE</version>
   <packaging>pom</packaging>
   ```

   <img src="https://i.loli.net/2020/06/06/xX8cCUO7WuiTQKo.png" alt="2fdc42fbc9a9323dbdccfc492b991bf0" style="zoom:67%;" />

   **场景启动器**

> spring boot将**功能场景**抽取出来，做成starter(启动器)。

​	如web开发所需要的依赖：**spring-boot-starter-web:**“web开发场景启动器”

3. **主程序入口**

> **以下为1.5.9.RELEASE版本的源码，2.0之后有所改变**

**@SpringBootApplication:** 说明这个类是SpringBoot的主配置类，SpringBoot运行这个类的main方法来启动应用

进入**@SpringBootApplication**注解：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration//表示这是一个SpringBoot的配置类 ,底层是调用@Configuration
@EnableAutoConfiguration//开启自动配置功能，Spring Boot自动配置；
@ComponentScan(excludeFilters = {@Filter( type = FilterType.CUSTOM, classes = 		  			{TypeExcludeFilter.class} ), @Filter( type = FilterType.CUSTOM, classes =  				{AutoConfigurationExcludeFilter.class})})
public @interface SpringBootApplication {}
```

- **@EnableAutoConfiguration**:

  - **@AutoConfigurationPackage**:自动配置包

  - **@Import({Registrar.class})**：底层注解，给容器导入组件；将主配置类（@SpringBootApplication标注的类）的**所在包及下面所有的子包**里面的所有组件扫描到Spring容器； 

  - **@Import({AutoConfigurationImportSelector.class})：**
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

## 6、Spring Initializer快递向导 

1.IDEA支持使用Spring Initializer

自己选择需要的组件:例如web

默认生成的SpringBoot项目 

- 主程序已经生成好了，我们只需要完成我们的逻辑


- resources文件夹目录结构

  - static:保存所有的静态文件；js css images

  - templates:保存所有的模板页面；（Spring Boot默认使用嵌入式的Tomcat,默认不支持JSP）；可

    以使用模板引擎（freemarker.thymeleaf）;

# 二、配置文件 

- Spring Boot使用全局配置文件，配置文件名是固定的：
  - **application.properties**
  - **application.yml** 

## 1、YAML语法 

- 基本语法
 ```yaml
##1. v与：之间一定有空格
k: v   
##2. 以缩进来控制层级关系；只要是左对齐的一列数据，都是同一层级的 
k:
	v1: vv1
    v2: vv2
##3. 属性和值也是大小写敏感
 ```

  - 值的写法

    > 注意点：
    >
    > - 双引号和单引号的区别：单引号中无法识别转义字符 eg:   'abc /n abc'=abc /n abc

    1. 字面量：无特殊，直接写`k: v`

    2. 对象 or Map

       ```yaml
       person:
       	name: zhangsan
       	age: 18
       ```

       行内写法：

       ```yaml
       person: {name: zhangsan,age: 18}
       ```

    3. 数组 or List

       ```yaml
       pets:
       	- cat
       	- dog
       	- pig
       ```

       行内写法：

       ```yaml
       pets: [cat,dog,pig]
       ```

## 2、配置文件值注入 

### 1、@ConfigurationProperties

> 作用：**只**读取**主配置文件**的属性，并通过前缀的方式来指定bean，再注入到javabean中。
>
> **注意：该注解只读取主配置文件，不能直接读取其他配置文件**

- 演示
  
  - 配置文件准备
  
    - application.yml  or application.properties
  
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
  
      ---
  
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
  
  - 使用@ConfigurationProperties配置bean属性
  
    ```java
    @Component//需注入到容器中，才可进行配置
    @ConfigurationProperties(prefix = "person") // 指定配置前缀
    public class Person {
        private String lastName;
        private Integer age;
        private Boolean boss;
        private Map<String,Object> maps;
        private List<Object> lists;
        private Dog dog;
        getter();
        setter();
    }
    ```
  
  - 辅助：导入配置文件处理器，编写时携带提示
  
    ```xml
    <dependency>
    	<groupId>org.springframework.boot</groupId>
    	<artifactId>spring-boot-configuration-processor</artifactId>
    	<optional>true</optional>
    </dependency> 
    ```


### 2、@Value

> **作用：Spring的原生注解，用法还是一样，只要是Spring容器读到的配置文件，都可以注入。**

- @Value演示
    ```java
    @Component
    public class Person {
        @Value("${person.last-name}")	//${key}从环境变量
        private String lastName;
        @Value("#{11*2}")				//#{spEL}
        private Integer age;
        @Value("true")					//字面量（8种基本数据类型、String、枚举等）
        private Boolean boss;
    }
    ```


- **@Configuration  VS  @Value**

  |                | @ConfigurationProperties |  @Value  |
  | :------------: | :----------------------: | :------: |
  |      功能      |   批量注入配置文件属性   | 单个指定 |
  | 松散绑定(语法) |           支持           |  不支持  |
  |      spEL      |          不支持          |   支持   |
  |   JSR303校验   |           支持           |  不支持  |
  |    复杂类型    |           支持           |  不支持  |

  > 松散语法：e.g. last-name = lastName / last-name / lastname（容易产生歧义，不推荐使用）
  >
  > spEL语法：eg.#{11*2} 
  >

  - JSR303校验：

    ```java
    @Component
    @ConfigurationProperties(prefix = "person")
    @Validated	// 启用校验规则
    public class Person {
        @Email	// 邮箱校验
     	   private String lastName;
    }
    ```

  - 使用建议：

    单个配置注入时推荐用@Value，整体配置类用@Configuration。但也视情况而定。

### 3、@PropertySource
> **作用：因为@ConfigurationProperties只加载全局配置文件，所以@PropertySource就是用来辅助加载其他properties文件，配合@Value注入**

- 演示
  - 新建一个person.properties文件

```java
@Component
@PropertySource(value = {"classpath:person.properties"})
public class Person {
    @value("${lastname}")
    private String lastName;
}
```

### 4、@ImportResource

> 作用：导入**Spring配置文件**，可能作用是为了配合那些SSM应用升级到SpringBoot

1. 新建bean.xml配置文件

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
        <bean id="HelloService" class="com.wdjr.springboot.service.HelloService"></bean>
    </beans>
    ```

2. 使用@ImportResource注解读取该文件

   ```java
   @SpringBootApplication
   @ImportResource(value = {"classpath:bean.xml"})	// 加载Spring的配置文件
   public class BootApplication {
       public static void main(String[] args) {
           SpringApplication.run(BootApplication.class, args);
       }
   }
   ```

3. 测试

   ```java
   @RunWith(value = SpringRunner.class)
   @SpringBootTest
   public class TestBox {
       @Autowired
       private ApplicationContext ioc;
       @Test
       public void test02(){
           boolean flag = ioc.containsBean("dog");	//查看容器中是否有此bean
           System.out.println(flag);	//true
       }
   }
   ```

### 5、**@Configuration+@Bean**

>
> 这种方式主要是用来注入第三方Bean的。
> SpringBoot推荐给容器添加组件的方式：**全注解方式，替代原先的xml配置**。如配置DataSource，xxxTemplate等等.

```java
@Configuration
public class MyAppConfig {
    @Bean	//将方法的返回值添加到容器中；容器这个组件id就是方法名
    public DataSource dataSource(){
        DataSource dataSource = new DataSource();
		// ... 略... 
        return dataSource;
    }
}
```

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

> 多环境支持
>
> - 默认使用application.properties
> - 在主配置文件通过spring.profiles.active=xxx动态切换

### 1、多Profile文件

我们在主配置文件编写的时候，文件名可以是 application-{profile}.properties/yml

- application.properties
- application-dev.properties
- application-prod.properties

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

2、命令行，命令行优先级大于配置文件：

- IDE中：

![5.comandLine](https://i.loli.net/2020/05/31/cB81kexuaqD4Yo9.jpg)



- jar启动中：

`java -jar spring-boot-02-config-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev`

- 添加虚拟机启动参数

`-Dspring.profiles.active=dev`

## 6、主配置文件位置

SpringBoot启动扫描以下位置的application.properties或者application.yml文件作为Spring boot的默认配置文件

- file：/config/   --项目根目录的config目录

- file：./              --项目根目录

- classpath：/config/

- classpath：/

  > maven项目，resource目录就是默认的classpath路径

  优先级**从高到低顺序**。配置重复处理原则：互补原则，也即高优先级中存在的配置，低优先级就不会去覆盖了。

  ![7.priority](.\images\7.priority.jpg)

- 在命令行中通过**spring.config.location**新增配置文件的位置.**优先级高于项目中的配置文件.**常用于项目打好包了，去修改其中的配置。

`java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar --spring.config.location=E:/work/application.properties`

## 7. 从外部引入主配置

> **SpringBoot也可以从以下位置加载配置；优先级从高到低；互补配置**

1. **命令行参数**

   java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar **--server.port=9005 --server.context-path=/abc**

2. 来自java:comp/env的JNDI属性

3. **java系统属性（System.getProperties()）**

4. **操作系统环境变量**

5. RandomValuePropertySource配置的random.*属性值


   **优先加载profile,    由jar包外到jar包内**

6. **jar包外部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

7. **jar包内部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

8. **jar包外部的application.properties或application.yml(带Spring.profile)配置文件**

9. **jar包内部的application.properties或application.yml(不带spring.profile)配置文件**


10. @Configuration注解类的@PropertySource
11. 通过SpringApplication.setDefaultProperties指定的默认属性

其他的就不列举了，[官方文档](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#boot-features-external-config)中还有其他方式。

## ==8、自动配置==

### 1、自动配置原理

> 可大致分为两步：
>
> 1. 加载配置的对象加载到容器中
> 2. 对容器中的对象进行配置

#### 1. 加载配置的对象加载到容器中

1. SpringBoot启动的时候加载主配置类，开启自动配置功能:**@EnableAutoConfiguration**
2. @EnableAutoConfiguration 作用：

- 利用AutoConfigurationImportSelector给容器中导入一些组件
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
**将类路径下 MATE-INF/spring.factories里面配置的所有的EnableAutoConfiguration的值加入到了容器中**；

#### 2. 对容器中的对象进行配置

3. 以**HttpEncodingAutoConfiguration** 为例,来看已被加载的对象是如何完成自动配置；

```java
@Configuration
@EnableConfigurationProperties(HttpEncodingProperties.class)// !!!重点!!!，开启配置功能，配置来源即HttpEncodingProperties.class
@ConditionalOnWebApplication	// 判断是否为web应用
@ConditionalOnClass(CharacterEncodingFilter.class)//判断当前项目有没有这个类，解决乱码的过滤器
@ConditionalOnProperty(prefix = "spring.http.encoding", value = "enabled", matchIfMissing = true)//判断配置文件是否存在某个配置 spring.http.encoding.enabled=true，
// matchIfMissing = true表示如果spring.http.encoding.enabled没有值，则默认是true
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

4. 所有在配置文件中能配置的属性都是在xxxProperties类中封装着；配置文件能配置什么就可以参照某个功能对应的这个属性类

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

**xxxAutoConfiguration:自动配置类,给容器中添加组件；**

**xxxProperties:封装组件的默认属性,；**



### 4、细节

#### 1、@Conditional派生注解（条件注解） 

> 利用Spring注解版原生的@Conditional作用

作用：必须是@Conditional指定的条件成立，才给容器中添加组件，配置配里面的所有内容才生效；**自动配置类必须在一定条件下生效**

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

我们可以通过启用debug=true属性，配置文件，打印自动配合报告，**这样就可以知道哪些自动配置类生效**

```properties
debug=true
```

自动配置报告

```java
============================

CONDITIONS EVALUATION REPORT
============================


Positive matches:（积极的，启动的，匹配成功的）
-----------------

   CodecsAutoConfiguration matched:
      - @ConditionalOnClass found required class 'org.springframework.http.codec.CodecConfigurer'; @ConditionalOnMissingClass did not find unwanted class (OnClassCondition)
        ......
        
 Negative matches:（消极的，没有启动的，没有匹配成功的）
-----------------

   ActiveMQAutoConfiguration:
      Did not match:
         - @ConditionalOnClass did not find required classes 'javax.jms.ConnectionFactory', 'org.apache.activemq.ActiveMQConnectionFactory' (OnClassCondition)
.....
```

[Springboot的所有可配置参数](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#common-application-properties)

# 三、日志

> Spring Boot2对日志有更改
>
> Spring Boot:底层是Spring框架，**Spring默认框架是JCL**；
>
> **SpringBoot选用==SLF4J和logback==**

### 3、SpingBoot日志框架解析

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

3. 起着commons.loggings的名字其实new的SLF4J替换中间包,SpringBoot2中改成了bridge

4. 如果要引入其他框架？一定要把这个框架的日志依赖移除掉.

### 4、日志的使用

#### 1、默认配置

**日志级别： trace < debug < info < warn < error**

一、调整日志级别（具体到哪个包，**springboot默认root包，info级别**）

```properties
logging.level.org.hut=trace
```

二、调整日志控制台输出格式

```properties
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n
控制台输出的日志格式 :
    #%d：日期
    #%thread：线程号 
    #%-5level：靠左+级别 
    #%logger{50}：全类名50字符限制,否则按照句号分割
    #%msg：日志信息
    #%n：换行
```

 三、调整日志文件的格式和位置

```properties
logging.file=d:/springboot.log #建议用这个
logging.path=/demo/log #在项目的所在磁盘的根路径（D盘）下创建spring/log文件夹，默认文件名为spring.log
#file与path都可以用，用其中一个就可以了。

#指定文件中日志输出的格式
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n
```

使用：

```java
//记录器
Logger logger = LoggerFactory.getLogger(getClass());
@Test
public void contextLoads() {

    //几个方法
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

(推荐)**logback-spring.xml**日志框架就不直接加载日志配置项，由SpringBoot加载，可以使用SpringBoot中的其他功能。

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
# 排除start-logging
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

