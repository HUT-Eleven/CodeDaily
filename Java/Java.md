---
typora-copy-images-to: ./assets
typora-root-url: ./assets
---

## 基础知识

### 环境变量

Environment Variable
运行一个命令或者程序时，系统默认在当前路径下查找，再去环境变量中查找。
配置环境变量的作用：即可以在任意路径下执行该命令/程序。

可用**本地变量**优先于环境变量，产生临时生效的效果。

classpath：jvm启动类的路径，可多值，用分号隔开。

### .class和.java文件

**.java**：我们编写的文件

**.class**：.java-->javac编译后的字节码文件，是**真正由JVM运行的文件**，可以运行在任何的JVM虚拟机上(即：一次编译，多出运行。)

**jar包的作用**：其实就是把.class文件放到一个文件夹中，方便第三方使用。

### classpath

> 指的是.class文件所在的**目录**。既然是.class文件，则讨论点应该是**项目打包后的目录结构**。

一、以**SSM**架构项目举例，打成**==war==**包：

<img src="/image-20200614121939444.png" alt="image-20200614121939444" style="zoom:60%;" />

上部分是源代码的目录结构，下部分是编译打包后的目录结构。

问：==哪里有.class文件呢？==

答：WEB-INF/classes下  和  WEB-INF/lib/xxx.jar包下。

1. 对于引用我们自身写的配置文件时，则**classpath=WEB-INF/classes**,
   e.g.  **引用classpath:config/application-dao.xml ，等价于WEB-INF/classes/config/application-dao.xml**，这是因为原本写在resource目录下的文件，被编译到了classes底下。所以有种说法是maven项目中，resource目录即classpath路径。

​	2. **对于maven引用的jar，其实本身也是一个项目**，所以此时的classpath可能会去自身jar中查找，当然也有可能去访问WEB-INF/classes目录

二、以SpringBoot项目为例，打成**==jar==**包

> 项目打成jar包和war包的目录结构是不同的，而且也和框架有关，像springboot的包目录结构就是自身设定的。

springboot打成jar后的目录结构：

![1592110112127](/1592110112127.png)

如图所示:

BOOT-INF/classes：项目中的java文件编译后的.class文件

BOOT-INF/lib：maven依赖的jar

所以此时的**classpath=BOOT-INF/classes  或   BOOT-INF/lib**

### 打jar包运行

#### 运行方式

##### 1. 原生命令打包

1. 编译：`javac  org/hut/Demo.java`
   如果有中文：`javac -encoding UTF-8 org/hut/Demo.java`
2. 打包：`jar -cvf Demo-snapshot-0.0.1.jar org/hut/Demo.class`
3. 运行：`java -jar  Demo-snapshot-0.0.1.jar`   **报错： xxx没有主清单属性** 
   打开`META-INF/MENIFEST.MF`, 加入`Main-Class: org.hut.Demo`(**冒号后面有一个空格,最后必须预留一个空行**)

##### 2.  Maven插件打包

> 打完可直接运行

