# 基本概念

> jQuery 全称 javaScript Query, 是js的一个**“框架”**。本质上仍然是js。
>

## jQuery的版本

> 官网下载地址：[http://jquery.com/download/](http://jquery.com/download/)
> jQuery版本有很多，分为1.x 2.x 3.x

```
1.x版本：能够兼容IE678浏览器
2.x版本：不兼容IE678浏览器
1.x和2.x版本jquery都不再更新版本了，现在只更新3.x版本。
3.x版本：不兼容IE678，更加的精简（在国内不流行，因为国内使用jQuery的主要目的就是兼容IE678）
我们主要使用1.x的版本
```

## jQuery的入口函数

#### 使用jQuery的三个步骤：

```javascript
1. 引入jQuery文件
2. 入口函数
3. 功能实现
```

#### 关于jQuery的入口函数的写法

```javascript
//第一种写法（认识）
$(document).ready(function() {
	
});
//第二种写法
$(function() {
	
});
```

#### jQuery入口函数与js入口函数的对比

```javascript
1.	JavaScript的入口函数要等到页面中所有资源（包括图片、文件）加载完成才开始执行。
2.	jQuery的入口函数只会等待文档树加载完成就开始执行，并不会等待图片、文件的加载。
```

# jQuery对象与JS对象（DOM对象）的区别（重点）

> 1. DOM对象：使用JavaScript中的方法获取页面中的元素返回的对象就是dom对象。
> 2. jQuery对象：jquery对象就是使用jquery的方法获取页面中的元素返回的对象就是jQuery对象。
> 3. jQuery对象其实就是DOM对象的包装集（包装了DOM对象的集合**（伪数组）**）
> 4. DOM对象与jQuery对象的方法不能混用。

DOM对象转换成jQuery对象：【联想记忆：花钱】

```javascript
var $obj = $(domObj);
// $(document).ready(function(){});就是典型的DOM对象转jQuery对象

```

jQuery对象转换成DOM对象【取角标】：

```javascript
var $li = $(“li”);
//第一种方法（推荐使用）
$li[0]
//第二种方法
$li.get(0)
```



# jQuery的封装原理

闭包原理:在全局区中不能够获取函数体内的数据。使用更大作用域的变量来记录小作用域变量的值。
使用闭包,将数据一次性挂载到window对象下。



### 选择器

**查API**

```
$(“#elementID”):id选择器
$(“.className”)：类...
$(“input”):标签...
$(“*”):全选...
$("seletor1,seletor2,…"):并集...
$(“div span”)：后代...选取<div>里的所有的<span>元素
$(“div>span”)：子...选取<div>元素下元素名是<span>的子元素
$(“.one+div”):相邻元素选择器,选取class为one的下一个<div>兄弟元素

过滤选择器：
:first 选取第一个元素： $('li:first')：（单引双引无所谓）
:last 选取最后一个元素： $('li:last')
:not(selector) 去除所有与给定选择器匹配的元素。$("input:not(:checked)")；查找所有未选中的 input 元素
:hidden 选取所有不可见元素，或者type为hidden的元素。$("div:hidden")
:visible :visible 	选取所有的可见元素 ：	$("input:visible")
```

### 筛选

```
有时候需要用到筛选，筛选的功能和选择器的功能并不重复，作用是可以对选择器的结果做进一步的筛选。
siblings([expr]) 、children([expr]) 、parent([expr]) 
```



### jQuery操作元素属性

```
attr("属性名"):获取； 	（此种方式不能获取value属性的数据，需使用val()进行获取。）
attr("属性名","属性值")：修改;
```

### jQuery操作元素内容

```
html():包括HTML标签。
html("新的内容")：新的内容会将原有内容覆盖，HTML标签会被解析
text():
text("新的内容")：也会覆盖
```

### jQuery操作元素样式

```
1、css()
        对象名.css("width")//返回当前属性的样式值（应该和attr("width")一样）
        对象名.css("width","100px")//增加、修改元素的样式
        对象名.css({"width":"100px","height":"20px"……})
2、addClass("类选则器名")：追加
3、removeClass("类选择器名")：删除
4、toggleClass("类选择器名")：如果存在（不存在）就删除（添加）
```

### jQuery操作文档结构

```
1、内部插入（加子节点）
    A.append(B)：在A的“末尾处”插入子节点B。B（插入的元素内容）可以是：jQuery对象、DOM 元素（数组）、字符串、HTML标签	。并且可以拿到其他的元素插入，但这是移动，不是复制。
    appendTo()：与append()的区别就是把AB的位置调换。但不能加字符串，也不建议使用这种方式加字符串。不过需要注意的而是这些方法都是jQuery对象的方法，所以这种方式加时，都需要转为jQuery对象。
    prepend()：前
    prependTo()	

2、外部插入（加兄弟节点）：和内部插入完全一样，只是插入的位置不一样。
    after					
    before					
    insertAfter	：和after的区别，就是appendTo和append的区别。			
    insertBefore  		
3、包裹
4、替换
5、删除：empty()
6、复制 
```

### jQuery操作事件

**API**

```
hover(over,out)：当鼠标移动到一个匹配的元素上面时，会触发指定的第一个函数。当鼠标移出这个元素时，会触发指定的第二个函数。
```

### jQuery操作动画

```
该“动画”也可以理解为“效果”
show()：显示隐藏的匹配元素。（比如那些block：none）；
	show( options ) ：可以加时间：show（3000）
hide()：隐藏匹配的元素
slideDown():$("p").slideDown("slow"); 用600毫秒缓慢的将段落滑下(可以指定时间)
slideUp()：
slideToggle()：滑下或上升，可以做列表的隐藏和显示。
fadeIn()：淡入
fadeOut():淡出
```



















