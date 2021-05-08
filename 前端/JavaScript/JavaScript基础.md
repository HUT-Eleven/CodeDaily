# JavaScript介绍

## JavaScript是什么

> 是一门脚本语言：不需要编译，直接运行。
> 是一门弱类型语言：主要体现在声明变量上都使用var
> 是一门基于对象的语言：没有类的概念，用对象的方式来模拟类的概念。
> 是一门动态类型语言：JS有预解析，但是只有执行到那个位置了才能知道具体是什么类型。

# JavaScript的组成

![1496912475691](media/1496912475691.png)

## ECMAScript

> JavaScript的核心，描述了语言的基本语法和数据类型，ECMAScript是一套标准，定义了一种语言的标准与具体实现无关。
>

## BOM - 浏览器对象模型

> 一套操作浏览器功能的API
>
> 通过BOM可以操作浏览器窗口，比如：弹出框、控制浏览器跳转、获取分辨率等
>

## DOM - 文档对象模型

> 一套操作页面元素的API
>
> DOM可以把HTML看做是文档树，通过DOM提供的API可以对树上的节点进行操作
>

# JavaScript的书写位置 

- #### 写在行内	

  ```html
  <input type="button" onclick="alert('Hello World')" />
  ```

- #### 写在外部js文件

```javascript
<script src="xxx.js">这里写什么代码都无效</script>
//注意：外部文件不能包含 <script> 标签了，只剩脚本内容。
```

- #### 写在内部script标签

```javascript
<script type="text/javascript" language="JavaScript">
	alert('Hello World!');
</script>
//html5中，type和language都可以省略。
```

#### **注意问题**

- 可以在文档中**任何位置**放置**任何数量**的javascript脚本,但写在前面会导致未加载。所以**放在body后是最好**的。

- **一对script**的标签中出错，会导致该script标签中的之后的js代码不执行，但是其他的script标签的代码还是会执行。


# 变量

```
2) 在js中可以重复定义变量。但最好不要这么做。
3) js是弱类型语言，使用var来定义任何数据类型，也用var定义对象。
4）js中变量的类型是由变量的值决定的，所以只定义不赋值的变量，就是一个未赋值变量（undefined），未赋值的变量不能使用
```



# 数据类型

```html
a）number：undefined+数字-->NaN  (not a number)
	数值判断：isNaN(10) is not a number  不是数字时才是true
b) string:  单引，双引都可以。
	用+号时即字符串拼接，和java一样。
	但是-*/上一个数字时：“10”-5  输出15.（浏览器自动转换成数字）
c) boolean
	boolean的隐式转换：
		转换为true：   非空字符串  非0数字  true 任何对象
		转换成false ： 空字符串  0   null  undefined
d) object： 对象类型
e) null：变量的值如果想为null，必须手动设置。
	typeof（null） 输出object
f) undefined：变量只声明的时候值默认是undefined。
```

### 获取变量的类型—typeof

```
返回值有六种可能： "number," "string," "boolean," "object," "function," 和 "undefined."
typeof(XXX) 或 typeof XXX 都可以。
```

### 数据类型转换

> 谷歌浏览器快速的查看数据类型：在控制台中，字符串的颜色是黑色的，数值类型是蓝色的，布尔类型也是蓝色的，undefined和null是灰色的。
>

#### 转换成字符串类型

- toString()

  ```javascript
  var num = 5;
  console.log(num.toString());
  ```

- String()

  ```javascript
  //String()函数存在的意义：有些值没有toString()的方法，这个时候可以使用String()。比如：undefined和null
  
  var i;// underfined
  console.log(String(i));//输出underfined
  console.log(i.toString());//报错
  ```

- XXX  +  ""   加一个空字符串的方式


#### 转换成数值类型

- Number()

  ```javascript
  //Number()可以把任意值转换成数值，如果要转换的字符串中有一个不是数值的字符，返回NaN
  ```

- parseInt()

  ```javascript
  var num1 = parseInt("12.3abc");  // 返回12，如果第一个字符是数字会解析直到遇到非数字结束
  var num2 = parseInt("abc123");   // 返回NaN，如果第一个字符不是数字或者符号就返回NaN
  ```

