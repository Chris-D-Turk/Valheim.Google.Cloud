#! /bin/bash
daemon_user=""
valheim_basedir=/home/$daemon_user/Steam/steamapps/common/Valheim\ dedicated\ server
valheim_pidfile=$valheim_basedir/valheim.pid
daemon_exec=/bin/bash
daemon_args=$valheim_basedir/start_server_custom.sh
