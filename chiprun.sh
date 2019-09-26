#!/usr/bin/env bash

BASE_PATH=$(cd `dirname $0`; pwd)
ipfile=/var/log/myip
get_myip_url="https://bot.whatismyipaddress.com/"

run(){
	echo "运行代码"
	systemctl restart shadowsocks
}

update_ip(){
	myip=$(curl -s $get_myip_url)
	echo $myip > $ipfile
}

if [ -f $ipfile ]; then
	old_ip=$(cat $ipfile)
else
	update_ip
	echo "第一次运行"
	exit 0
fi

myip=$(curl -s $get_myip_url)

if [[ $myip != $old_ip ]]; then
	echo "IP改变"
	update_ip
	run
else
	echo "IP相同"
fi