- parseFloat()

  ```
  parseFloat()把字符串转换成浮点数
  parseFloat()和parseInt非常相似，不同之处在与
  	parseFloat会解析第一个. 遇到第二个.或者非数字结束
  	如果解析的内容里只有整数时，解析成整数
  ```

- +，-0等运算

  ```javascript
  var str = '500';
  console.log(+str);		// 取正
  console.log(-str);		// 取负
  console.log(str - 0);
  ```

#### 转换成布尔类型

- Boolean()

  ```
  0  ''(空字符串) null undefined NaN 为false  其它都为true
  ```


# 运算符

基本上和java都一样。以下列出几个需要注意的：

- 比较两个字符串用==或者===，**没有equals();**

- ==（等同）：值是否相等；  

- ===（恒等）：值以及类型是否都相等


# 语句

基本上和java都一样。以下列出几个不一样的地方：

**if**

```javascript
if (xxx) {//这个{不能换行写，其他语句也有可能有这样的情况。
  // xxx
}

比如以下就是错的：
if (xxx) 
{
  // xxx
}
```

**swtich...case**

```
case的条件：
    1）可以是常量. string,number
    2）可以是变量或表达式。（java不能）
	3）switch 语句在比较值时本质原理使用的是全等操作符===（所以字符串'10' 不等于数值 10）
```

**for和for...in**

```
1.遍历数组用for循环，不要用for in，( 我们无法保证我们引入的js是否会采用prototype扩展原生的Array )
2.遍历对象使用for in，for没办法提供理想的遍历。并且for...in会遍历出所有属性和方法
```



# 断点调试

- 浏览器中按F12-->**sources**-->找到需要调试的文件-->在程序的某一行设置断点
- console.log()也是非常好用的调试方式



# 函数

### 函数的定义

- 函数声明

```javascript
function 函数名(x,y,z,i...){//和java区别：不需要声明数据类型。
  // 函数体
  // 可以有返回值
}
```

- 函数表达式

```javascript
var fn = function() {
  // 函数体
}；//等价于一个赋值的过程，所以要加分号。
```

### arguments对象的使用

> 所有函数都内置了一个**arguments对象**，arguments对象中存储了传递的所有的实参。arguments是一个**伪数组**，可以通过arguments获取实参。

```
arguments[索引]---->实参的值
arguments.length--->实参的个数
作用1：类似java的可变参数的作用
```

### 匿名函数

> 没有函数名的函数都称为**匿名函数**

JS中如何使用匿名函数：

- 函数表达式

  ```
  将匿名函数赋值给一个变量，这样就可以通过变量进行调用
  ```


- 自调用函数

  ```
  (function () {
    alert(123);
  })();
  
  补充：函数名中存的是函数的全部代码，所以自调用的形式就相当于“声明时就调用”，所以是一次性的。
  ```


### 函数是一种数据类型

> 函数的数据类型就是function，因为是数据类型，所以函数可以作为**参数**和**返回值**使用。

```javascript
function fn() {}
console.log(typeof fn);
//输出：function
```

- 函数作为参数

因为函数也是一种类型，可以把函数作为函数的参数。函数作为参数时称为**“回调函数”**

```javascript
function f1(fn){
    fn();
}

function f2(){
    console.log("这也可以输出");
}

//调用
f1(f2);//f2不要带括号，不然就重复了	
```



- 函数做为返回值

因为函数是一种类型，所以可以把函数可以作为返回值从函数内部返回，这种用法在后面很常见。

```javascript
function fn(b) {
  var a = 10;
  return function () {
    alert(a+b);
  }
}
fn(15)();
```



### 局部变量

在函数内部定义的变量是局部变量

### 全局变量

在函数外面声明的都是全局变量，JS中没有块级作用域。

```javascript
var a;	//全局变量
var b;	//全局变量
{
    var d; //全局变量
}
function f1(){
    var c; //局部变量,注：是在整个函数中都有效，js没有块级作用域
    g;//特殊：在函数内部，且不用var声明的变量，称为“隐式全局变量”，不推荐使用。
}
```



# 预解析

