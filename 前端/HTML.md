# 概述

​	HTML: Hyper Text Markup Language 超文本标签语言。

```
HTML用来做网页的框架，关于样式的内容让css来做。html只要做到语义良好即可，尽量不在标签内写样式。
```



## 基本骨架

```html
<HTML>   
    <head> 
        <title></title>
    </head>
    <body>
    </body>
</HTML>
```

```html
文档类型：<!DOCTYPE html>  // html 5 的版本
```

```
字符： <meta charset="UTF-8" />
```

# 标签的语义化

核心：合适的地方给一个最为合理的标签。

语义是否良好： 当我们去掉CSS之后，网页结构依然组织有序，并且有良好的可读性。

比如<h1><p>等这些标签就是有语义的。

# HTML常用标签

## 排版标签

### 标题标签-h

### 段落标签-p

### 水平线标签-hr

### 换行标签-br

### div span标签(重点)

div  span    是**没有语义**的     是我们网页布局主要的2个**盒子** 

div 就是  division  的缩写   分割， 分区的意思  其实有很多div 来组合网页。**块级标签**

span, 跨度，跨距；范围    **行级标签**

## 文本格式化标签

b、strong：加粗

i、em：斜体

s、del：删除线

u、ins：下划线

## 图像标签img 

width和height调整一个就可以了，另外一个会等比例缩放。

## 链接标签

```html
<a href="跳转目标" target="目标窗口的弹出方式">文本或图像</a>
```

1.外部链接 需要添加 http:// www.baidu.com

2.内部链接 直接链接内部页面名称即可 比如 < a href="index.html"> 首页 </a >

3.href="#"表示该链接暂时为一个空链接。

4.target：_self为默认值，\_blank为在新窗口中打开方式。

### 锚点定位

创建锚点链接分为两步：

```html
1.使用“a href=”#id名>“链接文本"</a>创建链接文本（被点击的）
  <a href="#two">   

2.使用相应的id名标注跳转目标的位置。
  <h3 id="two">第2集</h3> 
```

### base 标签

1.base 写到  <head>  </head>  之间,单标签;
2.base 可以设置整个页面的链接的打开状态

​	比如：<base target="_blank"/>

3.JSP中<base href="<%=basePath%>">的作用:作为基准 URL 的绝对 URL.

```html
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 
%>  
<base href="<%=basePath%>">
则访问任何XXX.html,等价于：http://localhost:8080/项目名称/XXX.html。
```




# 路径问题

		./代表的是当前路径
		../ 代表的上一级路径
		../../	上上一级路径

# 列表标签

> 当不确定应该使用哪种列表标签时，参考其他的网站。其他标签同理。

## 无序列表 ul （重点）

无序列表 ul（unorderly list）

```
<ul>
  <li>列表项1</li>
  <li>列表项2</li>
  <li>列表项3</li>
  ......
</ul>
 1. <ul></ul>中只嵌套<li></li>，不建议嵌套其他标签；
 2. <li>与</li>之间相当于一个容器，可以容纳其他多个元素。
```

## 有序列表 ol （了解）

有序列表 ol（orderly list）

```html
<ol>
  <li>列表项1</li>
  <li>列表项2</li>
  <li>列表项3</li>
  ......
</ol>
```

## 自定义列表（理解）

```
<dl>
  <dt>名词1</dt>
  <dd>名词1解释1</dd>
  <dd>名词1解释2</dd>
  ...
  <dt>名词2</dt>
  <dd>名词2解释1</dd>
  <dd>名词2解释2</dd>
  ...
</dl>
```



# 表格

```html
<table>
  <tr>
    <td>单元格内的文字</td>
    ...
  </tr>
  ...
</table>
```

注意：

```
1. <tr></tr>中只能嵌套<td></td>
2. <td></td>标签，他就像一个容器，可以容纳所有的元素
```

表格的合并：

```
colspan合并列，rowspan合并行
合并的顺序： 从上   从左 
先列出所有的方块，之后合并了哪一块，就删去哪一块。
```



# 表单

作用：用于收集用户不同类型数值的输入（表单本身并不可见）

在HTML中，一个完整的表单通常由表单控件（也称为表单元素）、提示信息和表单域3个部分构成。

## 表单域

```
<form action="url地址" method="提交方式" name="表单名称">
  各种表单控件
</form>
```

## 表单控件

### 1.  input控件

​	1.1 type属性（对应不同的输入类型），输入类型如下：

```
text : 文本（单行，默认宽度是 20 个字符）
password :  密码框
radio :	单选按钮（需要指定name）
checkbox :  复选框(radio、checkbox作为一个组的，都应该取同样的name)
file 	 : 上传文件
submit   : 提交按钮
button 	 : 普通按钮
reset	 : 颜色的输入字段
hidden  : 隐藏域
name ：要正确地被提交，每个输入字段必须设置一个 name 属性。
----------------以下为HTML5 输入类型：
color :颜色的输入
number  : 只允许输入数字
email ： 
range ： 滑动条
search : 搜索
tel    : 手机号 (Safari)
url ： URL 地址
(date, month, week, time, datetime, datetime-local) ： 日期 （其中datetime特殊）
image : 表单中的image具有自动提交表单的功能  栗子：<input type="image" src="图片的路径"/>
```

​		输入类型的属性和限制如下：

```
disabled	规定输入字段是禁用的。不可用和不可点击，不会被提交。
pattern	规定通过其检查输入值的正则表达式。
readonly	规定输入字段为只读（无法修改）。
required	规定输入字段是必需的（必需填写）。
size	规定输入字段的宽度（以字符计）。
step	规定输入字段的合法数字间隔。
value	规定输入字段的默认值。
placeholder : 指定默认的提示信息
id : 给输入项取一个名字, 以便于后期我们去找到它,并且操作它
checked ： 默认选择（用在radio、checkbox中）
```

### 2.select控件

```
<select name="cars">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
    <option value="fiat" selected >Fiat</option>
</select>
注意：
	在option 中定义selected =" selected "时，当前项即为默认选中项。
```

### 3.textarea控件

```
<textarea cols="每行中的字符数" rows="显示的行数">
  文本内容
</textarea>
```

### 4.button控件

```
定义可点击的按钮
栗子：<button type="button" onclick="alert('Hello World!')">Click Me!</button>
```

注释：HTML5中的表单元素：<datalist>、<keygen>、<output>