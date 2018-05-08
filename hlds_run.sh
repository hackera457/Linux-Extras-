 #!/bin/bash

# Script Settings
NAME='d2'
DESC='Dust2 Test Server'
HLDS_PATH='/home/hackera457/servers/d2'
CS_USER=root
DIR='/home/hackera457/servers/d2'
DAEMON=hlds_run
PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Server Settings
IP='192.168.0.170'
PORT='27015'
MAP='de_dust2'
GAME='cstrike'
PLAYERS='32'
TICRATE='1200'
PINGBOOST='3'
SVLAN='0'
RCON=''

# Server options string
OPT = '-game $GAME +ip $IP +maxplayers $PLAYERS +map $MAP -port $PORT +sv_lan $SVLAN +rcon_password $RCON +sys_ticrate $TICRATE -pingboost $PINGBOOST -master  -noipx -nojoy +log off'

case "$1" in
 start)
    if [ ! -z "$(pidof ./hlds_linux)" ]
       then
       echo "HLDS is already running!"
    else 
       echo "Starting $DESC: $NAME"
       su $CS_USER -c "cd $DIR; screen -m -d -S $NAME ./$DAEMON $OPT"
    fi
    ;;
 
 stop)
    if [ ! -z "$(pidof ./hlds_linux)" ]
       then
       echo -n "Stopping $DESC: $NAME"
       kill `ps aux | grep -v grep | grep -i $CS_USER | grep -i screen | grep -i $NAME | awk '{print $2}'`
       echo " ... done."
    else
       echo "Coulnd't find a running $DESC"
    fi
    ;;
 
 restart)
    if [ ! -z "$(pidof ./hlds_linux)" ]
       then
       echo -n "Stopping $DESC: $NAME"
       kill `ps aux | grep -v grep | grep -i $CS_USER | grep -i screen | grep -i $NAME | awk '{print $2}'`
       echo " ... done."
    else
       echo "Coulnd't find a running $DESC"
    fi
 
    echo -n "Starting $DESC: $NAME"
    su $CS_USER -c "cd $DIR; screen -m -d -S $NAME ./$DAEMON $OPT"
    echo " ... done."
    ;;
 
 status)
    ps aux | grep -v grep | grep hlds_r > /dev/null
    CHECK=$?
    [ $CHECK -eq 0 ] && echo "HLDS is UP" || echo "HLDS is DOWN"
    ;; 
 *)
    echo "Usage: $0 {start|stop|status|restart}"
    exit 1
    ;;
esac
 
exit 0