> JavaScript代码的执行是由浏览器中的JavaScript解析器来执行的。JavaScript解析器执行JavaScript代码的时候，分为两个过程：预解析过程和代码执行过程

预解析过程：

1. 把变量的声明提升到当前作用域的最前面，只会提升声明，不会提升赋值。
2. 把函数的声明提升到当前作用域的最前面，只会提升声明，不会提升调用。
3. 先提升var，在提升function

# 对象

> JavaScript不是面向对象的语言，是一门基于对象的语言，JS中没有“类”，JS中对象的概念就相当于java中的“类”，对象有“行为”和“属性”。

## 对象创建方式

#### 1.对象字面量

```javascript
var o = {
  name: 'zs',
  age: 18,
  sex: true,
  sayHi: function () {
    console.log(this.name);
  }
};   //注：这里需要一个分号
```

#### 2.new Object()创建对象

```javascript
var person = new Object();
person.name = 'lisi';
person.age = 35;
person.job = 'actor';
person.sayHi = function(){
    console.log('Hello,everyBody');
}
```

#### 3.工厂模式创建对象

```javascript
function createPerson(name, age, job) {
  var person = new Object();
  person.name = name;
  person.age = age;
  person.job = job;
  person.sayHi = function(){
    console.log('Hello,everyBody');
  }
  return person;
}
var p1 = createPerson('张三', 22, 'actor');
```

#### 4.自定义构造函数

```javascript
function Person(name,age,job){//首字母大写，区分普通函数。
  this.name = name;
  this.age = age;
  this.job = job;
  this.sayHi = function(){
  	console.log('Hello,everyBody');
  }
}
var p1 = new Person('张三', 22, 'actor');
```

了解：以上几种方式都可以通过**先创建，再追加属性**的方式，但是这种方式没有封装性，不建议使用。

## 对象的使用

#### 遍历对象的属性

> 通过for..in语法可以遍历一个对象，不能是for循环。

```javascript
for(var key in obj) {
  console.log(key + "==" + obj[key]);
    //这里不能是obj.key，因为会认为key是obj的属性，但key是一个变量。
}
除了对象.属性/方法的方式，还可以通过对象["属性/方法"]来调用对象的属性和方法。
```

### 删除对象的属性(了解)

```javascript
function fun() { 
  this.name = 'mm';
}
var obj = new fun(); 
console.log(obj.name); // mm 
delete obj.name;
console.log(obj.name); // undefined
```

## 内置对象

> JavaScript中的对象分为3种：内置对象、浏览器对象、自定义对象。
>
> MDN网站查询前端的API。

#### String对象

```
创建：方式一：var str1 = new String("hello");方式二：var str1 = "hello";字符串的不可变(和java一样)
```

#### Number对象

```
.....
```

#### Boolean对象

```
.....
```

#### Math对象

Math对象不是构造函数，都是以静态成员的方式提供（一句话，就是Java中的静态）。

```javascript
Math.PI						// 圆周率
Math.random()				// 生成随机数
Math.floor()/Math.ceil()	 // 向下取整/向上取整
Math.round()				// 取整，四舍五入
Math.abs()					// 绝对值
Math.max()/Math.min()		 // 求最大和最小值
......
```

#### Date对象

```
var date = new Date(); //取当前系统日期时间 
......
```

#### Array对象

> 与java数组的区别：
>     1）数组的长度会随着元素的添加而变化，不用担心越界。
>     2 )  js的数组可以存放任意类型的元素。（弱类型语言）
>
> JS中数组的增删改查操作和java大同小异。因为JS是弱类型语言，所以方式可能更多一些。

- ##### 创建数组


```javascript
// 1. 使用构造函数创建数组对象
// 创建了一个空数组
var arr = new Array();
// 创建了一个长度为3的数组
var arr = new Array(长度);
// 创建了一个数组，里面存放了string/number/...
var arr = new Array(值, 值, 值);


// 2. 使用字面量创建数组对象
var arr = [1, 2, 3];
```

