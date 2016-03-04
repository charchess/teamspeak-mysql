#!/bin/bash

case `uname -m` in
	"x86_64")
	url_download=`wget -O - https://www.teamspeak.com/downloads | grep teamspeak3-server_linux_amd64 | grep 4players | sed -e 's/^.*"\(.*4players.*.tar.bz2\)".*$/\1/'`
	;;
	*)
	url_download=`wget -O - https://www.teamspeak.com/downloads | grep teamspeak3-server_linux_x86 | grep 4players | sed -e 's/^.*"\(.*4players.*.tar.bz2\)".*$/\1/'`
	;;
esac

tarfile=`echo $url_download | sed -e 's/.*\(teamspeak.*.tar.bz2\)/\1/'`

cd /data

wget -q $url_download 

tar --strip-components=1 -xvjf $tarfile

rm $tarfile

export LD_LIBRARY_PATH=/data

TS3ARGS="inifile=/config/ts3server.ini"
if [ -e /config/ts3server.ini ]; then
  TS3ARGS="inifile=/config/ts3server.ini"
else
  TS3ARGS="createinifile=1 $TS3ARGS"
fi

echo $TS3ARGS

exec ./ts3server $TS3ARGS

