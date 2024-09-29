#!/bin/bash


# 获取用户输入的要关闭的端口列表
echo "请输入要关闭的端口列表，用空格分隔："
read -a ports_to_close

# 获取用户输入的要允许的端口列表
echo "请输入要允许的端口列表，用空格分隔："
read -a ports_to_allow

# 备份iptables配置
iptables-save > /path/to/iptables_backup.txt

# 加载iptables规则
iptables -F
iptables -X
iptables -Z

# 允许的端口
for port in "${ports_to_allow[@]}"; do
    iptables -A INPUT -p tcp --dport $port -j ACCEPT
    iptables -A OUTPUT -p tcp --sport $port -j ACCEPT
done

# 关闭的端口
for port in "${ports_to_close[@]}"; do
    iptables -A INPUT -p tcp --dport $port -j DROP
    iptables -A OUTPUT -p tcp --sport $port -j DROP
done

# 保存iptables规则
service iptables save

echo "防火墙端口已更新。"
