#! /bin/sh
### BEGIN INIT INFO
# Provides: magnolia
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Magnolia
# Description: This file starts and stops Magnolia server
# 
### END INIT INFO

MAGNOLIA_DIR=/opt/magnolia-enterprise-5.4.1/apache-tomcat-7.0.47

case "$1" in
 start)
   $MAGNOLIA_DIR/bin/magnolia_control.sh start
   ;;
 stop)
   $MAGNOLIA_DIR/bin/magnolia_control.sh stop
   sleep 10
   ;;
 restart)
   $MAGNOLIA_DIR/bin/magnolia_control.sh stop
   sleep 20
   $MAGNOLIA_DIR/bin/magnolia_control.sh start
   ;;
 *)
   echo "Usage: magnolia {start|stop|restart}" >&2
   exit 3
   ;;
esac