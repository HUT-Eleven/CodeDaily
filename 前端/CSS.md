### CSS 概述

​	Cascading Style Sheets : 层叠样式表

​	CSS 语法：由两个主要的部分构成：选择器，以及一条或多条声明。（每条声明由一个样式和一个值组成）



### 选择器

1. 元素选择器

   ```
   选择器通常将是某个 HTML 元素,比如 p、h1、em、a.
   ```

2. 选择器分组（并集选择器）

   ```html
   h2, p {color:gray;}  h2和p元素都享有这些样式
   ```

3. 通配符选择器

   ```
   * {color:red;}所有元素的color属性都变成红色
   通配符选择器等价于列出了文档中所有元素的一个分组选择器
   ```

4. 类选择器

   ```
   常规语法：.important {color:red;}
   结合元素选择器：p.important {color:red;}解释为：“其 class 属性值为 important 的所有p标签”
   多类选择器：<p class="class1 class2">即多个class的值，表示该元素即属于class1 也属于class2。
   ```

5. 伪类选择器

   ```
   标签有四种状态：
       link: 没有访问过的状态
       hover: 鼠标经过的状态
       active:鼠标激活（按下但没有松开）的状态
       visited: 已经被访问过的状态（鼠标点下且松开）
   通常用在a超链接，或者图片标签上提供一些悬浮的特效，a:link{...}
   正确顺序： link visited hover active！！！
   ```

6. ID 选择器

   ```
   #选择器名称 {font-weight:bold;}
   注释：在同一个html页面中建议元素的id唯一。
   ```

7. 后代选择器

   ```
   h1 em {color:red;}可以解释为 “作为 h1 元素后代的任何 em 元素”的color属性都变为red，是h1下的所有em（包括儿子，孙子等等）
   ```

8. 子元素选择器

   ```
   h1 > strong {color:red;}
   与后代选择器相比，子元素选择器只能选择作为某元素子元素的元素
   ```

9. 属性选择器

   ```
   a[href][title] {color:red;}将同时有 href 和 title 属性的 HTML 超链接的文本设置为红色
   img[alt] {border: 5px solid red;}可以对所有带有 alt 属性的图像应用样式
   属性与属性值必须完全匹配：
   p[class="class1 class2"] {color: red;}不能少了class1或class2，或者改用class~="important"。
   ```



#### 引入方式

```
外部样式: 通过link标签引入一个外部的css文件
	一： <link  href="../css/s1.css"  rel="stylesheet" type="text/css"/>（推荐）
	二： <style type="text/css"> @import url("../css/s1.css"); </style>
内部样式: 直接在style标签内编写CSS代码
行内样式: 直接在标签中添加一个style属性, 编写CSS样式
```

##### 优先级

```
按照选择器搜索精确度来排序:
行内样式 > 内部样式 > 外部样式
内部样式中：ID选择器 > 类选择器  > 元素选择器
如果选择器类型一样，就按就近原则: 哪个离得近,就选用哪个的样式（即程序从上到下读的顺序）
```



### 样式

##### 背景

```
1.背景色： background-color 
	默认值是 transparent(透明)
2.背景图:  background-image
	body {background-image: url(/i/eg_bg_04.gif);}
3.背景平铺效果：background-repeat
	repeat-x、repeat-y、no-repeat、repeat（默认）
4.背景定位： background-position：x,y(两个参数)
	如果用关键字调整：参数一：图片的进入部位（top、bottom、center），参数二：图片的从指定标签的哪个位置开始显示（left、right、center）（非常好理解，但也非常奇怪）
	也可以用百分比或者长度值来调整，相对左上角为0,0进行调整。和相对定位类似
	background-position:66% 33%;水平方向右移66%，垂直方向下移33%。
	background-position:50px 100px;水平方向右移50px，垂直方向下移100px。（好用）
```

##### 文本

```
/*字符间距*/:letter-spacing:10px;(每个字之间)
/*单词间距*/:word-spacing:30px;（单词或者词语之间）
/*对齐方式*/:text-align:center;
text-decoration:下划线-underline，  中划线(line-through)   上划线-overline  没有:none
```

##### 字体

```
注意：这里的字体类型是读取系统的默认字体库，尽量使用通用的字体，如果你设置的字体，用户的系统上没有，就是使用默认的宋体显示。
font-family:字体类型 
font-size:24px;字体大小
font-style:italic;/*字体样式: 正(normal默认)  斜(italic)*/
font-weight:bold;/*字体粗细  bold 加粗*/
/* font: 简写属性 */font:italic bold 36px "黑体";		
```