```xml
<!-- 以下网上随便摘抄的一个插件模板 -->
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>2.6</version>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <classpathPrefix>lib/</classpathPrefix>
                        <mainClass>org.hut.B</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
            <version>2.10</version>
            <executions>
                <execution>
                    <id>copy-dependencies</id>
                    <phase>package</phase>
                    <goals>
                        <goal>copy-dependencies</goal>
                    </goals>
                    <configuration>
                        <outputDirectory>${project.build.directory}/lib</outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

##### 3. IDE打包

> 此处不赘述

一般java项目可以打成Jar包或者war包，war包一般丢到tomcat中运行，而jar一般是用nohup运行

#### 零散要点

- java运行jar包时携带参数的方式：

  1. 使用`-D`携带自定义参数，程序中可用System.getProperty("xxx")取

     `java -jar -Dname=tom -Dconfig=/tmp/sun.config Demo.jar `

  2. 或者直接跟在命令后面，那就是直接传给main(Srting[] args) 中args了。

  3. 还有就是框架自身去读取命令参数，如SpringBoot就可携带很多参数，程序中会主动去读取这些参数

- `META-INF/MENIFEST.MF`文件中的Main-Class的值是程序的入口，也即main函数所在的位置。

## 面向对象

概念：你充电话费是面向过程，而你女朋友充电话费就是面向对象。
特征：封装、继承、多态

### 成员变量&局部变量

区别：

成员变量---定义在类中，是'类信息'----整个类都能访问---存在于实例对象中，也即堆内存中---生命周期随GC---有**默认初始化**值

局部变量---定义在函数/语句/代码块中---只在所属区域有效---存在于方法中，也即栈内存中---生命周期随栈帧---无默认初始化值

小结：**局部变量可以说是服务于成员变量**，例如我们常见场景，都是方法中的局部变量赋予对象中的某个属性，来改变对象。**面向对象设计的程序，对象是程序的细胞，数据是程序的血液**。

注意：局部变量与成员变量尽量不要同名，同名时局部优先。

### 基本数据类型传递和引用数据类型传递

<img src="/image-20200423005619196.png" alt="image-20200423005619196" style="zoom:80%;" />

本质的差异是引用数据类型传递的是**对象的地址**，所以不同的方法操作的是同一个对象。

### 封装概念

概念：隐藏对象的属性，提供公共的访问方式（getter、setter）。所以常见类的属性都有private修饰。包括**接口、内部类**都是封装思想的体现。

### 权限修饰符

> **权限修饰符修饰成员**（成员变量和成员方法）

![image-20200423011111363](/image-20200423011111363.png)

**同一package**：必须是同一文件夹，在子文件夹中都不行。

**常见两点：private，只在当前类有效。要想其他类都能访问，必须public**。

### 构造函数

**作用**：构造函数的使命就是给对象初始化。构造函数与成员函数是有明显的差异性。

**特点**：

1. 函数名与类名相同；

2. 无返回值类型，也无返回值。**一旦加了返回值类型，则为一般函数，不会报错**；

3. 无显式定义构造函数时，有默认的无参构造函数；有显式则无默认无参；

4. 构造函数也会进栈，对象开辟内存空间后调用构造函数对自身进行了“构造函数初始化”；

5. 构造函数里可以调用其他方法，但其他方法肯定是不能调用构造函数；

   举个极端点的例子：一般方法与构造方法同名，且在构造方法中调用了这个同名方法。通过这个例子可以看出构造函数是不受一般函数影响的。

   ```java
   public class ConDemo {
   
   	private String name;
   	private int age;
   
   	public	ConDemo() {
   		super();
   		ConDemo();
   	}
   	public void ConDemo() {
   		System.out.println("123");
   	}
   	public static void main(String[] args) {
   		ConDemo conDemo = new ConDemo();// 输出123
   		conDemo.ConDemo();// 还会输出123
   	}
   }
   ```

6. 构造函数不存在覆盖和继承；


#### 构造代码块

1. 反编译后，发现构造代码块的内容**会出现在各个构造函数中的前部**。所以构造代码块的执行顺序是优先构造函数的。

### this

> **指向的是当前对象的引用**。

**作用：**

1. this.变量 ：用来区分重名的成员变量和局部变量；
2. this.方法：this就是该对象的引用。区分到底是哪个对象调用了此方法。

**话外**：一个成员函数、成员属性一定是被对象调用，不会平白出现。构造函数也是被对象调用，用来对对象自身进行初始化。除了static成员之外。

**没有用this的情况**：

<img src="/image-20200428220231852.png" alt="image-20200428220231852" style="zoom:50%;" />

### static

**作用**：

1. 成员修饰符（成员变量、成员方法），==不能修饰局部变量==。
2. 静态代码块。

**特点**：

1. 数据共享
2. static修饰的成员随类的加载而加载
3. 可以直接被类名调用，也可以被对象调用
4. 静态方法只能访问静态成员,无法从静态上下文中引用非静态，静态方法中不能使用this和super；

#### 静态代码块

1. 随着类的加载而“执行”，而且只执行一次。
2. 常用于给类进行初始化动作。

### 继承

**父类中的私有内容，子类是否具备？**
答：不用纠结是否继承。Java官方文档的解释：子类不能继承父类的私有属性，但是如果父类中公有的方法影响到了父类私有属性，那么私有属性是能够被子类使用的。

#### 对象实例化过程

**成员变量的变化：**

默认初始化-父类初始化-显示初始化--构造代码块初始化--构造函数初始化（默父显块构）.
静态此处不讨论。

### super

1. 可以视为是父类的引用，子父类成员（变量+方法）同名时，super用来区分父类。

2. this和super在构造函数都只能定义在第一行，所以**只能二选一**。但即便是this(),也会在其他构造函数中调用super，父类必须先完成初始化。

   ![image-20200429231002524](/image-20200429231002524.png)

### @Override

方法重载：同一个类中，方法名相同，但参数列表不同（参数类型不同或个数不同，**和返回值以及修饰符无关**）
方法覆盖：发生在子父类中，子类重写父类的方法，方法名、参数列表都一样，jdk7开始，**返回值类型可以是原返回值的子类。**

注意点：

1. **子类覆盖的方法的权限必须大于等于父类**
2. **如果父类的方法是private,则不叫覆盖**，子类压根就不知道父类有这个方法，这叫子类自己建立了自己的方法。
3. 静态方法只能覆盖静态方法，也只能被静态方法覆盖。这个很少见。
4. 覆盖会打破封装性

### final

1. 类，不能被继承；
2. 方法，不能被覆盖；
3. 变量，基础数据类型为常量；引用数据类型为地址不可变，但所引用的对象可变。**而且都必须进行显示初始化.**

###  抽象类

> **abstract**：可以修饰==类、方法==

1. 可以有抽象方法，也可以有非抽象方法。有些抽象类中的非抽象方法是空实现，其实就是抽象方法。

2. 不能被实例化；

3. **有构造函数**；按照java设计原则，类的初始化过程必须包含父类初始化，所以虽然抽象类不能实例化，但应该有构造函数，可用于给子类初始化。

4. 不能同时存在：

   - private（私有化的方法就无法覆盖了，就一直抽象）
   - static（abstract static的方法又无实现，不合常理）
   - final（final修饰的类/方法不能被继承/覆盖,与abstract完全相冲,注意只要不是同时修饰就合理，比如final类里就可以有abstract方法）

   **注意：**abstract只修饰类和方法，所以当以下几个关键字修饰成员变量时是无关的。如:

   ```java
   public abstract class AbstrctDemo {
   
   	static final int i = 1;	// 合理	
       private int j;			// 合理
   }
   ```

### 接口

> 等于**更加“纯正”的抽象类**

1. ```java
   // 成员变量
   public static final int i = 10;
   // 成员方法
   public abstract xxx
   ```

2. 多实现，**接口之间**可以多继承。因为接口都是全抽象的，所以不存在调用的不确定性。
   注意以下情况：会出现覆盖的不合理

   ```java
   interface Interface01 {
   	void show();
   }
   
   interface Interface02 {
   	int show();
   }
   
   class Demo implements Interface01,Interface02{
   
   	@Override
   	public int show() {
   		return 0;
   	}
   }
   ```

3. ==**接口没有构造函数**==

4. 接口中没有非抽象的方法，也说明了**接口是不继承Object类的**

**接口与抽象类的区别：**抽象类多用来描述“类”，接口都用来描述“功能”，接口多实现的特点，也使其扩展性更强。

### 多态

> 1. 一个对象，多种类型。
> 2. 父类或者接口的引用指向其子类的对象

1. 转型

   - 向上转型（自动类型提升）

     ```java
     Animal a = new Dog();// 自动类型提升，a引用类型已经自动提升为Animal，所以Dog的特有功能已经无法访问.
     ```

   - 向下转型（类型强转）
     无论向上向下，至始至终都是**==子类的对象==在做引用类型的变化**。

2. instanceof
3. **成员的特点**：
  
   - 成员变量：编译运行都看左边（父类）（成员变量不存在多态性，更不会是覆盖）
   - 一般函数：编译看左边，运行看右边，（子类若覆盖/实现了就用子类的，没有就用父类的）
   - 静态函数：编译运行都看左边。（静态方法在静态区，直接被类名调用，不存在多态）

### 内部类

> 设计原因：因为private成员，在外部是无法访问的，而内部类可以直接访问外部类，则可以解决这个问题。
>
> [内部类学习](https://www.cnblogs.com/dearcabbage/p/10609838.html)

1. 内部类可以直接访问外部类，**外部类**必须**new 内部类对象**才能访问内部类成员

2. **外部**如何new内部类

   - 非静态

     ```java
     Outer.Inner  in = new  Outer().new  Inner()
     ```

   - 静态

     ```java
     Outer.Inner  in = new  Outer.Inner()
     ```
   
3. 为什么可以直接访问外部类的成员？因为内部类持有外部类的引用。即：外部类名.this

4. 如果内部类中定义了静态成员（变量/方法），则内部类也必须是静态的。（静态成员随类的加载而加载）可以直接用类名调用：Outer.Inner.show()

5. 位置

   - 成员内部类
     
     1. 可以被成员修饰符修饰
     
   - 局部内部类
     1. 符合局部位置的特点，只能内部访问，在方法外不知道这个“局部内部类”的存在；
     2. **局部内部类访问它所在方法的局部变量/形参时，要求该局部变量必须声明为final的原因**：对象的生命周期往往会比局部变量的长，比如我们可以把局部内部类的对象指向给其他的引用，这样这个对象就可以一直生存着，而局部变量随着方法出栈就消失了。此时，如果我们在用这个存活的变量调用已经死了的局部变量就会报错。jdk8开始，会默认给这个情况的局部变量加上隐式final，但最好手动加上.
        **形参也要加final**
     
   - 匿名内部类

   - 静态内部类

     

## ==注解==

> 注解：也叫“元数据”，可以理解为“**标签**”，给类/接口/成员方法/成员属性/注释信息...等等加注解，就是来贴标签，来标注一些信息。
> 比如：
> 		@Test：标注这个方法需要被测试；
> 		@Deprecated:标注已过时；
> 		@Override：标注是覆盖；
> 		Spring中的@Configuration：标注这是一个配置类；等等....

### 作用

1. 文档：比如方法/类上的注释@Since/@Param等等，可辅助生成文档。

2. 编译检查：@Override/@Deprecated/....

3. **==代码分析标注等等==**：比如Spring中的@Configuration，标注这是一个配置类，@Bean，标注这是一个Bean。

4. .....略

### Java 预置注解

- @Deprecated
- @SuppressWarnings
- @SafeVarargs：参数安全类型注解
- @FunctionalInterface：函数式接口注解
- ...略...

### 自定义注解

#### 格式

```java
元注解
[自定义注解]
public @interface AnnotationName{
    属性类型 属性名() [default];
}
```

#### 本质

编译后，再反编译`javap TestAnnotation.class`，得到：

```java
Compiled from "TestAnnotation.java"
public interface TestAnnotation extends java.lang.annotation.Annotation {}
// 本质上就是一个接口，继承了Annotation接口
```

#### 属性

> 注解本质是接口，注解的属性相当于接口中的方法。反编译：

```java
public interface TestAnnotation extends java.lang.annotation.Annotation {
  public abstract int age();
}
```

> - 以“**无形参的方法**”形式来声明
> - 方法名=属性名
> - 方法返回值=属性类型。

- **要求1：属性类型**只能是：

  - 8种基本数据类型
  - String
  - 注解
  - 枚举
  - 以上类型的数组形式

- 要求2：使用注解时，需要给属性赋值

  - default：给属性赋默认值

    ```java
    public @interface TestAnnotation{
        int age() default 1;
    }
    ```

  - value：如果该注解只有一个属性，且属性的值叫value，则使用时可以直接赋值，不需要带value=

- **要求3：元注解**

  - @Target:表明注解可使用的地方

    - ElementType.ANNOTATION_TYPE 可以给一个注解进行注解
    - ElementType.CONSTRUCTOR 可以给构造方法进行注解
    - ElementType.FIELD 可以给属性进行注解
    - ElementType.LOCAL_VARIABLE 可以给局部变量进行注解
    - ElementType.METHOD 可以给方法进行注解
    - ElementType.PACKAGE 可以给一个包进行注解
    - ElementType.PARAMETER 可以给一个方法内的参数进行注解
    - ElementType.TYPE 可以给一个类型进行注解，比如类、接口、枚举

    ```java
    @Target({ElementType.METHOD,ElementType.TYPE})// 方法或者Type上
    ```

  - @Retetion:保留期

    - RetentionPolicy.SOURCE 注解只在源码阶段保留，在编译器进行编译时它将被丢弃忽视。
    - RetentionPolicy.CLASS 注解只被保留到编译进行的时候，它并不会被加载到 JVM 中。
    - **RetentionPolicy.RUNTIME** 注解可以保留到程序运行的时候，它会被加载进入到 JVM 中，所以在程序运行时可以获取到它们。

  - @Documented：注解可以保留在javadoc文档中

  - @Inherited：描述注解是否被子类继承

    ```java
    @Inherited
    public @interface A{}
    
    @A
    public class B{}
    
    public class C extends B{}// 则C也存在@A注解的
    ```

  - Repeatable：可重复（待研究）

### 读取注解

> 需要用到反射

1. 获取注解所在的TYPE （class/Method/Field...）；
2. .getAnnotation(...)获取注解；
3. 调用注解的方法(也即注解的属性)，获取值



## ==枚举==

### 定义枚举

```java
public enum Season {	// enum是关键字，Enum是类
    SPRING,SUMMER,AUTUMN,WINTER	// 都是Season的实例
}
```

### 本质

javap 反编译，得到：

```java
# javap Season.class
    
