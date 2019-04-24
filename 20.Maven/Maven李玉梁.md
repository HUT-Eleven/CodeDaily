### MAVEN

1，Maven，发音是[`meivin]，"专家"的意思。

2，Maven不同于ant ivy make command  IDE这些都是构建工具，构建通俗来说最主要的作用就是将代码或者项目包装起来，放到另外一个地方去操作，对于MAVEN约定大于配置，他预先定义好了编译，打包，发布，	等一系列流程



#### maven是什么

maven将自己定位为一个项目管理工具。它负责管理项目开发过程中的几乎所有的东西：

1. 版本 
   maven有自己的版本定义和规则

2. 构建 
   maven支持许多种的应用程序类型，对于每一种支持的应用程序类型都定义好了一组构建规则和工具集。

3. 输出物管理 
   maven可以管理项目构建的产物，并将其加入到用户库中。这个功能可以用于项目组和其他部门之间的交付行为。

4. 依赖关系 
   maven对依赖关系的特性进行细致的分析和划分，避免开发过程中的依赖混乱和相互污染行为

5. 文档和构建结果 
   maven的site命令支持各种文档信息的发布，包括构建过程的各种输出，javadoc，产品文档等。

6. 项目关系 
   一个大型的项目通常有几个小项目或者模块组成，用maven可以很方便地管理

7. 移植性管理 
   maven可以针对不同的开发场景，输出不同种类的输出结果。

   

   

   #### maven的生命周期

   maven把项目的构建划分为不同的生命周期(lifecycle)，粗略一点的话，它这个过程(phase)包括：编译、测试、打包、集成测试、验证、部署。maven中所有的执行动作(goal)都需要指明自己在这个过程中的执行位置，然后maven执行的时候，就依照过程的发展依次调用这些goal进行各种处理。

   这个也是maven的一个基本调度机制。一般来说，位置稍后的过程都会依赖于之前的过程。当然，maven同样提供了配置文件，可以依照用户要求，跳过某些阶段。

   

   #### maven的"约定优于配置"

   所谓的"约定优于配置"，在maven中并不是完全不可以修改的，他们只是一些配置的默认值而已。但是使用者除非必要，并不需要去修改那些约定内容。maven默认的文件存放结构如下：

   - /项目目录
     - pom.xml 用于maven的配置文件
     - /src 源代码目录
       - /src/main 工程源代码目录
         - /src/main/java 工程java源代码目录
       - /src/main/resource 工程的资源目录
       - /src/test 单元测试目录
         - /src/test/java
     - /target 输出目录，所有的输出物都存放在这个目录下
       - /target/classes 编译之后的class文件

   每一个阶段的任务都知道怎么正确完成自己的工作，比如compile任务就知道从src/main/java下编译所有的java文件，并把它的输出class文件存放到target/classes中。

   对maven来说，采用"约定优于配置"的策略可以减少修改配置的工作量，也可以降低学习成本，更重要的是，给项目引入了统一的规范。

   

   #### maven的版本规范

   

   maven使用如下几个要素来唯一定位某一个输出物： `groupId:artifactId:packaging:version` 。比如 `org.springframework:spring:2.5` 。每个部分的解释如下：

   - groupId 
     团体，公司，小组，组织，项目，或者其它团体。团体标识的约定是，它以创建这个项目的组织名称的逆向域名(reverse domain name)开头。来自Sonatype的项目有一个以com.sonatype开头的groupId，而Apache Software的项目有以org.apache开头的groupId。
   - artifactId 
     在groupId下的表示一个单独项目的唯一标识符。比如我们的tomcat, commons等。不要在artifactId中包含点号(.)。
   - version 
     一个项目的特定版本。发布的项目有一个固定的版本标识来指向该项目的某一个特定的版本。而正在开发中的项目可以用一个特殊的标识，这种标识给版本加上一个"SNAPSHOT"的标记。 
     虽然项目的打包格式也是Maven坐标的重要组成部分，但是它不是项目唯一标识符的一个部分。一个项目的 groupId:artifactId:version使之成为一个独一无二的项目；你不能同时有一个拥有同样的groupId, artifactId和version标识的项目。
   - packaging 
     项目的类型，默认是jar，描述了项目打包后的输出。类型为jar的项目产生一个JAR文件，类型为war的项目产生一个web应用。
   - classifier 
     很少使用的坐标，一般都可以忽略classifiers。如果你要发布同样的代码，但是由于技术原因需要生成两个单独的构件，你就要使用一个分类器（classifier）。例如，如果你想要构建两个单独的构件成JAR，一个使用Java 1.4编译器，另一个使用Java 6编译器，你就可以使用分类器来生成两个单独的JAR构件，它们有同样的groupId:artifactId:version组合。如果你的项目使用本地扩展类库，你可以使用分类器为每一个目标平台生成一个构件。分类器常用于打包构件的源码，JavaDoc或者二进制集合。

   maven有自己的版本规范，一般是如下定义 `<major version>.<minor version>.<incremental version>-<qualifier>` ，比如1.2.3-beta-01。要说明的是，maven自己判断版本的算法是major,minor,incremental部分用数字比较，qualifier部分用字符串比较，所以要小心 alpha-2和alpha-15的比较关系，最好用 alpha-02的格式。

   maven在版本管理时候可以使用几个特殊的字符串 `SNAPSHOT` ,`LATEST` ,`RELEASE` 。比如"1.0-SNAPSHOT"。各个部分的含义和处理逻辑如下说明：

   - SNAPSHOT 
     如果一个版本包含字符串"SNAPSHOT"，Maven就会在安装或发布这个组件的时候将该符号展开为一个日期和时间值，转换为UTC时间。例如，"1.0-SNAPSHOT"会在2010年5月5日下午2点10分发布时候变成1.0-20100505-141000-1。 
     这个词只能用于开发过程中，因为一般来说，项目组都会频繁发布一些版本，最后实际发布的时候，会在这些snapshot版本中寻找一个稳定的，用于正式发布，比如1.4版本发布之前，就会有一系列的1.4-SNAPSHOT，而实际发布的1.4，也是从中拿出来的一个稳定版。

   - LATEST 
     指某个特定构件的最新发布，这个发布可能是一个发布版，也可能是一个snapshot版，具体看哪个时间最后。

   - RELEASE 
     指最后一个发布版。

     

     ####  maven的组成部分

     maven把整个maven管理的项目分为几个部分，一个部分是源代码，包括源代码本身、相关的各种资源，一个部分则是单元测试用例，另外一部分则是各种maven的插件。对于这几个部分，maven可以独立管理他们，包括各种外部依赖关系。

     

     #### maven的依赖管理

     依赖管理一般是最吸引人使用maven的功能特性了，这个特性让开发者只需要关注代码的直接依赖，比如我们用了spring，就加入spring依赖说明就可以了，至于spring自己还依赖哪些外部的东西，maven帮我们搞定。

     任意一个外部依赖说明包含如下几个要素：groupId, artifactId, version, scope, type, optional。其中前3个是必须的，各自含义如下：

     - groupId 必须
     - artifactId 必须
     - version 必须。 
       这里的version可以用区间表达式来表示，比如(2.0,)表示>2.0，[2.0,3.0)表示2.0<=ver<3.0；多个条件之间用逗号分隔，比如[1,3),[5,7]。
     - scope 作用域限制
     - type 一般在pom引用依赖时候出现，其他时候不用
     - optional 是否可选依赖

     maven认为，程序对外部的依赖会随着程序的所处阶段和应用场景而变化，所以maven中的依赖关系有作用域(scope)的限制。在maven中，scope包含如下的取值：

     - compile（编译范围） 
       compile是默认的范围；如果没有提供一个范围，那该依赖的范围就是编译范围。编译范围依赖在所有的classpath中可用，同时它们也会被打包。
     - provided（已提供范围） 
       provided依赖只有在当JDK或者一个容器已提供该依赖之后才使用。例如，如果你开发了一个web应用，你可能在编译classpath中需要可用的Servlet API来编译一个servlet，但是你不会想要在打包好的WAR中包含这个Servlet API；这个Servlet API JAR由你的应用服务器或者servlet容器提供。已提供范围的依赖在编译classpath（不是运行时）可用。它们不是传递性的，也不会被打包。
     - runtime（运行时范围） 
       runtime依赖在运行和测试系统的时候需要，但在编译的时候不需要。比如，你可能在编译的时候只需要JDBC API JAR，而只有在运行的时候才需要JDBC驱动实现。
     - test（测试范围） 
       test范围依赖 在一般的 编译和运行时都不需要，它们只有在测试编译和测试运行阶段可用。
     - system（系统范围） 
       system范围依赖与provided类似，但是你必须显式的提供一个对于本地系统中JAR文件的路径。这么做是为了允许基于本地对象编译，而这些对象是系统类库的一部分。这样的构件应该是一直可用的，Maven也不会在仓库中去寻找它。 **如果你将一个依赖范围设置成系统范围，你必须同时提供一个systemPath元素** 。注意该范围是不推荐使用的（你应该一直尽量去从公共或定制的Maven仓库中引用依赖）。

     另外，代码有代码自己的依赖，各个maven使用的插件也可以有自己的依赖关系。依赖也可以是可选的，比如我们代码中没有任何cache依赖，但是hibernate可能要配置cache，所以该cache的依赖就是可选的。

     #### 多项目管理

     maven的多项目管理也是非常强大的。一般来说，maven要求同一个工程的所有子项目都放置到同一个目录下，每一个子目录代表一个项目，比如

     - 总项目/
       - pom.xml 总项目的pom配置文件
       - 子项目1/
         - pom.xml 子项目1的pom文件
       - 子项目2/
         - pom.xml 子项目2的pom文件

     按照这种格式存放，就是继承方式，所有具体子项目的pom.xml都会继承总项目pom的内容，取值为子项目pom内容优先。

     要设置继承方式，首先要在总项目的pom中加入如下配置

     ```
     <modules> 
         <module>simple-weather</module> 
         <module>simple-webapp</module> 
     </modules>
     ```

     

其次在每个子项目中加入

​		

```
<parent> 
    <groupId>org.sonatype.mavenbook.ch06</groupId> 
    <artifactId>simple-parent</artifactId> 
    <version>1.0</version> 
    <relativePath/>
</parent>  
```

即可。

当然，继承不是唯一的配置文件共用方式，maven还支持引用方式。引用pom的方式更简单，在依赖中加入一个type为pom的依赖即可。

```
<project> 
    <description>This is a project requiring JDBC</description> 
    ... 
    <dependencies> 
        ... 
        <dependency> 
            <groupId>org.sonatype.mavenbook</groupId> 
            <artifactId>persistence-deps</artifactId> 
            <version>1.0</version> 
            <type>pom</type> 
        </dependency> 
    </dependencies> 
</project>
```

#### 对于relativePath标签



官方原文档：

The relative path of the parent pom.xml file within the check out. 

###### If not specified, it defaults to ../pom.xml. Maven looks for the parent POM first in this location on the filesystem, then the local repository, and lastly in the remote repo. 

relativePath allows you to select a different location, for example when your structure is flat, or deeper without an intermediate parent POM. However, the group ID, artifact ID and version are still required, and must match the file in the location given or it will revert to the repository for the POM. This feature is only for enhancing the development in a local checkout of that project. Set the value to an empty string in case you want to disable the feature and always resolve the parent POM from the repositories.

Default value is: ../pom.xml.



#### 属性

用户可以在maven中定义一些属性，然后在其他地方用${xxx}进行引用。比如：

```
<project> 
    <modelVersion>4.0.0</modelVersion> 
    ... 
    <properties> 
        <var1>value1</var1> 
    </properties> 
</project>
```



maven提供了三个隐式的变量，用来访问系统环境变量、POM信息和maven的settings：

- env 
  暴露操作系统的环境变量，比如env.PATH

- project 
  暴露POM中的内容，用点号(.)的路径来引用POM元素的值，比如${project.artifactId}。另外，java的系统属性比如user.dir等，也暴露在这里。

- settings 
  暴露maven的settings的信息，也可以用点号(.)来引用。maven把系统配置文件存放在maven的安装目录中，把用户相关的配置文件存放在~/.m2/settings.xml中

  

  #### maven的变量

  1. **内置属性**(Maven预定义,用户可以直接使用)

     ${basedir}表示项目根目录,即包含pom.xml文件的目录;

     ${version}表示项目版本;

     ${project.basedir}同${basedir};

     ${project.baseUri}表示项目文件地址;

     ${maven.build.timestamp}表示项目构件开始时间;

     ${maven.build.timestamp.format}表示属性${maven.build.timestamp}的展示格式,默认值为yyyyMMdd-HHmm,可自定义其格式,其类型可参考java.text.SimpleDateFormat。用法如下：

     <properties><maven.build.timestamp.format>yyyy-MM-dd HH:mm:ss</maven.build.timestamp.format></properties>

     ```
     
     <properties>
     
     <maven.build.timestamp.format>yyyy-MM-dd HH:mm:ss</maven.build.timestamp.format>
     
     </properties>
     ```

  2. **POM属性**(使用pom属性可以引用到pom.xml文件对应元素的值)

     ${project.build.directory}表示主源码路径;

     ${project.build.sourceEncoding}表示主源码的编码格式;

     ${project.build.sourceDirectory}表示主源码路径;

     ${project.build.finalName}表示输出文件名称;

     ${project.version}表示项目版本,与${version}相同;

     

     3.**自定义属性**

     ```
     <project> 
         ... 
         <properties> 
             <my.filter.value>hello</my.filter.value> 
         </properties> 
         ... 
     </project> 
     ```

     

     则引用 ${my.filter.value } 就会得到值 hello

     

  

  #### maven的多项目管理

  多项目管理是maven的主要特色之一，对于一个大型工程，用maven来管理他们之间复杂的依赖关系，是再好不过了。maven的项目配置之间的关系有两种：继承关系和引用关系。 
  maven默认根据目录结构来设定pom的继承关系，即下级目录的pom默认继承上级目录的pom。要设定两者之间的关系很简单，上级pom如下设置：

```
<modules> 
    <module>ABCCommon</module> 
    <module>ABCCore</module> 
    <module>ABCTools</module> 
</modules>
```

要记住的是，这里的module是目录名，不是子工程的artifactId。子工程如下设置：

```
<parent> 
    <groupId>com.abc.product1</groupId> 
    <artifactId>abc-product1</artifactId> 
    <version>1.0.0-SNAPSHOT</version> 
</parent> 
<artifactId>abc-my-module2</artifactId> 
<packaging>jar</packaging>
```

引用关系是另外一种复用的方式，maven中配置引用关系也很简单，加入一个 `type` 为 `pom` 的依赖即可。

```
<dependency> 
    <groupId>org.sonatype.mavenbook</groupId> 
    <artifactId>persistence-deps</artifactId> 
    <version>1.0</version> 
    <type>pom</type> 
</dependency>
```

dependency为什么会有type为pom，默认的值是什么？ 
dependency中type默认为jar即引入一个特定的jar包。那么为什么还会有type为pom呢?当我们需要引入很多jar包的时候会导致pom.xml过大，我们可以想到的一种解决方案是定义一个父项目，但是父项目只有一个，也有可能导致父项目的pom.xml文件过大。这个时候我们引进来一个type为pom，意味着我们可以将所有的jar包打包成一个pom，然后我们依赖了pom，即可以下载下来所有依赖的jar包

但是无论是父项目还是引用项目，这些工程都必须用 `mvn install` 或者 `mvn deploy` 安装到本地库才行，否则会报告依赖没有找到，eclipse编译时候也会出错。

需要特别提出的是复用过程中，父项目的pom中可以定义 `dependencyManagement` 节点，其中存放依赖关系，但是这个依赖关系只是定义，不会真的产生效果，如果子项目想要使用这个依赖关系，可以在本身的 dependency 中添加一个简化的引用

```
<dependency> 
    <groupId>org.springframework</groupId> 
    <artifactId>spring</artifactId> 
</dependency>
```



#### maven的使用

我们已经知道maven预定义了许多的阶段（phase），每个插件都依附于这些阶段，并且在进入某个阶段的时候，调用运行这些相关插件的功能。我们先来看完整的maven生命周期：

| 生命周期                | 阶段描述                                                     |
| ----------------------- | ------------------------------------------------------------ |
| validate                | 验证项目是否正确，以及所有为了完整构建必要的信息是否可用     |
| generate-sources        | 生成所有需要包含在编译过程中的源代码                         |
| process-sources         | 处理源代码，比如过滤一些值                                   |
| generate-resources      | 生成所有需要包含在打包过程中的资源文件                       |
| process-resources       | 复制并处理资源文件至目标目录，准备打包                       |
| compile                 | 编译项目的源代码                                             |
| process-classes         | 后处理编译生成的文件，例如对Java类进行字节码增强（bytecode enhancement） |
| generate-test-sources   | 生成所有包含在测试编译过程中的测试源码                       |
| process-test-sources    | 处理测试源码，比如过滤一些值                                 |
| generate-test-resources | 生成测试需要的资源文件                                       |
| process-test-resources  | 复制并处理测试资源文件至测试目标目录                         |
| test-compile            | 编译测试源码至测试目标目录                                   |
| test                    | 使用合适的单元测试框架运行测试。这些测试应该不需要代码被打包或发布 |
| prepare-package         | 在真正的打包之前，执行一些准备打包必要的操作。这通常会产生一个包的展开的处理过的版本（将会在Maven 2.1+中实现） |
| package                 | 将编译好的代码打包成可分发的格式，如JAR，WAR，或者EAR        |
| pre-integration-test    | 执行一些在集成测试运行之前需要的动作。如建立集成测试需要的环境 |
| integration-test        | 如果有必要的话，处理包并发布至集成测试可以运行的环境         |
| post-integration-test   | 执行一些在集成测试运行之后需要的动作。如清理集成测试环境。   |
| verify                  | 执行所有检查，验证包是有效的，符合质量规范                   |
| install                 | 安装包至本地仓库，以备本地的其它项目作为依赖使用             |
| deploy                  | 复制最终的包至远程仓库，共享给其它开发人员和项目（通常和一次正式的发布相关） |

这里仅列举几个常用的插件及其配置参数：

1. clean插件
   只包含一个goal叫做 `clean:clean` ，负责清理构建时候创建的文件。 默认清理的位置是如下几个变量指定的路径 `project.build.directory, project.build.outputDirectory, project.build.testOutputDirectory, and project.reporting.outputDirectory` 。
2. compiler插件
   包含2个goal，分别是 `compiler:compile` 和 `compiler:testCompile` 。可以到这里查看两者的具体参数设置：[compile](http://maven.apache.org/plugins/maven-compiler-plugin/compile-mojo.html) , [testCompile](http://maven.apache.org/plugins/maven-compiler-plugin/testCompile-mojo.html) 。
3. surefire插件
   运行单元测试用例的插件，并且能够生成报表。包含一个goal为 `surefire:test` 。主要参数testSourceDirectory用来指定测试用例目录，参考[完整用法帮助](http://maven.apache.org/plugins/maven-surefire-plugin/test-mojo.html)
4. jar
   负责将工程输出打包到jar文件中。包含两个goal，分别是 `jar:jar` , `jar:test-jar` 。两个goal负责从classesDirectory或testClassesDirectory中获取所有资源，然后输出jar文件到outputDirectory中。
5. war 
   负责打包成war文件。常用goal有 `war:war` ，负责从warSourceDirectory（默认${basedir}/src/main/webapp）打包所有资源到outputDirectory中。
6. resources
   负责复制各种资源文件，常用goal有 `resources:resources` ，负责将资源文件复制到outputDirectory中，默认为${project.build.outputDirectory}。
7. install
   负责将项目输出(install:install)或者某个指定的文件(install:install-file)加入到本机库%USERPROFILE%/.m2/repository中。可以用 `install:help` 寻求帮助。
8. deploy
   负责将项目输出(deploy:deploy)或者某个指定的文件(deploy:deploy-file)加入到公司库中。
9. site
   将工程所有文档生成网站，生成的网站界面默认和apache的项目站点类似，但是其文档用doxia格式写的，目前不支持docbook，需要用其他插件配合才能支持。需要指出的是，在maven 2.x系列中和maven3.x的site命令处理是不同的，在旧版本中，用 mvn site 命令可以生成reporting节点中的所有报表，但是在maven3中，reporting过时了，要把这些内容作为 maven-site-plugin的configuration的内容才行。









#### 依赖关系

##### 1) 问：如何增加删除一个依赖关系？

答：直接在pom文件中加入一个dependency节点，如果要删除依赖，把对应的dependency节点删除即可。

##### 2) 问：如何屏蔽一个依赖关系？比如项目中使用的libA依赖某个库的1.0版，libB以来某个库的2.0版，现在想统一使用2.0版，如何去掉1.0版的依赖？

答：设置exclusion即可。

```


<dependency> 
    <groupId>org.hibernate</groupId> 
    <artifactId>hibernate</artifactId> 
    <version>3.2.5.ga</version> 
    <exclusions> 
        <exclusion> 
            <groupId>javax.transaction</groupId> 
            <artifactId>jta</artifactId> 
        </exclusion> 
    </exclusions> 
</dependency>
```

![复制代码](http://common.cnblogs.com/images/copycode.gif)



##### 3) 问：我有一些jar文件要依赖，但是我又不想把这些jar去install到mvn的repository中去，怎么做配置？

答：加入一个特殊的依赖关系，使用system类型，如下：

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
<dependency> 
    <groupId>com.abc</groupId> 
    <artifactId>my-tools</artifactId> 
    <version>2.5.0</version> 
    <type>jar</type> 
    <scope>system</scope> 
    <systemPath>${basedir}/lib/mylib1.jar</systemPath> 
</dependency>
```

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
但是要记住，发布的时候不会复制这个jar。需要手工配置，而且其他project依赖这个project的时候，会报告警告。如果没有特殊要求，建议直接注册发布到repository。
```

##### 4) 问：在eclipse环境中同时使用maven builder和eclipse builder，并且设置项目依赖关系之后，为什么编译会出现artifact找不到错误，但是直接使用命令行mvn构建则一切正常？

答：在project属性中去掉java build path中对其他 project 的依赖关系，直接在pom中设置依赖关系即可

```
<!-- 依赖的其他项目 --> 
<dependency> 
    <groupId>com.abc.project1</groupId> 
    <artifactId>abc-project1-common</artifactId> 
    <version>${project.version}</version> 
</dependency>
```

另外，保证没有其他错误。

##### 5) 问：我想让输出的jar包自动包含所有的依赖

答：使用 `assembly` 插件即可。

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
<plugin> 
    <artifactId>maven-assembly-plugin</artifactId> 
    <configuration> 
        <descriptorRefs> 
            <descriptorRef>jar-with-dependencies</descriptorRef> 
        </descriptorRefs> 
    </configuration> 
</plugin>


```

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
 
```

##### 6) 问：我的测试用例依赖于其他工程的测试用例，如何设置？

答：maven本身在发布的时候，可以发布单纯的jar，也可以同时发布xxx-tests.jar和xxx-javadoc.jar（大家经常在repository中可以看到类似的东西）。我们自己的项目A要同时输出test.jar可以做如下的设置

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
<!-- 用于把test代码也做成一个jar --> 
<plugin> 
    <groupId>org.apache.maven.plugins</groupId> 
    <artifactId>maven-jar-plugin</artifactId> 
    <executions> 
        <execution> 
            <goals> 
                <goal>test-jar</goal> 
            </goals> 
        </execution> 
    </executions> 
</plugin>
```

![复制代码](http://common.cnblogs.com/images/copycode.gif)

然后在其他需要引用的工程B中做如下的dependency设置

 

![复制代码](http://common.cnblogs.com/images/copycode.gif)

```
<dependency> 
    <groupId>com.abc.XXX</groupId> 
    <artifactId>工程A</artifactId> 
    <version>${project.version}</version> 
    <type>test-jar</type> 
    <scope>test</scope> 
</dependency>
```

![复制代码](http://common.cnblogs.com/images/copycode.gif)



##### 7)如何让maven将工程依赖的jar复制到WEB-INF/lib目录下？

 

##### 

##### 8)我刚刚更新了一下我的nexus库，但是我无法在eclipse中用m2eclipse找到我新增的库文件

修改pom.xml文件，将旧版jar的依赖内容中的版本直接修改为新版本即可。

 

##### 9）我要的jar最新版不在maven的中央库中，我怎么办？

将依赖的文件安装到本地库，用如下命令可以完成：

```
mvn install:install-file
  -Dfile=<path-to-file>
  -DgroupId=<group-id>
  -DartifactId=<artifact-id>
  -Dversion=<version>
  -Dpackaging=<packaging>
  -DgeneratePom=true

Where: <path-to-file>  the path to the file to load
       <group-id>      the group that the file should be registered under
       <artifact-id>   the artifact name for the file
       <version>       the version of the file
       <packaging>     the packaging of the file e.g. jar     
```

##### 

#### 变量

##### 1) 问：如何使用变量替换？项目中的某个配置文件比如jdbc.properties使用了一些pom中的变量，如何在发布中使用包含真实内容的最终结果文件？

答：使用资源过滤功能，比如：

![复制代码](http://common.cnblogs.com/images/copycode.gif)

<project> 
    ... 
    <properties> 
        <jdbc.driverClassName>com.mysql.jdbc.Driver</jdbc.driverClassName> 
        <jdbc.url>jdbc:mysql://localhost:3306/development_db</jdbc.url> 
        <jdbc.username>dev_user</jdbc.username> 
        <jdbc.password>s3cr3tw0rd</jdbc.password> 
    </properties> 
    ... 
    <build> 
        <resources> 
            <resource> 
                <directory>src/main/resources</directory> 
                <filtering>true</filtering> 
            </resource> 
        </resources> 
    </build> 
    ... 
    <profiles> 
        <profile> 
            <id>production</id> 
            <properties> 
                <jdbc.driverClassName>oracle.jdbc.driver.OracleDriver</jdbc.driverClassName> 
                <jdbc.url>jdbc:oracle:thin:@proddb01:1521:PROD</jdbc.url> 
                <jdbc.username>prod_user</jdbc.username> 
                <jdbc.password>s00p3rs3cr3t</jdbc.password> 
            </properties> 
        </profile> 
    </profiles> 
</project>

![复制代码](http://common.cnblogs.com/images/copycode.gif)

##### 2) 问： `maven-svn-revision-number-plugin` 插件说明

答： `maven-svn-revision-number-plugin` 可以从 SVN 中获取版本号，并将其变成环境变量，交由其他插件或者profile使用，详细帮助在[这里](http://maven-svn-revision-number-plugin.googlecode.com/svn/site/usage.html) 。一般和resource的filter机制同时使用

![复制代码](http://common.cnblogs.com/images/copycode.gif)

<plugins> 
    <plugin> 
        <groupId>com.google.code.maven-svn-revision-number-plugin</groupId> 
        <artifactId>maven-svn-revision-number-plugin</artifactId> 
        <version>1.3</version> 
        <executions> 
            <execution> 
                <goals> 
                    <goal>revision</goal> 
                </goals> 
            </execution> 
        </executions> 
        <configuration> 
            <entries> 
                <entry> 
                    <prefix>prefix</prefix> 
                </entry> 
            </entries> 
        </configuration> 
    </plugin> 
</plugins>

![复制代码](http://common.cnblogs.com/images/copycode.gif)

这段代码负责把resource文件中的内容替换成适当内容

![复制代码](http://common.cnblogs.com/images/copycode.gif)

repository = ${prefix.repository} 
path = ${prefix.path} 
revision = ${prefix.revision} 
mixedRevisions = ${prefix.mixedRevisions} 
committedRevision = ${prefix.committedRevision} 
status = ${prefix.status} 
specialStatus = ${prefix.specialStatus}

![复制代码](http://common.cnblogs.com/images/copycode.gif)

##### 3）我的程序有些单元测试有错误，如何忽略测试步骤？

有好几种方法都可以实现跳过单元测试步骤，一种是给mvn增加命令行参数 `-Dmaven.test.skip=true` 或者 `-DskipTests=true` ；另外一种是给surefire插件增加参数，如下：

```csharp
<span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">project</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



  [...]



  <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">build</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



    <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">plugins</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



      <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">plugin</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



        <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">groupId</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>org.apache.maven.plugins<span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">groupId</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



        <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">artifactId</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>maven-surefire-plugin<span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">artifactId</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



        <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">version</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>2.8<span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">version</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



        <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">configuration</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



          <span class="kwrd" style="color: rgb(0, 0, 255);"><</span><span class="html" style="color: rgb(128, 0, 0);">skipTests</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>true<span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">skipTests</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



        <span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">configuration</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



      <span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">plugin</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



    <span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">plugins</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



  <span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">build</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>



  [...]



<span class="kwrd" style="color: rgb(0, 0, 255);"></</span><span class="html" style="color: rgb(128, 0, 0);">project</span><span class="kwrd" style="color: rgb(0, 0, 255);">></span>
```

##### 4) 如果只想运行单个测试用例，能否实现？

可以，运行时候增加命令行参数 `-Dtest=MyTest` 即可，其中MyTest是所需要运行的单元测试用例名称，但是不需要包含package部分。

#### 

####  编译

##### 1) 问：如何给插件指派参数？比如我要设置一些编译参数

答：以下内容设定编译器编译java1.5的代码

![复制代码](http://common.cnblogs.com/images/copycode.gif)

<project> 
    ... 
    <build> 
        ... 
        <plugins> 
            <plugin> 
                <artifactId>maven-compiler-plugin</artifactId> 
                <configuration> 
                    <source>1.5</source> 
                    <target>1.5</target> 
                </configuration> 
            </plugin> 
        </plugins> 
        ... 
    </build> 
    ... 
</project>

![复制代码](http://common.cnblogs.com/images/copycode.gif)

要设置其他插件的参数也可以，请参考对应插件的帮助信息

##### 2) 问：我的目录是非标准的目录结构，如何设置让maven支持？

答：指定source目录和test-source目录即可。

![复制代码](http://common.cnblogs.com/images/copycode.gif)

<build> 
    <directory>target</directory> 
    <sourceDirectory>src</sourceDirectory> 
    <scriptSourceDirectory>js/scripts</scriptSourceDirectory> 
    <testSourceDirectory>test</testSourceDirectory> 
    <outputDirectory>bin</outputDirectory> 
    <testOutputDirectory>bin</testOutputDirectory> 
</build>

![复制代码](http://common.cnblogs.com/images/copycode.gif)

这个例子把源代码设置成了src目录，测试代码在test目录，所以输出到bin目录。这里要注意，directory如果也设置成bin目录的话，maven打包的时候会引起死循环，因为directory是所有工作存放的地方，默认包含outputDirectory定义的目录在内。

##### 3) 我源代码是UTF8格式的，我如何在maven中指定？

设置一个变量即可

![复制代码](http://common.cnblogs.com/images/copycode.gif)

<project> 
    ... 
    <properties> 
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding> 
    </properties> 
    ... 
</project>

![复制代码](http://common.cnblogs.com/images/copycode.gif)

{color:blue}以上是官方给出的解决方案，但是经过尝试这样只能影响到resource处理时候的编码{color}，真正有用的是如下配置：

```
{code:xml}
<build>
  ...
    <plugin>
      <artifactId>maven-compiler-plugin</artifactId>
      <configuration>
        <encoding>UTF-8</encoding>
      </configuration>
    </plugin>
  ...
</build>
{code}
```

##### . 问：我的项目除了main/java目录之外，还加了其他的c++目录，想要一并编译，如何做？

答：使用native插件，具体配置方法参考[http://mojo.codehaus.org/maven-native/native-maven-plugin/]

```
{code:xml}
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>native-maven-plugin</artifactId>
    <extensions>true</extensions>
    <configuration>
</plugin>    
{code}
```

##### . 问：我想要把工程的所有依赖的jar都一起打包，怎么办？

答：首先修改maven的配置文件，给maven-assembly-plugin增加一个jar-with-dependencies的描述。

```
{code:xml}
<project>
  [...]
  <build>
    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <configuration>
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
        </configuration>
      </plugin>
    </plugins>
  </build>
  [...]
</project>
{code}
```

然后使用命令打包即可：

```
mvn assembly:assembly
```

##### . 问：我想把main/scripts中的内容一起打包发布，如何做？

答：在pom中配置额外的资源目录。如果需要的话，还可以指定资源目录的输出位置

```
{code:xml}
<build>
  ...
  <resources>
    <resource>
      <filtering>true</filtering>
      <directory>src/main/command</directory>
      <includes>
        <include>run.bat</include>
        <include>run.sh</include>
      </includes>
      <targetPath>/abc</targetPath>
    </resource>
    <resource>
      <directory>src/main/scripts</directory>
    </resource>
  </resources>
  ...
</build>
{code}
```

##### . 问：我有多个源代码目录，但是maven只支持一个main src和一个test src，怎么办？

答：使用另外一个插件，并仿照如下配置pom

```
{code:xml}
<plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>build-helper-maven-plugin</artifactId>
        <version>1.1</version>
        <executions>
          <execution>
            <id>add-source</id>
            <phase>generate-sources</phase>
            <goals>
              <goal>add-source</goal>
            </goals>
            <configuration>
              <sources>
                <source>src/config/java</source>
                <source>src/main/java</source>
                <source>src/member/java</source>
              </sources>
            </configuration>
          </execution>
        </executions>
      </plugin>
{code}
```