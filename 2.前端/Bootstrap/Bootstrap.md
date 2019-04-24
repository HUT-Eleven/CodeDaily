只学了前端的第一天，笔记删减很多，主要学习怎么用。

# 简介

> Bootstrap的核心就是写好了很多 css样式、组件、JS插件  可直接调用。

## 什么是Bootstrap？

- 框架：库 lib library
- jQuery作为一个框架来讲，提供一套比较便捷的操作DOM的方式
- 把大家都需要的功能预先写好到一些文件  这就是一个框架
- Bootstrap 让我们的 Web 开发更简单，更快捷；

- 注意是 Bootstrap 不是 BootStrap！这是一个词，不是合成词，其含义为：n. 引导指令,引导程序
- Bootstrap 是当下最流行的前端框架（界面工具集）；
- 特点就是灵活简洁，代码优雅，美观大方；
- 其目的是为了让 Web 开发更敏捷；
- 是 Twitter 公司的两名前端工程师 Mark Otto 和 Jacob Thornton 在 2011 - 年发起的，并利用业余时间完成第一个版本的开发；

> 使用 Bootstrap 并不代表不用写 CSS 样式，而是不用写绝大多数大家都会用到的样式


# 准备

Bootstrap文档

- [官方文档](http://getbootstrap.com/)
- [中文文档](http://v3.bootcss.com/)

## 基础的Bootstrap模板(重点)

> 引入Bootstrap的css和js文件

```html
<!DOCTYPE html>
<html lang="en">
  <head>
	<!--设置html文件的编码格式-->
    <meta charset="utf-8">
	<!--设置视口viewport（移动端相关）-->
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<!--设置浏览器的兼容模式版本（让IE使用最新的edge渲染引擎工作）-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- 上述3个meta标签必须放在最前面，任何其他内容跟随其后！ -->
      
    <title>Bootstrap 101 Template</title>
    <!-- 引入Bootstrap核心样式文件（必须） -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- 引入Bootstrap默认主题样式（可选。有一套风格，喜欢就加） -->
    <link rel="stylesheet" href="css/bootstrap.theme.min.css">
    <!-- 你自己的样式或其他文件（自己写的样式放在下面，避免被Bootstrap覆盖） -->
    <link rel="stylesheet" href="example.css">
    
<!-- HTML5 shim 和 Respond.js 是为了让 IE8 支持 HTML5 元素和媒体查询（media queries）功能 -->
<!-- 警告：通过 file:// 协议（就是直接将 html 页面拖拽到浏览器中）访问页面时 Respond.js 不起作用 -->
    <!-- 条件注释(可省略)-->
    <!--[if lt IE 9]>
      <script src="https://cdn.jsdelivr.net/npm/html5shiv@3.7.3/dist/html5shiv.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/respond.js@1.4.2/dest/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <h1>你写的html代码</h1>

    <!-- 由于Bootstrap的JS插件依赖jQuery，所以先引入jQuery -->
    <script src="js/jquery.min.js"></script>
    <!-- 引入所有的Bootstrap的JS插件 -->
    <script src="bootstrap.min.js"></script>
    <!-- 你自己的脚本文件 -->
    <script src="....js"></script>
  </body>
</html>
```

### 视口

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

- 视口的作用：在移动浏览器中，当页面宽度超出设备，浏览器内部虚拟的一个页面容器，将页面容器缩放到设备这么大，然后展示
- 目前大多数手机浏览器的视口（承载页面的容器）宽度都是980；
- 视口的宽度可以通过meta标签设置
- 此属性为移动端页面视口设置，当前值表示在移动端页面的宽度为设备的宽度，并且不缩放（缩放级别为1）
  + width:视口的宽度
  + initial-scale：初始化缩放
  + user-scalable:是否允许用户自行缩放（值：yes/no; 1/0）
  + minimum-scale:最小缩放，一般设置了用户不允许缩放，就没必要设置最小和最大缩放
  + maximum-scale:最大缩放

### 条件注释

- 条件注释的作用就是当判断条件满足时，就会执行注释中的HTML代码，不满足时会当做注释忽略掉

### 第三方依赖（了解）

- [jQuery](https://github.com/jquery/jquery)

    > Bootstrap框架中的所有JS组件都依赖于jQuery实现

- [html5shiv](https://github.com/aFarkas/html5shiv)

    > 让低版本浏览器可以识别HTML5的新标签，如header、footer、section等

- [respond](https://github.com/scottjehl/Respond)

    > 让低版本浏览器可以支持CSS媒体查询功能

# 主要的三个内容

## 1.基础CSS样式

## 2.预置界面组件

## 3.JavaScript插件

### JavaScript插件的依赖情况

### 如何使用Javascript插件

### 内置组件

# 自定义 Bootstrap

- [官网在线](http://getbootstrap.com/customize/)
- [中文网在线](http://v3.bootcss.com/customize/)

## LESS语言

- [官方文档](http://lesscss.org/)
- [中文文档](http://lesscss.cn/)