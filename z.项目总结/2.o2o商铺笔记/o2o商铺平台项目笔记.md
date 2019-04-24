##### 1.	修改maven默认的jdk版本

默认的jdk版本是1.5.可以通过几种方式修改jdk的版本。其中一种：
去mvnrepository.com中搜索**“apache maven compiler plugin"**

##### 2.	更改动态web项目的version

![2019-02-15_223531](C:\Users\Administrator.USER-20190112YQ\Desktop\新建文件夹\images\2019-02-15_223531.png)



由于eclipse中有bug，不能直接在上方位置直接修改。需要进入项目中的.setting文件夹修改org.eclipse.wst.common.project.facet.core.xml文件

![](C:\Users\Administrator.USER-20190112YQ\Desktop\新建文件夹\images\2019-02-15_224051.png)



##### 3.	maven自带的tomcat只有6和7的版本

如果需要配置8.x以上的版本需要修改maven的配置文件等。。

##### 4.	logback ：对log4j的升级

##### 5.	kaptcha ： 做验证码

##### 6.	静态资源目录

> 主要是参考其对静态资源的目录划分

```
webapp
	-resources
		-js//放自己写的js
			-common//通用的js工具类
			-xxx模块
		-css//放自己写的css
		-img//放图片
		-lib//放引进的js、css等等
			-bootstrap//统一小写
			-jquery
	-WEN-INF
		-html
			-xx模块
		-jsp//一般情况项目中要么只用jsp要么就只用html
```