##### 列表

```
list-style-type：列表符号类型
list-style-image：指定图象设为列表符号
```

##### 边框

```
/*边框颜色*/:
    border-color:#F00;
    border-left-color:#F00;
    border-right-color:#0F0;
    border-top-color:#00F;
    border-bottom-color:#C90;

/*边框宽度*/
    border-width:10px;
    border-left-width:10px;
    border-right-width:20px;
    border-top-width:30px;
    border-bottom-width:40px;

/*边框样式
    border-style:solid;
    border-left-style:solid;
    border-right-style:dashed;
    border-top-style:dotted;
    border-bottom-style:double;双实线

/*简写属性*/
1) 默认设置方向属性： 上 右 下 左(顺时针)
2）如果当前方向没有设置，那么取对面的

/*所有边框属性的简写属性*/
border:2px solid #F00;
```

注释：基本每个样式都有简写属性(就是把多种属性直接写在一起，但暂时不推荐使用)



### 盒子模型(Box Model)

​	作用：规定了元素框处理元素内容、内边距、边框 和 外边距 的方式。
	万物皆盒子，所有标签（行级，块级）都是容纳数据的盒子。

**内边距:  边框和内容区之间的距离**

```
padding: 10px 20px 30px 40px;  上右下左, 顺时针的方向。（哪个没有就取其对面的值，例如：
padding: 10px 20px 30px;  上 10px 右20px  下30px  左20px

也可以通过使用下面四个单独的属性，分别设置上、右、下、左内边距：
padding-top:
padding-right:
padding-bottom:
padding-left:
```

 **外边距**：盒子与外界元素之间的距离

```
语法和内边距padding几乎一样
p {margin: 20px 30px 30px 20px;}
需要注意的是，如果没写也会取对面的值，但是只写了一个值，代表四边都是这个值！！！
p {margin: 1px;}			/* 等价于 1px 1px 1px 1px */
也可以通过使用下面四个单独的属性，分别设置上、右、下、左内边距：
margin-top:
margin-right:
margin-bottom:
margin-left: 

另：外边距自动合并的情况：当两个“垂直外边距”相遇时，它们将形成一个外边距。合并后的外边距的高度取较大的	值。只有普通文档流中块框的垂直外边距才会发生外边距合并。行内框、浮动框或绝对定位之间的外边距不会合	并。
```



### 定位(Position)

CSS 有三种基本的定位机制：普通流、绝对定位、浮动。除非专门指定，否则所有框都在普通流中定位。	

#### 相对定位

```
概念：相对定位是“相对于”元素本应该出现的位置
XXX{
    position:relative;
    left:-20px;
    top :20px;
}(不会去设定底部距离和右边的距离，由正负值代替)
注意，在使用相对定位时，无论是否进行移动，元素仍然占据原来的空间。因此，移动元素会导致它覆盖其它框。
```

#### 绝对定位

```
概念：绝对定位是“相对于”最近的已定位父元素，如果不存在已定位的父元素，那么“相对于”<body>
XXX{
  position: absolute;
  left: 30px;
  top: 20px;
}
设置为绝对定位的元素框从文档流完全删除，元素原先在正常文档流中所占的空间会关闭。
```

#### 固定定位

```
概念：对于整个页面来说是页面一直固定，就像网站的“咨询广告”会一直跟随在页面上的固定位置。fixed
```

补充：z-index属性：设置元素的堆叠顺序。overflow属性：设置当某个元素的内容溢出其区域时发生的事情。



### 浮动

```
浮动的框可以向左或向右移动，直到它的外边缘碰到包含框或另一个浮动框的边框为止。由于浮动框不在文档的普通流中，所以文档的普通流中的块框表现得就像浮动框不存在一样。
```

```
float属性:
    left
    right

clear属性: 清除浮动
    both : 两边都不允许浮动
    left: 左边不允许浮动
    right : 右边不允许浮动
```

##### 

### 高级

display的几个常用的属性值，inline ， block， inline-block

1. inline:使元素变成行内元素，拥有行内元素的特性，即可以与其他行内元素共享一行，不会独占一行. 
2. block:使元素变成块级元素，独占一行，在不设置自己的宽度的情况下，块级元素会默认填满父级元素的宽度. 
3. inline-block:就是不独占一行的块级元素