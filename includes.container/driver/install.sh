#! /bin/bash

#build version:1.2.1.2207

userinfo=`who`
#user=`who | awk  '{print $1}'|head -1`
user=`echo $( getent passwd $(who) | cut -d: -f6 ) | awk '{ print $1 }'`
echo $user


dirname=`dirname $0`
tmp="${dirname#?}"
if [ "${dirname%$tmp}" != "/" ]; then
	dirname=$PWD/$dirname
fi
echo $dirname
cd "$dirname"

appName=xencelabs

#Close driver if it running
pid=`ps -e|grep $appName|awk '{print $1}'`
if [ -n "$pid" ]; then
	echo "close $appName"
	kill -15 $pid
fi

#Copy rule
sysRuleDir="/lib/udev/rules.d"
appRuleDir=./App$sysRuleDir
ruleName="10-xencelabs.rules"

#echo "$appRuleDir/$ruleName"
#echo "$sysRuleDir/$ruleName"

if [ -f $appRuleDir/$ruleName ]; then
	str=`cp $appRuleDir/$ruleName $sysRuleDir/$ruleName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's rules in package"
	exit
fi

#install app
sysAppDir="/usr/lib"
appAppDir=./App$sysAppDir/$appName
exeShell="start.sh"
exeShell2="restar.sh"

#echo $sysAppDir
#echo $appAppDir

if [ -d "$appAppDir" ]; then
	str=`cp -rf $appAppDir $sysAppDir`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's files in package"
	exit
fi

if [ -f $sysAppDir/$appName/$exeShell ]; then
	str=`chmod +0755 $sysAppDir/$appName/$exeShell`
	str=`chmod +0755 $sysAppDir/$appName/$exeShell2`
	if [ "$str" !=  "" ]; then 
		echo "Cannot add permission to start script"
		echo "$str";
	fi
else
	echo "can not find start script"
	exit
fi

if [ -f $sysAppDir/$appName/$appName ]; then
	str=`chmod +0555 $sysAppDir/$appName/$appName`
	if [ "$str" !=  "" ]; then 
		echo "Cannot add permission to app"
		echo "$str";
	fi
else
	echo "can not find app"
	exit
fi

# install shortcut
sysDesktopDir=/usr/share/applications
sysAppIconDir=/usr/share/icons
sysAutoStartDir=/etc/xdg/autostart
systemddir=/etc/systemd/system

appDesktopDir=./App$sysDesktopDir
appAppIconDir=./App$sysAppIconDir
appAutoStartDir=./App$sysAutoStartDir
appsystemdDir=./App$systemddir

appDesktopName=$appName.desktop
appIconName=$appName.png


#echo $appDesktopDir/$appDesktopName
#echo $sysDesktopDir/$appDesktopName
#echo $appAppIconDir/$appIconName
#echo $sysAppIconDir/$appIconName

if [ -f $appDesktopDir/$appDesktopName ]; then
	str=`cp $appDesktopDir/$appDesktopName $sysDesktopDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's shortcut in package"
	exit

fi

if [ -f $appAppIconDir/$appIconName ]; then
	str=`cp $appAppIconDir/$appIconName $sysAppIconDir/$appIconName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find driver's icon in package"
	exit
fi

if [ -f $appAutoStartDir/$appDesktopName ]; then
	str=`cp $appAutoStartDir/$appDesktopName $sysAutoStartDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
else
	echo "Cannot find set auto start"
fi

#copy service file
cp $appsystemdDir/xencelabs.service $systemddir

#Copy config files
#sysAppDataDir=/home/$user/.local/share
sysAppDataDir=$user/.local/share
sysAppDataPath=$sysAppDataDir/$appName
appConfDir=$sysAppDir/$appName/config

if [ ! -d $sysAppDataPath ]; then
	mkdir $sysAppDataPath
	chmod +0777 $sysAppDataPath
fi

cp -r $appConfDir $sysAppDataPath
chmod 777 $sysAppDataPath/config
chmod +0777 $sysAppDataPath/config/language
chmod +0666 $sysAppDataPath/config/linuxConfig
chmod +0666 $sysAppDataPath/config/config.xml
chmod +0666 $sysAppDataPath/config/Template.xml
chmod +0777 $sysAppDataPath/config/Picture
chmod +0666 $sysAppDataPath/config/Picture/banner.png
chmod +0666 $sysAppDataPath/config/Picture/banner1.png
chmod +0666 $sysAppDataPath/config/Picture/banner2.png
chmod +0666 $sysAppDataPath/config/Picture/banner3.png
chmod +0666 $sysAppDataPath/config/language/ChineseSimplified.ini
chmod +0666 $sysAppDataPath/config/language/ChineseTraditional.ini
chmod +0666 $sysAppDataPath/config/language/English.ini
chmod +0666 $sysAppDataPath/config/language/French.ini
chmod +0666 $sysAppDataPath/config/language/German.ini
chmod +0666 $sysAppDataPath/config/language/Italian.ini
chmod +0666 $sysAppDataPath/config/language/Japanese.ini
chmod +0666 $sysAppDataPath/config/language/Korean.ini
chmod +0666 $sysAppDataPath/config/language/Polish.ini
chmod +0666 $sysAppDataPath/config/language/Russian.ini
chmod +0666 $sysAppDataPath/config/language/Spanish.ini

#多用户 
#change temp file permition
echo "change temp file permition"
localfile="/tmp/qtsingleapp-Xencel-fb8d-lockfile"
touch $localfile
sudo chmod 777 /tmp/qtsingleapp-Xencel-fb8d-lockfile

echo "Driver installed successfully, restart and use it please."

