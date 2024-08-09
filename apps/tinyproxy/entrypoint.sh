#!/usr/bin/env bash
set -e

cat > /etc/resolv.conf <<EOF
search cluster.local
nameserver 1.1.1.1
EOF

TP_CONF="/etc/tinyproxy/tinyproxy.conf"

: ${LISTEN_PORT:=8888}
: ${ALLOWED:="127.0.0.1"}
: ${CONNECT_PORTS:="443 563"}
: ${LOG_TO_SYSLOG:="Yes"}
: ${LOG_LEVEL:="Info"}
: ${MAXCLIENTS:="100"}

if [[ ! -f $TP_CONF ]]
 then
	cat > $TP_CONF <<EOF
User kah
Group kah
Port $LISTEN_PORT
Syslog $LOG_TO_SYSLOG
LogLevel $LOG_LEVEL
PidFile "/tmp/tinyproxy.pid"
XTinyproxy Yes
MaxClients $MAXCLIENTS
PidFile "/tmp/tinyproxy.pid"
XTinyproxy Off 
DisableViaHeader On
EOF

for a in $ALLOWED
 do
	echo "Allow $a" >> $TP_CONF
done

for p in $CONNECT_PORTS
 do
	echo "ConnectPort $p" >> $TP_CONF
done
fi

exec /usr/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d 2>&1
