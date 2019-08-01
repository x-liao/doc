#!/usr/bin/env bash

BASE_PATH=$(cd `dirname $0`; pwd)

check_release(){
	release=$(cat /etc/issue | awk '{print $3}')
	case "${release}" in
		7)
		release="wheezy"
		;;
		8)
		release="jessie"
		;;
		9)
		release="stretch"
		;;
	esac
}

check_sys(){
	local issue=`cat /etc/issue`
	local version=`cat /proc/version`
	if [[ -f /etc/redhat-release ]]; then
		sys="centos"
		echo "不适用于 ${sys}" && exit 1
	elif echo $issue | grep -q -E -i "debian"; then
		sys="debian"
		check_release
	elif echo $issue | grep -q -E -i "ubuntu"; then
		sys="ubuntu"
	elif echo $issue | grep -q -E -i "centos|red hat|redhat"; then
		sys="centos"
		echo "不适用于 ${sys}" && exit 1
	elif echo $version | grep -q -E -i "debian"; then
		sys="debian"
		check_release
	elif echo $version | grep -q -E -i "ubuntu"; then
		sys="ubuntu"
	elif echo $version | grep -q -E -i "centos|red hat|redhat"; then
		sys="centos"
		echo "不适用于 ${sys}" && exit 1
	else
		echo "不知道什么系统"
		exit 1
    fi
	sys_bit=`uname -m`
}

check_sys

wget "https://repo.zabbix.com/zabbix/4.2/${sys}/pool/main/z/zabbix-release/zabbix-release_4.2-1+${release}_all.deb" -O /root/zabbix-release_4.2-1+${release}_all.deb

dpkg -i /root/zabbix-release_4.2-1+${release}_all.deb
apt update
apt -y install zabbix-agent
systemctl enable zabbix-agent