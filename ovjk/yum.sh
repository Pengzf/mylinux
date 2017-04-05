#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear;
rm -- "$0"
rm -rf yum.sh

echo -e "\033[31m                      【更新yum】\033[0m"

cd /etc/yum.repos.d/

#备份原yum源
mv CentOS-Base.repo CentOS-Base.repo.bak

wget http://mirrors.163.com/.help/CentOS6-Base-163.repo

mv CentOS6-Base-163.repo CentOS-Base.repo


cd /root
rm -rf yum.sh
echo -e "\033[31m                      【更新完成】\033[0m"
echo ""
echo -e "\033[31m马上开始搭建..........\033[0m"
sleep 2
wget https://raw.githubusercontent.com/Pengzf/mylinux/master/ovjk/ovpn && bash ovpn
