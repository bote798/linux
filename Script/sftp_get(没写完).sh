#!/bin/bash

# 获取用户输入的 IP 地址
read -p "请输入目标机器的 IP 地址: " ip_address

# 获取用户输入的用户名
read -p "请输入用户名: " username

# 获取用户输入的密码（不显示输入）
read -sp "请输入密码: " password
echo

# 获取用户输入的目标文件路径
read -p "请输入目标文件的完整路径: " remote_file_path

# 获取用户希望保存文件的本地路径
read -p "请输入本地保存文件的路径: " local_file_path

# 使用 sftp 连接并下载文件
echo "$username@$ip_address's password: $password" | sftp -oPort=22 -b - "$remote_file_path" "$username@$ip_address:$remote_file_path" "$local_file_path"

# 检查 sftp 命令是否成功执行
if [ $? -eq 0 ]; then
    echo "文件已成功下载到本地路径: $local_file_path"
else
    echo "文件下载失败，请检查输入的信息是否正确。"
fi
