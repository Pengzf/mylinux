# mylinux

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function selectText( idt ){
var user=document.getElementById(idt);
user.select();
}
</script>
</head>
<body>
    <br>Nginx+Mproxy:<br>
<input type="text" id="txt" value="wget http://7xiu2o.com1.z0.glb.clouddn.com/svpn/svpn-ngm.sh && bash svpn-ngm.sh" onfocus="selectText('txt')" size="180"><br><br>
    <br>SSR:<br>
<input type="text" id="txt1" value="wget http://7xiu2o.com1.z0.glb.clouddn.com/SSR && bash SSR" onfocus="selectText('txt1')" size="180"><br><br>
    <br>SSR uninstall:<br>
<input type="text" id="txt2" value="wget http://7xiu2o.com1.z0.glb.clouddn.com/SSR && bash SSR uninstall" onfocus="selectText('txt2')" size="180"><br><br>
    <br>Centos 测网速:<br>
<input type="text" id="txt3" value="wget http://7xiu2o.com1.z0.glb.clouddn.com/test.sh && bash test.sh" onfocus="selectText('txt3')" size="180"><br><br>
    <br>端口查看命令:<br>
<input type="text" id="txt4" value="netstat -apn" onfocus="selectText('txt4')" size="180"><br><br>
    <br>SSR多用户配置:<br>
    文件路径： /etc/shadowsocks.json<br>
<textarea rows="20" cols="50" autofocus>
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "local_address": "127.0.0.1",
    "local_port": 443,
	"port_password":{
        "53":"WWW153",
        "137":"WWW153",
		"8080":"WWW153"
    },
    "timeout": 600,
    "udp_timeout": 60,
    "method": "chacha20",
    "protocol": "auth_sha1_compatible",
    "protocol_param": "",
    "obfs": "http_simple_compatible",
    "obfs_param": "",
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false,
    "workers": 1
}
</textarea>
<br><br>

</body>
</html>
