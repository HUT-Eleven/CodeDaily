---
typora-copy-images-to: ../pictures/
typora-root-url: ../pictures/
---

### 简介

1. Apache开源项目；

2. 纯Java开发

### 作用

1. 依赖管理

2. 项目构建
### 仓库分类

- 本地仓库
- 私服
- 中央仓库
### 目录结构

![1568126463687](/1568126463687.png)

### 生命周期

> Maven的生命周期是对所有的构建过程进行抽象和统一。Maven的生命周期是抽象的，只是定义了一系列的阶段，实际的工作还是由**插件**来完成的。
##### clean生命周期
1）pre-clean 执行一些清理前需要完成的工作。
2）clean 清理上一次构建生成的文件。
3）post-clean 执行一些清理后需要完成的工作。

##### default生命周期
> Maven核心功能之”构建“的所有需要执行的步骤

6) process-resources 处理项目主资源文件。对src/main/resources目录的内容进行变量替换等工作后，复制到项目输出的主classpath目录中。

7） **compile** 编译项目的主源代码

10) process-test-sources 处理项目测试资源文件

13）test-compile 编译项目的测试代码

15) **test** 使用单元测试框架运行测试，测试代码不会被打包或部署

17）**package** 打包

22) **install** 将package阶段打好的包**布署到本地maven仓库**，供本地其他Maven项目使用

23）**deploy** 布署到远程maven私服

##### site生命周期
> 建立和发布项目站点

### 命令
**命令执行逻辑**：首先会得到该阶段所属生命周期，**从该生命周期中的第一个阶段开始按顺序执行**，直至该阶段本身。
比如：mvn clean = mvn pre-clean clean
mvn package = mvn process-resources compile process-test-source test-compile test package

**不同声明周期的命令可同时执行**。比如：mvn clean package

### 依赖范围

|                  | Compile | Provided | Runtime | Test |
| :--------------: | :-----: | :------: | :-------------: | ------------ |
| **本地测试** | **Ｙ** | **Ｙ** | **Ｙ** | **Ｙ** |
| **编译** | **Ｙ** | **Ｙ** |  |  |
| **打包** | **Ｙ**  |          | **Ｙ**          |              |
|  | 默认范围 | jsp-api.jar   servlet-api.jar | JDBC驱动包 | junit |

**注：**这里的测试是指程序猿本地运行测试，不是测试人员测试。只要记住Provided即可，其他无需记忆。像Runtime，直接写Compile也行。

### 依赖传递

引入一个Jar包可能会引入其他Jar，这就是依赖传递。
依赖传递或者导入版本不同的jar包时会出现“**版本冲突**”的问题，解决办法：

- 父工程版本锁定

  版本锁定只是起到指定依赖版本的作用，并不会导入依赖.

```xml
<properties>
　　<spring.version>4.2.4.RELEASE</spring.version>
</properties>
.........
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-bean</artifactId>
            <version>${spring.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

- 依赖的优先原则（次要）

- 排除依赖（不常见，百度即可）

  

  ##### 依赖范围对依赖传递造成的影响

  ![1568130970002](/1568130970002.png)



### pom.xml

![1568128928094](/1568128928094.png)

TODO: 待续