- ##### 方法(重点)

  ```javascript
  .push(值);--->把值追加到数组末尾，返回新数组长度
  .pop();--->删除数组中最后一个元素,返回所删除的值
  .shift();--->删除数组中第一个元素,返回所删除的值
  .unshift();--->把值追加到数组开头，返回新数组长度
  .forEach(函数)方法---遍历数组用---相当于for循环
  .join("|");----数组元素之间用|隔开，返回的是一个字符串
  //......还有很多方法，比java的多
  ```


---------------------以上是JavaScript的基础----------（EMCA基础语法）--------------

# BOM编程

```
Browser Object Model，浏览器对象模型。JavaScript是由浏览器中内置的javascript脚本解释器程序来执行javascript脚本语言的。为了便于对浏览器的操作，javascript封装了对浏览器的各个对象使得开发者可以方便的操作浏览器。
```

## BOM对象

### window 对象

```
注意： 调用的window对象的方法时，可以省略window不写。（window对象是最大的，它是一个窗口，所以也以为着它包含了location对象、history对象、screen 对象等等。）
open(要打开的页面,打开的方式,窗口参数): 在一个窗口中打开页面 （后两个参数可不写）
setInterval(函数，时间间隔): 每隔n毫秒调用指定的任务（函数）（执行n次）
setTimeout(函数，时间间隔): 和setInterval的区别(只执行1次)
clearInterval(任务ID): 清除定时器
clearTimeout(任务ID): 清除定时器
alert(): 提示框
confirm(): "确认"提示框，返回用户操作（true: 点击了确定；  false： 点击了取消）
propmt(): "输入"提示框，同样也返回用户操作
moveto()  将窗口左上角的屏幕位置移动到指定的 x 和 y 位置。
moveby()    相对于目前的位置移动。
resizeTo()   调整当前浏览器的窗口。
```

### location 对象

```
href属性： 代表的是地址栏的URL，可以获取和设置URL。URL表示统一资源定位符
reload方法： 刷新当前页面
```

### history对象

```
forward(): 前进到下一页
back(): 后退上一页
go(): 跳转到某页（正整数：前进  负整数：后退）
```

### screen 对象

```
属性：availWidth 、availHeight、width、height
availHeight和availWidth是指活动的屏幕，即排除了任务栏之后的屏幕高度和宽度
```



# 事件机制

```
javascript事件编程的三个要素和GUI一样：
    1）事件源：源头，整个事件的因他而起。
    2）事件 ：
    3）监听器： 
比如保安看护着一个小孩子，这个小孩子被流氓打了。安保一看到小孩子被打，则采取了一些措施。
保安：监听器；  	   事件：小孩子被流氓打；     	小孩子：事件源
(一个事件源可以有多个事件和对应的监听器，即小孩子可能会有很多事，不同的事有不同的措施)
```

#### javascript事件分类：

```
1.点击相关的：
    单击： onclick
    双击： ondblclick

2.焦点相关的：
    聚焦：  onfocus
    失去焦点： onblur

3.选项相关的：
    改变选项： onchange

4.鼠标相关的：
    鼠标经过： onmouseover
    鼠标移除： onmouseout

5.页面加载相关的：
    页面加载： onload (这个事件是在加载完标签后再触发。通常用在body标签中，意为加载完body标签的内容后会				触发。)
6.表单相关的：
	onsubmit 当表单将要被提交时触发。
7.按键相关的：
    onkeydown 当用户按下键盘按键时触发。 
    onkeyup 当用户释放键盘按键时触发。 
    onkeypress 当用户按下字面键时触发。

```

# DOM编程

> DOM（document Object Model）文档对象模型。
> 在浏览器加载完html页面后，javascript引擎把整个html的所有标签封装成了对象，并形成了一个树状结构，通过操作这些标签对象来控制页面，就是DOM编程。
> 学习DOM编程的核心就是学习“操作标签对象”。

- 文档：一个网页可以称为文档——document
- 节点：网页中的所有内容都是节点（标签、属性、文本、注释等）——node
- 元素：网页中的标签——element
- 属性：标签的属性——attribute

## 例子说明DOM使用

