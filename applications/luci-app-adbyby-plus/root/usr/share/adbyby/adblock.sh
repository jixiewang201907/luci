#!/bin/sh

newcount=0
oldcount=0
echo 开始下载规则
wget-ssl --no-check-certificate -O - 'https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt' > /tmp/adnew.conf
if [ -s "/tmp/adnew.conf" ];then
  /usr/share/adbyby/ad-update
  if [ -s "/tmp/ad.conf" ];then
  newcount=`cat /tmp/ad.conf | wc -l`
  echo 新规则数量为:$newcount
		if [ $newcount -ge 0 ];then
			if [ -s "/usr/share/adbyby/dnsmasq.adblock" ];then
				oldcount=`cat /usr/share/adbyby/dnsmasq.adblock | wc -l`
			else
				oldcount=0
			fi
			if [ $newcount -ne $oldcount ];then
				echo 开始更新规则
				cp -f /tmp/ad.conf /usr/share/adbyby/dnsmasq.adblock
				cp -f /tmp/ad.conf /tmp/etc/dnsmasq-adbyby.d/adblock
			else
			echo 当前已是最新规则
			fi
		fi
	fi
  rm -f /tmp/adbyby.updated
  sleep 10
  echo 重启adbyby
  /etc/init.d/adbyby restart
  rm -f /tmp/ad.conf
  echo 更新结束
fi
