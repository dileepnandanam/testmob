#!/bin/bash
# chkconfig: 2345 20 80
# description: Description comes here....

CMD="python3.7 /home/sastra_admin/quaco_web/vision_server/vision_server.py"
PIDFILE="/home/sastra_admin/quaco_web/shared/pids/vision.pid"
PATH="$PATH:/home/sastra_admin/.local/bin:/home/sastra_admin/.rbenv/shims:/home/sastra_admin/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

start() {
   CMD="$CMD &> /home/sastra_admin/quaco_web/shared/log/vision.log & echo \$!"
   su -c "$CMD" sastra_admin > $PIDFILE
}

stop() {
   kill $(cat "$PIDFILE")
}

case "$1" in
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
       # code to check status of app comes here
       # example: status program_name
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0