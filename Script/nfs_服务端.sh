#!/bin/bash

# 安装nfs包
yum install nfs-utils -y

# 启动nfs服务，并设置为开机自启动
systemctl start nfs-server.service
systemctl enable nfs-server.service

# 选择磁盘作为nfs共享分区
# lsblk 查看硬盘名
# 对硬盘分区格式化
# fdisk /硬盘名
# 第一个为 n
# 第二个为 p，然后全部默认后
# 第三个为w
# 退出

mkfs.ext4 /dev/分区名

# 创建一个挂载nfs目录并挂载
mkdir /nfs
mount /dev/分区名
# 查看是否挂载成功
lsblk

# 配置共享目录
vim /etc/exports
# /nfs 客户端ip/24(掩码号)(rw,no_root_squash)(有很多参数，可以百度看看)

# 重启nfs服务
systemctl restart nfs-server.service



