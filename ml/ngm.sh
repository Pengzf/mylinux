#!/bin/bash
http='https://'
host='raw.githubusercontent.com/Pengzf/mylinux/master'
fie='/ml/'
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
echo "==============================="
echo "       一键搭nginx+mproxy       "
echo " "
echo "==============================="
yum install -y tar
yum install -y gcc gcc-c++ readline-devel pcre-devel openssl-devel tcl perl
sleep 0.2
cd /etc
wget ${http}${host}${fie}.nginx
wget ${http}${host}${fie}nginx.conf
sleep 0.2
cd
sleep 0.2
wget ${http}${host}${fie}nginx-1.9.9.tar.gz
tar zxvf nginx-1.9.9.tar.gz
cd nginx-1.9.9
./configure
make && make install
echo "    "
echo "          开始配置启动服务...."
echo "    "
sleep 1
cp -f /etc/.nginx /etc/rc.d/init.d/nginx
chmod 775 /etc/rc.d/init.d/nginx
chkconfig  --level 012345 nginx on
service nginx start
echo "    "
echo "          开始配置nginx文件...."
echo "    "
sleep 1
rm -f /usr/local/nginx/conf/nginx.conf
sleep 0.2
cp -f /etc/nginx.conf /usr/local/nginx/conf/
service nginx restart
sleep 2
cd /etc
wget ${http}${host}${fie}.mproxy
sleep 0.5
mv .mproxy mproxy
chmod 777 mproxy
sleep 0.5
/etc/mproxy -l 8068 -d
echo "  "
echo "          出现三个OK 则搭建成功！！！"
echo "  "
sleep 2
cd
rm -f nginx-1.9.9.tar.gz
rm -f /etc/.nginx
rm -f /etc/nginx.conf
rm -f ngm.sh
