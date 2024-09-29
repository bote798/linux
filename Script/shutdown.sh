#!/bin/bash

systemctl stop sshd

systemctl stop telnet.socket

echo "远程连接已关闭。"
