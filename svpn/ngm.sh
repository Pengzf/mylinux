#!/bin/bash
rm -f ngm.sh
yum install tar -y
http='http://'
host='rtc.lvdp.net'
fie='/svpn/'
ngm='ngm.tgz'
echo
echo -e "\033[43;37m请设置mproxy端口：\033[0m"
echo 
echo -n -e "输入mproxy端口（默认8068）：\033[33m【温馨提示:回车默认8068！！！】\033[0m:" 
read port 
if [[ -z $port ]] 
then 
echo -e "\033[34m已设置mproxy端口：8068\033[0m"
port=8068
else 
echo -e "\033[34m已设置mproxy端口：$port\033[0m"
fi 
#安装nginx+mproxy
cd /usr/local
wget ${http}${host}${fie}${ngm}
tar -zxvf ${ngm}
rm -f ${ngm}
./nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
./nginx/mproxy -l $port -d
echo ''
wget http://members.3322.org/dyndns/getip -O - -q ; echo
echo ''
echo 'OK'
