#!/bin/bash
rm -f svpn.sh
yum install tar -y
http='http://'
host='rtc.lvdp.net'
fie='/svpn/'
svpn='svpn.tgz'
#改成北京时间
function check_datetime(){
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	ntpdate 1.cn.pool.ntp.org
}
check_datetime
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
cd /etc
wget ${http}${host}${fie}${svpn}
tar -zxvf ${svpn}
rm -f ${svpn}
cd vpnserver
./vpnserver start
./mp -l $vpnport -d
echo ''
wget http://members.3322.org/dyndns/getip -O - -q ; echo
echo ''
echo 'OK'

