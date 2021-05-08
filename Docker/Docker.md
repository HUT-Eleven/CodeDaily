# 五、Docker

## 1、概念

Docker是一个开源的应用容器引擎

将软件做好配置并编译成一个镜像；后将镜像发布出去，其他用户就可以直接使用这个镜像。运行中的这个镜像叫做容器，容器启动速度快，类似ghost操作系统，安装好了什么都有了；

## 2、名词理解

docker主机（HOST）:安装了Docker程序的机器（提供docker的服务）

docker客户端（Client）:连接Docker主机，使用docker

docker仓库（Registry）：用来保存打包好的软件镜像（公共hub.docker.com）

docker镜像（Image）:软件打好包的镜像，放到docker的仓库中

docker容器（Container）:镜像启动后的实例（启动5次镜像则为5个容器）

docker的步骤：

​	1、安装Docker

​	2、去Docker仓库找软件对应的镜像；

​	3、运行镜像，会生成一个容器

​	4、对容器的启动停止，就是对软件的启动和停止

## 3、安装

### 1、安装Linux

[安装vxbox并且安装ubuntu(有道云笔记)](http://note.youdao.com/noteshare?id=06ccb673d253fea78fe35430465758e1)

### 2、在linux上安装docker

```shell
# uname -r  				查看centos版本
# yum update				升级linux内核（docker建议linux内核在3.8以上，要求至少3.1以上）
# yum install docker		安装docker
# systemctl start docker  	启动docker
# docker -v					查看版本
# systemctl enable docker	设置开机启动docker
# systemctl stop docker		停止docker
```

## 4、常用操作

[docker命令查询](http://www.runoob.com/docker/docker-command-manual.html)

docker命令特点：1. 一般以docker开头； 2. images表示镜像；3.命令和linux很相似；4.操作容器多数是通过容器的id

### 1、镜像操作

```shell
docker search [OPTIONS] TERM		从Docker Hub查找镜像
docker pull [OPTIONS] NAME[:TAG|@DIGEST]从镜像仓库中拉取或者更新指定镜像(可指定版本，默认最新版)
docker images						列出本地镜像
docker rmi imageid					删除本地一个或多少镜像。
```



### 2、容器操作

软件的镜像（qq.exe） -- 运行镜像 -- 产生一个容器（正在运行的软件）

**以使用tomcat镜像为例：**

```shell
1、搜索镜像
# docker search tomcat
2、拉取镜像
# docker pull tomcat
3、启动镜像（则会生成一个容器，并也同时启动了这个容器，这里没做映射是不能用的）
# docker images(例出所有镜像)
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/tomcat    latest              d3d38d61e402        35 hours ago        549 MB
# docker run --name mytomcat -d tomcat:latest(mytomcat是这个镜像的本地名称， -d代表后台运行)
-------------以上还是镜像的操作---------以下开始对容器进行操作--------------
4、查看容器
# docker ps（运行中的容器）
# docker ps -a（运行和不运行的）
5、停止容器（根据容器的id）
# docker stop 2f0348702f5f
7、启动容器（启动容器和启动镜像是不同的概念）
# docker start 2f0348702f5f
8、删除容器
# docker rm 2f0348702f5f
9、启动镜像并设置端口映射（只能通过linux系统的端口映射到tomcat的端口来访问tomcat）
# docker run --name mytomcat -d -p 8888:8080 tomcat
虚拟机:8888
容器的:8080
-d:后台运行
-p:主机端口映射到容器端口
浏览器：192.168.179.129:8888（浏览器访问linux的8888端口，映射到8080，需关闭8888端口的防火墙）
10、查看容器的日志
# docker logs 692c408c2201
11、多个启动
# docker run -d -p 9000:8080 --name mytomcat2 tomcat
浏览器：192.168.179.129:9000
```



### 3、举例：安装Mysql

**这些安装步骤都应该参考官方文档**

```shell
docker pull mysql；
docker run --name mysql001 -e MYSQL_ROOT_PASSWORD=123456 -d -p 3307:3306 mysql；

#还有一些高级操作，比如设置配置文件的位置等等。
```

