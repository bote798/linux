#!/bin/bash

# 1.安装程序
yum install device-mapper-multipath -y

# 2.将多路径软件添加至内核模块中
modprobe dm-multipath
modprode dm-round-robin

# 3.检查内核添加情况
lsmod | grep multipath
显示如下类似即可：
# dm_multipath           27427  3 dm_round_robin,dm_service_time
# dm_mod                123303  13 dm_round_robin,dm_multipath,dm_log,dm_mirror,dm_service_time

# 4.启动服务
systemctl enable multipathd --now

# 5.备份并编辑配置文件
# 先查看存储设备的WWID（以下两条命令均可）
sudo udevadm info --query=all --name=/dev/sdX | grep ID_SERIAL
multipath -ll

cp /etc/multipath.conf /etc/multipath.conf.bak
vim /etc/multipath.conf

"""
blacklist {
        wwid    3600508b1001c044c39717726236c68d5
}

defaults {
    user_friendly_names       yes
    polling_interval            10
    queue_without_daemon    no
    flush_on_last_del          yes
    checker_timeout 120
}


devices {
    device {
        vendor                 "3par8400"
        product                "HP"
        path_grouping_policy    asmdisk
        no_path_retry           30
        prio                    hp_sw
        path_checker            tur
        path_selector           "round-robin 0"
        hardware_handler       "0"
        failback                15
        }
}

# 多路径设备信息
multipaths {
        multipath {

           wwid    360002ac0000000000000000300023867
           alias    mpathdisk01
        }
}

如果有两个或者多个就再加一条即可。
multipaths {
        multipath {
           # 多路径设备的wwid放在这里
           wwid    360002ac0000000000000000300023867
           # 设置多路径设备的别名
           # 例如：mpathdisk01
           alias    mpathdisk01
        }
        multipath {
           wwid    360002ac0000000000000000400023867
           alias    mpathdisk02
        }
}
"""

# 6.重启服务
systemctl restart multipathd

# 7.查看是否成功
lsblk
#结果类似
[root@test ~]# lsblk
"""
NAME            MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda               8:0    0   557G  0 disk
├─sda1            8:1    0     4G  0 part  /boot
└─sda2            8:2    0   553G  0 part
  ├─centos-root 253:0    0 488.9G  0 lvm   /
  └─centos-swap 253:1    0    64G  0 lvm   [SWAP]
sdb               8:16   0     2T  0 disk
└─mpathdisk01   253:2    0     2T  0 mpath
sdc               8:32   0     2T  0 disk
└─mpathdisk01   253:2    0     2T  0 mpath
sdd               8:48   0     2T  0 disk
└─mpathdisk01   253:2    0     2T  0 mpath
sde               8:64   0     2T  0 disk
└─mpathdisk01   253:2    0     2T  0 mpath
"""

# 查看状态
multipath -d -l

# 配置文件解析
"""
blacklist：定义了一些被禁用的设备，只要 WWID 匹配了列表中的任何一个，它就会被黑名单所拒绝。
wwid：唯一标识多路径设备的 32 位十六进制字符串。
defaults：定义了一些默认设置，这些设置可以在其他部分被重写。
user_friendly_names：使多路径设备更易于理解和使用。
polling_interval：检查路径状态的频率（以秒为单位）。
queue_without_daemon：定义了当 multipathd 守护程序处于未运行状态时处理 I/O 请求的行为。
flush_on_last_del：在删除最后一个路径时是否刷新 IO 缓存。
checker_timeout：指定检查器超时的时间。
devices：包含一个或多个
device 块，每个块都描述了一个特定的多路径设备。
device：描述了一个多路径设备及其属性。
vendor、product：设备的制造商和产品名称。
path_grouping_policy：指定将路径分组到哪个组中。
no_path_retry：当无法访问某个路径时进行重试的次数。
prio：指定优先级算法，如 alua、emc、hp_sw 等。
path_checker：指定 IO 路径检查器的类型。
path_selector：指定选择路径的算法。例如，“round-robin 0” 表示依次将请求分发到每个路径上。
hardware_handler：指定用于处理硬件错误的脚本或程序。
failback：指定多长时间后进行故障切换。
multipaths：包含一个或多个
multipath 块，每个块都描述了一个设备的多个路径。
alias：为指定的多路径设备定义别名。

prio 是 multipath.conf 配置文件中的一个关键字，表示优先级算法。它可以指定多路径设备使用哪种算法来选择 I/O 请求路径。例如：

prio alua

以上配置指定了使用 Asymmetric Logical Unit Access(ALUA) 算法进行路径选择。这个算法主要用于 SAN 存储环境下，能够更好地处理存储阵列并发访问的问题。
除了 ALUA，还有其他一些可用的优先级算法，如：
emc：用于与 EMC 存储阵列配合使用。
hp_sw：用于与 HP 存储阵列配合使用。
rdac：用于与 LSI 存储阵列配合使用。
如果没有指定 prio 设置，则默认为 const（优先选择第一个路径）算法，或者是上层应用程序自己控制路径选择。
"""