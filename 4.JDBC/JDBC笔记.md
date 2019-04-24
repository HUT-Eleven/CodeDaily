##JDBC

> JAVA Database Connectivity java 数据库连接

* 为什么会出现JDBC

> SUN公司提供的一种数据库访问规则、规范, 由于数据库种类较多，并且java语言使用比较广泛，sun公司就提供了一种规范，让其他的数据库提供商去实现底层的访问规则。 我们的java程序只要使用sun公司提供的jdbc驱动即可。


##使用JDBC的基本步骤

1. 注册驱动(三种)

    1.1：Driver：直接加载驱动，然后使用connect（..）获取连接。

    ```
    Driver d = new oracle.jdbc.OracleDriver();
    d.connect(url, Properties)
    ```

    1.2：DriverManager：驱动管理类，这个类里面有静态代码块，一上来就执行了，所以等同于我们注册了两次驱动。

    ```
    DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
    ```

    1.3：Class.forName("oracle.jdbc.OracleDriver") --（Oracle8i JDBC驱动程序，需要导入oracle.jdbc.driver.OracleDriver类,MySql也有新旧两种方式)）

    ```
    Class.forName("oracle.jdbc.OracleDriver")
    ```

    ​

2. 建立连接

     连接方式因注册的方式不同而有所不同，但大同小异。三要素：url/username/password
     URL：（oracle:Jdbc协议+数据库协议+thin+@ip+端口号 + 数据库名）。	

     ```
     Connection conn = DriverManager.getConnection(url, username, password);
     ```

     ​

3. 得到"运输船"对象，将sql语句运输到数据库

4. 数据库执行sql语句，”运输船“得到结果，返回程序中。

5. 释放资源


##JDBC 工具类构建(Properties+静态代码块)

1. 在src底下声明一个文件 xxx.properties ，里面的内容吐下：

    driverClass=oracle.jdbc.OracleDriver
    url=jbdc:oracle:thin:@10.1.7.156:1521:orcl
    username=scott
    password=tiger

2. 在工具类里面，使用静态代码块

    （静态代码块重要做这两件事：读取属性、注册驱动）

    ```java
    static String driverClass = null;
    static String url = null;
    static String username = null;
    static String password= null;
    static{
    	try {
    		//1. 创建一个属性配置对象
    		Properties properties = new Properties();
    		InputStream is = new FileInputStream("jdbc.properties"); //对应文件位于工程根目录
    		 
    		//使用类加载器，去读取src底下的资源文件。 后面在servlet  //对应文件位于src目录底下
    		//InputStream is = JDBCUtil.class.getClassLoader().getResourceAsStream("jdbc.properties");
    		//JDBCUtil.class.getResourceAsStream("/jdbc.properties");
    		//导入输入流。
    		properties.load(is);
    		
    		//读取属性
    		driverClass = properties.getProperty("driverClass");
    		url = properties.getProperty("url");
    		name = properties.getProperty("name");
    		password = properties.getProperty("password");
    		//并且注册驱动也应该放在静态代码块中
    		Class.forName(driverClass);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    ```

```
区别：
executeUpdate（String sql）：执行DDL和DML语句：create、alter、drop、insert、									delete、update, 返回一个int代表影响的行数
executeQuery(String sql)：执行DQL语句：select，返回一个结果集代表查询到的内容
```

​

## Statement和PreparedStatement的区别

#####          一、语法结构不同

​		1）Statment执行静态sql语句，且sql可以拼接。
		2）PreparedStatement可以先执行预编译的sql语句，在预编译sql语句中使用？进行参数占位，后面在进行参数赋值

```
使用PreparedStatement时，后面进来的变量值，将会被看成是字符串，不会视为关键字，并且也不用再加单引号。
```

#####          二、原理不同

​		1）Statement不能进行sql缓存
	      	2）而PreparedStatement可以进行sql缓存，执行效率会比Statement快！！！

#####          三、安全性不同

​		1）Statement存在sql注入的风险
		2）而PreparedStatement可以有效防止用户注入。

	SELECT * FROM t_user WHERE username='admin' AND PASSWORD='100234khsdf88' or '1=1' 
	前面先拼接sql语句， 如果变量里面带有了 数据库的关键字，那么会认为是关键字。 不认为是普通的字符串。 
## JDBC执行存储过程注意点：

##### CallableStatement对象

1. sql语句格式：{ CALL  过程名() }
2. 设置输出参数的方法：registerOutParameter(）
3. 输出类型：OracleTypes.类型或者java.sql.Types.类型
4. 执行时”建议“使用：execute()方法
5. 取出“输出参数”时”建议“使用：getObject()然后强转

## 批处理

 1.Statement批处理：

​             void addBatch(String sql)  添加sql到缓存区（暂时不发送）

​             int[] executeBatch() 执行批处理命令。 发送所有缓存区的sql

​             void clearBatch()  清空sql缓存区

 

2.PreparedStatement批处理：                  

​             void addBatch() 添加参数到缓存区

​             int[] executeBatch() 执行批处理命令。 发送所有缓存区的sql

​             void clearBatch()  清空sql缓存区

##### 区别：

​	一个是添加sql语句，另一个是添加参数。

##### 结论：

​        *1) mysql数据库不支持PreparedStatement优化，而且不支持批处理优化

​	\* 2) oracle数据库即支持PreparedStatement优化，也支持批处理优化   

## 获取自增长值

1.1 使用有两个参数的prepareStatement（sql语句, 字段）方法，指定可以返回自动增长的键值

​        Statement.RETURN_GENERATED_KEYS: 可以返回自动增长值

​	Statement.NO_GENERATED_KEYS: 不能返回自动增长值

## JDBC事务

主要是Connection在事务上的操作：	

​	setAutoCommit(false)  开启事务

​	commit();  成功执行，最后提交事务

​	rollback();  一旦遇到错误，回滚事务

## Tip:

	2.JDBC两个主要的类：Connection和Statement
		连接、提交、事务这方面的问题应该要想到Connection；
		执行、获取这些操作应该要想到Statement和其子类。
	3.JDBC还有：操作大容量数据类型、使用类路径读取配置文件、MySql在JDBC上的不同 这三个内容没学。
	4.!!!PreparedStatement设置参数时，不能把表名、列名作为参数设定，可以改成原始的方式：
	String sql = "UPDATE  book SET "+field+" = ? WHERE bookid=?";
	其中field代表表名或者列名，以“拼接”的方式注入，就是之前statement的静态注入方式，这种方式存在安全问题。
