#!/bin/bash

# 设置nfs服务并设置为开机自启动
systemctl start nfs-server.service
systemctl enable nfs.server.service

# 创建一个挂载目录
mkdir /nfs01
mount -t nfs 服务端ip:/nfs /nfs01
# 查看是否挂载完成
ds -Th
# 如果不通则关闭防火墙
systemctl stop firewalld
firewall-cmd --state
