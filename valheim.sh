#! /bin/bash
# copy this script to: /etc/init.d

### BEGIN INIT INFO
# Provides:          valheim server
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: valheim service
# Description:       Run Valheim service
### END INIT INFO

# load daemon parameters
. /etc/init.d/valheim_init.sh

# Define LSB log_* functions.
. /lib/lsb/init-functions

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    log_daemon_msg "Starting Valheim Daemon..."
    start-stop-daemon --start --background --chuid "$daemon_user:$daemon_user" --pidfile "$valheim_pidfile" --exec "$daemon_exec" -- -c "exec ${daemon_args// /\\ } 2>&1 | logger -i -t valheim-daemon"
    ;;
  stop)
    log_daemon_msg "Stopping Valheim Daemon..."
    start-stop-daemon --stop --retry=TERM/30/KILL/5 --pidfile "$valheim_pidfile" --exec "$daemon_exec"
    ;;
  *)
    log_daemon_msg "supported options: {start|stop}"
    exit 1
    ;;
esac

exit 0
