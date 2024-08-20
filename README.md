# 运行方法
项目使用docker部署运行，这样可以避免各种环境兼容问题。
1. 在Windows操作系统或者Linux操作系统下载安装docker。
2. 克隆本项目到本地。
3. 执行命令：`bash ./create_services.sh`。执行成功后就可以创建项目运行所需要的所有镜像和容器。
4. 清空镜像可以执行：`bash ./clear_services.sh`。这个命令会将所有镜像和容器清空，**慎用**。
5. 镜像创建完成后执行`./filecloud-webapi/Infrastructure/SQL/`目录下三个文件：`dbCreate.sql`、`filesTable_Create.sql`、`userInfosTable_Create.sql`，可将数据库创建完成。
6. 访问链接：`http://IP地址:8080`，即可使用网盘系统。

> 上传的文件内容被保存在：`/home/www/filecloud`目录下，可以在执行完`create_services.sh`文件后查看目录是否创建成功，同时也要检查文件目录权限是否开放。
