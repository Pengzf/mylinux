#!/bin/bash
http='http://'
host='rtc.lvdp.net'
fie='/openvpn/'
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear;
if [ ! -e "/dev/net/tun" ]; then
mkdir /dev/net; mknod /dev/net/tun c 10 200
fi
cd /
# Logo 	******************************************************************
CopyrightLogo='
==========================================================================
                                                          
                       CentOS  OpenVPN                                 
                         Powered by Xiaoxia 2015-2016                     
                              All Rights Reserved                                                                    
==========================================================================';
echo "$CopyrightLogo";
echo 
echo "脚本已由阿里云/腾讯云CentOS 测试通过"
echo 
echo -e "\033[43;37m请设置转接端口：\033[0m"
echo 
echo -n -e "输入VPN端口（默认8080）：\033[33m【温馨提示:回车默认8080！！！】\033[0m:" 
read vpnport 
if [[ -z $vpnport ]] 
then 
echo -e "\033[34m已设置VPN端口：8080\033[0m"
vpnport=8080 
else 
echo -e "\033[34m已设置VPN端口：$vpnport\033[0m"
fi 
#改成北京时间
function check_datetime(){
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	ntpdate 1.cn.pool.ntp.org
}
check_datetime
cd /
rm -rf passwd
echo "100 100" >passwd
chmod 777 ./passwd
echo "正在部署环境..."
sleep 3
service openvpn stop >/dev/null 2>&1
yum -y remove openvpn >/dev/null 2>&1
rm -rf /etc/openvpn/*
rm -rf /home/vpn.tar.gz
echo "安装执行命令..."
sleep 2
yum install -y redhat-lsb curl gawk
version=`lsb_release -a | grep -e Release|awk -F ":" '{ print $2 }'|awk -F "." '{ print $1 }'`
echo "正在匹配软件源..."
sleep 3

if [ $version == "5" ];then
if [ $(getconf LONG_BIT) = '64' ] ; then
rpm -ivh ${http}${host}${fie}64-epel-release-5-4.noarch.rpm >/dev/null 2>&1
else
rpm -ivh ${http}${host}${fie}32-epel-release-5-4.noarch.rpm >/dev/null 2>&1
fi
fi

if [ $version == "6" ];then
if [ $(getconf LONG_BIT) = '64' ] ; then
rpm -ivh ${http}${host}${fie}epel-release-6-8.noarch.rpm >/dev/null 2>&1
else
rpm -ivh ${http}${host}${fie}32-epel-release-6-8.noarch.rpm >/dev/null 2>&1
fi
fi

if [ $version == "7" ];then
rpm -ivh ${http}${host}${fie}epel-release-latest-7.noarch.rpm >/dev/null 2>&1
fi

if [ ! $version ];then
clear
echo ==========================================================================
echo 
echo "安装被终止，请在Centos系统上执行操作..."
echo
# Logo 	******************************************************************
CO='
                            OpenVPN-2.3.10 安装失败                                
                         Powered by sbwml.cn 2015-2016                     
                              All Rights Reserved                  
                                                                            
==========================================================================';
echo "$CO";
exit
fi
echo "检查并更新软件..."
sleep 3
yum update -y
# OpenVPN Installing ****************************************************************************
echo "配置网络环境..."
sleep 3
myip=`curl -s http://members.3322.org/dyndns/getip`;
service iptables stop
# OpenVPN Installing ****************************************************************************

setenforce 0
cd /etc/
rm -rf ./sysctl.conf
wget ${http}${host}${fie}sysctl.conf >/dev/null 2>&1
sleep 3
chmod 0755 ./sysctl.conf
sysctl -p

# OpenVPN Installing ****************************************************************************
echo "正在安装主程序..."
sleep 3
yum install -y squid openssl openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig
yum install -y openvpn

# OpenVPN Installing ****************************************************************************

cd /etc/openvpn/
rm -rf ./server.conf
rm -rf ./sbwml.sh
wget ${http}${host}${fie}server-passwd.tar.gz >/dev/null 2>&1
tar -zxf server-passwd.tar.gz
cd /etc/squid/
rm -f ./squid.conf
wget ${http}${host}${fie}squid.conf >/dev/null 2>&1
chmod 0755 /etc/squid/squid.conf

sleep 2
squid -z
squid -s  
# OpenVPN Installing ****************************************************************************
cd /etc/openvpn/
wget ${http}${host}${fie}EasyRSA-2.2.2.tar.gz >/dev/null 2>&1
tar -zxvf EasyRSA-2.2.2.tar.gz >/dev/null 2>&1
rm -rf /etc/openvpn/EasyRSA-2.2.2.tar.gz
wget ${http}${host}${fie}omp
chmod 777 omp
./omp -l $vpnport -d
cd /etc/openvpn/easy-rsa/
source vars
./clean-all
clear
echo 
echo 
clear
echo 
echo "正在CA证书，过程停留处需要回车确认写入默认信息，按回车继续操作"
read
echo 
echo -e "nnnnnnnn" | ./build-ca
./build-ca
clear
echo 
echo 
echo "正在生成服务端证书，请根据提示输入 y 进行确认，按回车继续操作"
read
./build-key-server centos
echo 
#echo 
#echo "正在生成客户端证书“user01”，请根据提示输入 y 进行确认，按回车继续"
#read
#./build-key user01
#echo 
echo
clear
echo "正在生成SSL加密证书，这是一个漫长的过程..."
sleep 1
./build-dh
echo
echo "正在生成TLS密钥..."
sleep 2
openvpn --genkey --secret ta.key
# OpenVPN Installing ****************************************************************************
echo 
echo "尝试启动服务..."
sleep 2
service openvpn start
chkconfig openvpn on
sleep 2

# OpenVPN Installing ****************************************************************************
#cp /etc/openvpn/easy-rsa/keys/{ca.crt,user01.{crt,key}} /home/ >/dev/null 2>&1
cp /etc/openvpn/easy-rsa/keys/ca.crt /home/ >/dev/null 2>&1
cp /etc/openvpn/easy-rsa/ta.key /home/ >/dev/null 2>&1
cd /home/ >/dev/null 2>&1
clear
echo
echo 
echo "正在生成OpenVPN.ovpn配置文件..."
echo 
echo 
echo "写入前端代码"
sleep 3
echo '#配置
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17" 
machine-readable-output
client
dev tun
connect-retry-max 5
connect-retry 5
resolv-retry 60
########免流代码########
http-proxy-option EXT1 "X-Online-Host: m.10010.com"' >ovpn.1
echo 写入代理端口 （$myip:8088）
sleep 2
echo http-proxy $myip 8080 >myip
cat ovpn.1 myip>ovpn.2
echo '########免流代码########
' >ovpn.3
cat ovpn.2 ovpn.3>ovpn.4
echo 写入OpenVPN端口 （$myip:3389）
echo remote $myip 3389 tcp-client >ovpn.5
cat ovpn.4 ovpn.5>ovpn.6
echo "写入中端代码"
sleep 2
echo 'resolv-retry infinite
nobind
persist-key
persist-tun

<ca>' >ovpn.7
cat ovpn.6 ovpn.7>ovpn.8
echo "写入CA证书"
sleep 2
cat ovpn.8 ca.crt>ovpn.9
echo '</ca>
key-direction 1
<tls-auth>' >ovpn.10
cat ovpn.9 ovpn.10>ovpn.11
echo "写入TLS密钥"
sleep 2
cat ovpn.11 ta.key>ovpn.12
echo "写入后端代码"
echo '</tls-auth>
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
' >ovpn.13
echo "生成OpenVPN.ovpn文件"
cat ovpn.12 ovpn.13>OpenVPN.ovpn
echo "配置文件制作完毕"
echo
sleep 3
clear
clear
echo 
echo "创建OpenVPN账号"
echo 
echo -n "输入新账号："
read ADMIN
echo -n "输入新密码："
read VPNPASSWD
echo $ADMIN $VPNPASSWD >/passwd
echo $ADMIN >00
echo $VPNPASSWD >11
echo '欢迎使用一键搭建OpenVPN环境
你的账号：' >50
echo '你的密码：' >51
echo '
创建账号命令：echo 账号 密码 >/passwd
示例：echo 123 456 >/passwd （即可创建 账号：123 密码：456）

删除账号命令：vi /passwd
输入 i 对文件进行修改，删除目标账号后，按 Esc 退出编辑，
并输入 :wq （保存退出）' >52
cat 50 00 51 11 52 >info.txt
echo 
echo "账号创建成功"
sleep 3
tar -zcvf openvpn.tar.gz ./{OpenVPN.ovpn,ca.crt,ta.key,info.txt}
rm -rf ./{00,11,50,51,52,ta.key,info.txt,myip,ovpn.1,ovpn.2,ovpn.3,ovpn.4,ovpn.5,ovpn.6,ovpn.7,ovpn.8,ovpn.9,ovpn.10,ovpn.11,ovpn.12,ovpn.13,ovpn.14,ovpn.15,ovpn.16,User01.ovpn,ca.crt,user01.{crt,key}}
clear
echo
# OpenVPN Installing ****************************************************************************
echo 
echo "正在生成下载链接："
echo 
sleep 2
echo '=========================================================================='
echo 
echo "上传证书文件："
curl --upload-file ./openvpn.tar.gz https://transfer.sh/openvpn.tar.gz
echo 
echo "上传成功"
echo "请复制“https://transfer.sh/..”链接到浏览器下载说明书/CA证书/OpenVPN成品配置文件"
echo 
echo '=========================================================================='
echo 
echo OpenVPN链接账号：$ADMIN
echo OpenVPN链接密码：$VPNPASSWD
echo 
echo 查看用户账号：cat /passwd
echo 账号/密码存放位置：/passwd
echo 
echo 您的IP是：$myip 
echo （如果检测结果与您实际IP不符合/空白，请自行修改OpenVPN.ovpn配置）
Client='
                             OpenVPN-2.3.10 安装完毕                                
                         Powered by Xiaoxia 2015-2016                     
                              All Rights Reserved                  
                                                                            
==========================================================================';
echo "$Client";
rm -rf /home/openvpn
