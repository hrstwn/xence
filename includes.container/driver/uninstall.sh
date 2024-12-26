#! /bin/bash

userinfo=`who`
#user=`who | awk  '{print $1}'|head -1`
user=`echo $( getent passwd $(who) | cut -d: -f6 ) | awk '{ print $1 }'`
echo $user

appName=xencelabs

#Close driver if it running
pid=`ps -e|grep $appName|awk '{print $1}'`
if [ -n "$pid" ]; then
	echo "close $appName"
	kill -15 $pid
fi

#uinstall rules
sysRuleDir=/lib/udev/rules.d
ruleName=10-xencelabs.rules

if [ -f $sysRuleDir/$ruleName ]; then
	str=`rm $sysRuleDir/$ruleName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

#uninstall app
sysAppDir=/usr/lib/$appName
if [ -d "$sysAppDir" ]; then
	str=`rm -rf $sysAppDir`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

#remove config files
sysAppDataDir=$user/.local/share/$appName/
echo "remove config files  $sysAppDataDir "

if [  -d $sysAppDataDir ]; then
	rm -rf $sysAppDataDir
fi

#uninstall shortcut
sysDesktopDir=/usr/share/applications
sysAppIconDir=/usr/share/icons
sysAutoStartDir=/etc/xdg/autostart

appDesktopName=$appName.desktop
appIconName=$appName.png
if [ -f "$sysDesktopDir/$appDesktopName" ]; then
	str=`rm $sysDesktopDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAppIconDir/$appIconName ]; then
	str=`rm $sysAppIconDir/$appIconName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAutoStartDir/$appDesktopName ]; then
	str=`rm $sysAutoStartDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

#xen服务文件删除
sudo rm /etc/systemd/system/xencelabs.service

#多用户文件删除
sudo rm /tmp/qtsingleapp-Xencel-fb8d-lockfile

echo "Driver uninstalled successfully."

