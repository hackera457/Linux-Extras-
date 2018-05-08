 #!/bin/sh
    ### BEGIN INIT INFO
    # Provides:          csservers
    # Required-Start:    $remote_fs $syslog
    # Required-Stop:     $remote_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Start daemon at boot time
    # Description:       Enable service provided by daemon.
    ### END INIT INFO
    # This script edit by kostov[Virtual.New.BG]
    # Server options
    TITLE='Dedicated Server'
    SESSION='hlds'
    DAEMON='hlds_run'
    DIR='/home/hackera457/servers/d2'
    USER='root'

    # Game options
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
    OPTS="-game $GAME +ip $IP +maxplayers $PLAYERS +map $MAP -port $PORT +sv_lan $SVLAN +rcon_password $RCON +sys_ticrate $TICRATE -pingboost $PINGBOOST -master  -noipx -nojoy +log off -pidfile $DIR/$GAME/$SESSION.pid"

    # Screen command
    CURRENT_USER=$(/usr/bin/whoami)
    if [ "$CURRENT_USER" = "$USER" ]; then
        INTERFACE="/usr/bin/screen -A -m -d -S $SESSION"
      else
        INTERFACE="sudo -u $USER /usr/bin/screen -A -m -d -S $SESSION"
    fi

    service_start() {
        if [ -f $DIR/$GAME/$SESSION.pid ] || [ -f $DIR/$GAME/$SESSION-screen.pid ]; then
            if [ "$(ps -p `cat $DIR/$GAME/$SESSION.pid` | wc -l)" -gt 1 ]; then
                echo -e "Cannot start $TITLE.  Server is already running."
            else
                if [ "$(ps -p `cat $DIR/$GAME/$SESSION.pid` | wc -l)" -gt 1 ]; then
                    kill -9 `cat $DIR/$GAME/$SESSION-screen.pid`
                    echo "Killing process ID $id"
                    echo "Removing $TITLE screen pid file"
                    rm -rf $DIR/$GAME/$SESSION-screen.pid
       break
                fi
       if [ -f $DIR/$GAME/$SESSION-screen.pid ]; then
       rm -rf $DIR/$GAME/$SESSION-screen.pid
       fi
            echo "Removing $TITLE pid file"
            rm -rf $DIR/$GAME/$SESSION.pid
            screen -wipe 1> /dev/null 2> /dev/null
            service_start
            fi
        else
            if [ -x $DIR/$DAEMON ]; then
                echo "Starting $TITLE"
                cd $DIR
                $INTERFACE $DIR/$DAEMON $OPTS
                sleep 15
                ps -ef | grep SCREEN | grep "$SESSION" | grep -v grep | awk '{ print $2}' > $DIR/$GAME/$SESSION-screen.pid
                echo "$TITLE screen process ID written to $DIR/$GAME/$SESSION-screen.pid"
                echo "$TITLE server process ID written to $DIR/$GAME/$SESSION.pid"
               
                echo "$TITLE started."
                chmod 666 $DIR/$GAME/*.pid #1> /dev/null 2> /dev/null
                chown $USER $DIR/$GAME/*.pid #1> /dev/null 2> /dev/null
                sleep 15
            fi
        fi
    }

    service_stop() {
        if [ -f $DIR/$GAME/$SESSION.pid ] || [ -f $DIR/$GAME/$SESSION-screen.pid ]; then
            echo "Stopping $TITLE"
            for id in `cat $DIR/$GAME/$SESSION-screen.pid`
                do kill -9 $id
                echo "Killing process ID $id"
                echo "Removing $TITLE screen pid file"
                rm -rf $DIR/$GAME/$SESSION-screen.pid
                break
            done
            echo "Removing $TITLE pid file"
            rm -rf $DIR/$GAME/$SESSION.pid
            screen -wipe 1> /dev/null 2> /dev/null
            echo "$TITLE stopped."
        else
            echo -e "Cannot stop $TITLE. Server is not running."
        fi   
    }


    service_watch() {
            if [ `screen -wipe | grep $SESSION | grep -v grep | awk '{ print $2 }'` == '(Attached)' ]; then
                    echo -e "Someone is already attached to the console of the server.\n Might want to check who"
            else
                    screen -r $SESSION
            fi
    }


    case "$1" in
        'start')
            service_start
            ;;
        'stop')
            service_stop
            ;;
        'restart')
            service_stop
            sleep 10
            service_start
            ;;
       'watch')
          service_watch
          ;;
        *)
            echo "Usage $0 start|stop|restart|watch"
    esac

    exit 0