```javascript
<input type="button" value="弹窗" id="btn" />
<script type="text/javascript">
    function f1(){
        alert("弹弹弹");
    }

    document.getElementById("btn").onclick=f1;//只添加了点击事件
	document.getElementById("btn").onclick=f1();//直接执行函数。

//以下才是最常用的方式，因为上述两种有函数同名被覆盖的风险
    document.getElementById("btn").onclick=function(){
		alert("弹弹弹");
    }
</script>

说明：
1.先获取到元素，getElementById只是其中一种方式；
2.通过"  元素.属性  "来改变元素的属性，如果  .src  .href  .width等等，只要该元素有这种属性。
```



## 获取标签对象

```
掌握
	getElementById()
	getElementsByTagName()
了解
	getElementsByName()
	getElementsByClassName()
	querySelector()
	querySelectorAll()
  通过document对象的集合:
    all: 获取所有标签对象
    forms： 获取form标签对象
    images: 获取img标签对象
    links: 获取a标签对象
  通过关系查找标签对象:
  	父节点： parentNode属性
    子节点： childNodes属性
    第一个子节点： firstChild属性
    最后一个子节点： lastChild属性
    下一个兄弟节点： nextSibling属性
    上一个兄弟节点： previousSibling属性
```

## 属性操作

### 非表单元素的属性

href、title、id、src、className

- innerHTML和innerText

```javascript
var box = document.getElementById('box');
box.innerHTML = '我是文本<p>我会生成为标签</p>';
console.log(box.innerHTML);
box.innerText = '我是文本<p>我不会生成为标签</p>';
console.log(box.innerText);
```

- HTML转义符

```
"		&quot;
‘		&apos;
&		&amp;
<		&lt;    //less than  小于
>		&gt;   // greater than  大于
空格	   &nbsp;
©		&copy;
```

### 表单元素属性

- value 用于大部分表单元素的内容获取(option除外)
- type 可以获取input标签的类型(输入框或复选框等)
- disabled 禁用属性
- checked 复选框选中属性
- selected 下拉菜单选中属性





### 案例1—点击按钮的排他功能

```javascript
//获取所有的按钮,分别注册点击事件
  var btnObjs = document.getElementsByTagName("input");
  //循环遍历所有的按钮
  for (var i = 0; i < btnObjs.length; i++) {
    //为每个按钮都要注册点击事件
    btnObjs[i].onclick = function () {
      //把所有的按钮的value值设置为默认的值:没怀孕
      for (var j = 0; j < btnObjs.length; j++) {
        btnObjs[j].value = "没怀孕";
      }
      //当前被点击的按钮设置为:怀孕了
      this.value = "怀孕了";
    };
  }
```

### 案例2—点击按钮设置样式

```javascript
//可以通过.style.XXX改变样式
my$("btn").onclick = function () {
    my$("dv").style.width = "300px";
    my$("dv").style.height = "200px";
    //凡是css中这个属性是多个单词的写法,在js代码中DOM操作的时候.把-干掉,后面的	单词的首字母大写即可
    my$("dv").style.backgroundColor = "pink";
};
```

### 案例2—网页开关灯

```javascript
<style>
    .cls {
    background-color: black;
    }
</style>
document.body.className = document.body.className != "cls" ? "cls" : "";
```



## 标签对象方法（增删改）

```
添加相关的：
    document.createElement("标签名")     创建节点对象
    setAttribute("name","value"):       设置节点的属性（也可以设事件）
插入相关的：
    appendChild("标签对象") ;   添加子节点
    insertBefore("新标签对象","指定的对象")  在指定的对象前面添加兄弟节点
删除：
    父.removeChild(子);   删除子节点
```

# 正则表达式

```
创建正则表达式： var 变量 = /正则规则/;
注意：在js的正则表达式中，如果遇到了符合规则的内容，就代表匹配成功！如果需要和java一样完全匹配，需要添加		边界符号/^正则规则$/

方法： Regexp.test( str )返回true或者false	
        String.replace( regex, str )
		
次数：
    *    	0或多个元素
    +   	1个或多个元素	
    ?    	0或1个元素
    {n,m}  	大于n,小于m的个数
    {n}		就是n个
    {n,}	至少n个
通配符：
    \d		任意数字
    \D		任意非数字
    \s		任意空白
    \S		任意非空白
    .		任意字符（除'\n'外）
```

