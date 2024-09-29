# -*- coding: UTF-8 -*-
# @Project : SW窗口.py 
# @File    : SW_serial.py
# @Author  : bote798
# @Date    : 2024/8/21 10:30 
# @IDE     : PyCharm

import serial
import time

# 串行端口配置
serial_port = 'COM3'  # 串行端口名称，根据实际情况修改
baud_rate = 9600      # 波特率，根据交换机的配置修改
timeout = 1           # 超时时间，单位秒

# 创建串行端口对象
ser = serial.Serial(serial_port, baud_rate, timeout=timeout)

# 检查串行端口是否打开
if ser.is_open:
    print("串行端口已打开，开始发送命令。")
else:
    print("串行端口打开失败。")
    exit()

# 要发送的命令列表
commands = [
    "system-view",  # 进入系统视图
    "vlan 10",
    "Interface Vlan-interface 10",
    "ip address 192.168.100.254 255.255.255.0",
    # 激活vlan10
    "undo shutdown",
    "interface range Ethernet0/0/1 to Ethernet0/0/7",
    "port link-type access"
    "Port access vlan 10",
    "quit",
    "quit",
    "save"
]

# 发送命令
for command in commands:
    ser.write((command + '\n').encode('ascii'))  # 发送命令并换行
    time.sleep(1)  # 等待命令执行

# 关闭串行端口
ser.close()
print("串行端口已关闭。")

