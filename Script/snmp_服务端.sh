#!/bin/bash
#  以下操作仅为示例操作，详细操作请按实际情况而定


# 1.编辑snmp配置文件
vim /etc/snmpd.conf

##############################
# community 中是对应 sec.name 的连接密码
# SNMP 中 连接密码被称为 community sec.name 类似于用户名
将 
   com2sec notConfigUser default public 
修改为
   com2sec notConfigUser default monitor

##############################
# groupName <---> securityName
# 组名      <---> 上面设置的用户名
# 可指定每个group 使用SNMP协议版本
##############################
# group  <---> read write notif
# 上面的group <--> 读/写/通知(SNMP trap)使用的上面的view设置
将第62行的
   access  notConfigGroup "" any noauth exact systemview none none
修改为
   access  notConfigGroup "" any noauth exact all none none
##############################
# view SNMP 中OID设定
# name = 此视图名
# include/exclude 包括/排除之后的OID地址
# subtree=OID地址(.0 表示所有的OID)
将第85行的
	#view all    included  .1       80
去掉注释 

2.重启SNMP服务
systemctl restart snmppd.service

3.添加为开机自启
systemctl enable snmpd.service

4.验证snmp是否可以获取到值
snmpwalk -v 2c -c monitor [设备IP]