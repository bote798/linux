#!/bin/bash

# 备份文件
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 修改SSH配置文件
sed -i 's/PermitRootLogin yes/
PermitRootLogin no/g' /etc/ssh/sshd_config

# 重启SSH服务
systemctl restart sshd

echo "Root 账户远程连接已禁止"