Compiled from "Season.java"
public final class org.hut.Season extends java.lang.Enum<org.hut.Season> {
  public static final org.hut.Season SPRING;
  public static final org.hut.Season SUMMER;
  public static final org.hut.Season AUTUMN;
  public static final org.hut.Season WINTER;
  public static org.hut.Season[] values();
  public static org.hut.Season valueOf(java.lang.String);
  static {};
}
```

**1. 继承Enum类**

Enum类:

```java
public abstract class Enum<E extends Enum<E>> implements Comparable<E>, Serializable {.......}
```

Enum类中的方法：上个红框是继承和实现的方法，下边红框是Enum类中的方法。**这些方法全是final修饰，无法被覆盖。**

<img src="/image-20200610005742079.png" alt="image-20200610005742079" style="zoom:67%;" />

**Enum类的方法初探：**

```java
protected Enum(String name, int ordinal) {	//构造方法
    this.name = name;						//取个名
    this.ordinal = ordinal;					//序号，从0开始
}
name():取出枚举名	// System.out.println(Season.SPRING.name()); // SPRING
oridinal():取序号
valueOf(String):通过字符串得到枚举
// 其他方法有用到再细品
```

**2. final修饰，所以无法继承**

**3. 成员变量**

就是“常量”, 所以**枚举的功能就体现出来了，快速定义常量**.但我们知道final是最终的意思，而static又是随类加载，所以final + static修饰的变量应该在类加载时就要进行初始化的。如果不赋值，直接默认初始化，那这个变量就没意义了，所以一定要显示初始化，而这个动作就是static{}中完成的。

```java
public static final org.hut.Season SPRING;
public static final org.hut.Season SUMMER;
public static final org.hut.Season AUTUMN;
public static final org.hut.Season WINTER;
```

**4. 成员方法**

反编译后有两个方法：

```java
public static org.hut.Season[] values();		// 取出所有对象
public static org.hut.Season valueOf(java.lang.String);		// 覆盖父类方法，不常用
```

**5. 静态代码块**

**6. 枚举类的构造函数**

其实枚举类中是默认有个构造函数的：

```java
Season(){}
//[枚举类的构造器不可以添加访问修饰符，枚举类的构造器默认是private的。但你自己不能添加private来修饰构造器。]
```

### 注意：

1. [比较枚举时推荐用==，不推荐用equals](https://www.cnblogs.com/xiohao/p/7405423.html)

   - 不会抛出 NullPointerException

   ```
   enum Color { BLACK, WHITE };
   
   Color nothing = null;
   if (nothing == Color.BLACK);      // runs fine
   if (nothing.equals(Color.BLACK)); // throws NullPointerException
   ```

   - 在编译期检测类型兼容性

   ```
   enum Color { BLACK, WHITE };
   enum Chiral { LEFT, RIGHT };
   
   if (Color.BLACK.equals(Chiral.LEFT)); // compiles fine
   if (Color.BLACK == Chiral.LEFT);      // DOESN'T COMPILE!!! Incompatible types!
   ```

2. 线程不安全问题：因为枚举是单例，所以在枚举中定义成员属性时，该属性是共享的。如果此时存在方法能改变该属性的值，则该属性是线程不安全的。所以枚举中最好不要定义setter方法。



## Java中正则相关类

java中对于正则的操作类都在java.util.regex 包中：

**Pattern 类：**

> pattern 对象是一个正则表达式的**编译表示**

转义符：这里的转义符用法逻辑和shell中grep等一些命令一样。
在代码中，`\\在代码中会转义成\`，所以java中`\\d才表示\d`,`表示一个普通的反斜杠是 \\\\`

**Matcher 类：**

> Matcher 对象是对输入字符串进行解释和匹配操作的**引擎**
>

#### API

> API就是对应的正则的操作而来的：查找（即匹配）、替换、索引

##### 1. 查找

- 简单匹配：

  ```java
  // 获取正则表达式对象Pattern
  Pattern p = Pattern.compile("a*b");
  
  //获取匹配引擎Matcher
  Matcher m = p.matcher("aaaaab");
  
  // 匹配结果
  boolean b = m.matches();
  
  针对上方的简化，但复用性弱:
  boolean b = Pattern.matches("a*b","aaaaab")
  ```
  
- 捕获组**(实际常用**)

  ```java
  Pattern pattern = Pattern.compile("(T|t)he\\s(fat|mat)");
  Matcher matcher = pattern.matcher("The fat cat sat on the mat.");
  
  find方法和group方法的区别：
  while (matcher.find()) {
      for (int i = 0; i <= matcher.groupCount(); i++) {
          System.out.println("Group " + i + ": " + matcher.group(i));
          System.out.println(matcher.start());
          System.out.println(matcher.end());
      }
  }
  /**
  Group 0: The fat
  Group 1: T
  Group 2: fat
  
  Group 0: the mat
  Group 1: t
  Group 2: mat
  
  1. 先用整条去匹配，得到group(0)/group()。在整条中每组又会单独去匹配。
  
  2. 组序列号：从左开始"("，第几个就是第几组。
      e.g. (A)(B(C))
      - group(0):(A)(B(C))
  	- group(1):(A)
  	- group(2):(B(C))
  	- group(3):(C)  
  
  e.g.: ((mat)):这里面就包含3组，组数=括号数+1
**/
  ```

  注：matcher(...)：**全部匹配**，是将整个字符串与pattern进行匹配

  ​		find(...)：**部分匹配**，查找输入串中与模式匹配的**子串**，如果该匹配的串有组还可以使用group()函数。

  ​		如果先matcher了，匹配器中的last(也即角标)会到最后，所以此时在find从last角标开始匹配是匹配不到数据的，可以reset(..)重置Matcher匹配器。这原理和迭代器很像。
  
  

##### 2. 替换

- **replaceFirst** ：替换首次匹配
  **replaceAll** ：替换所有匹配

- **appendReplacement** ：将当前匹配子串替换为指定字符串，并且将替换后的子串以及其之前到上次匹配子串之后的字符串段添加到一个StringBuffer对象里
  **appendTail**：将最后一次匹配工作后剩余的字符串添加到一个StringBuffer

  ```java
  Pattern p = Pattern.compile("2");
  Matcher m = p.matcher("121211111");
  StringBuffer sb = new StringBuffer();
  while (m.find()) {
      m.appendReplacement(sb, "3");
      System.out.println("sb:" + sb);
      // 第一次：sb:13，第二次：sb:1313
  }
  m.appendTail(sb);//将最后一次匹配工作后剩余的字符串‘11111’添加到一个StringBuffer中
  System.out.println("sb:" + sb);	//输出内容:131311111
  ```
  
  

还有其他方法都是对应正则里的API

1. **Pattern.complie(String regex,int flag)**，它接受一个标记参数flag，以调整匹配的行为.

| 编译标记                     | 效果                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| Pattern.CANON_EQ             | 两个字符当且仅当它们的完全规范分解相匹配时，就认为它们是匹配的，例如，如果我们指定这个标记，表达式a\u030A就会匹配字符串？。在默认的情况下，匹配不考虑规范的等价性 |
| Pattern.CASE_INSENSITIVE(?i) | 默认情况下，大小写不敏感的匹配假定只有US-ASCII字符集中的字符才能进行。这个标记允许模式匹配不必考虑大小写（大写或小写）。通过指定UNICODE_CASE标记及结合此标记，基于Unicode的大小写不敏感的匹配就可以开启了,也可以**使用嵌入的标记表达式?i开启，下同** |
| Pattern.COMMENTS(?x)         | 在这种模式下，**表达式中的**空格(**不是指\s**,单纯指空格)将被忽略掉，并且以#开始直到行末的注释也会被忽略掉。通过嵌入的标记表达式也可以开启Unix的行模式 |
| Pattern.DOTALL(?s)           | 在dotall模式中，表达式“.”匹配所有字符，包括行终结符。默认情况下，“.”表达式不匹配行终结符 |
| Pattern.MULTLINE(?m)         | 在多行模式下，表达式^和$分别匹配一行或输入字符串的开始和结束。默认情况下，这些表达式仅匹配输入的完整字符串的开始和结束 |
| Pattern.UNICODE_CASE(?u)     | 当指定这个标记，并且开启**CASE_INSENSITIVE**时，大小写不敏感的匹配将按照与Unicode标准相一致的方式进行。默认情况下，大小写不敏感的匹配假定只能在US-ASCII字符集中的字符才能进行 |
| Pattern.UNIX_LINES(?d)       | 在这种模式下，在.、^和$行为中，只识别行终结符\n              |

e.g.:大小写敏感:

```java
Pattern pattern = Pattern.compile("c.+t", Pattern.CASE_INSENSITIVE);
```



  

  

  















