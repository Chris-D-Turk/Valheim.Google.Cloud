#!/bin/bash
# copy this script to: home\[user]\Steam\steamapps\common\Valheim dedicated server

# doesn't work: basename $BASH_SOURCE
script_name=start_server.sh

function log {
    echo "[$script_name] $1"
}

function handle_interrupt {
    log "Received interrupt signal"
}

function perform_backup {
    log "Performing worlds backup..."

    backupdate=$(date "+%Y.%m.%d_%H.%M.%S")
    backupzip=worlds.backup.$backupdate.zip

    pushd ~/.config/unity3d/IronGate/Valheim
    zip -r $backupzip worlds_local
    mega-login $mega_session
    mega-put $backupzip $backup_remote_dir
    rm $backupzip
    popd
}

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

# startup arguments
cd ~/Steam/steamapps/common/Valheim\ dedicated\ server
. ./start_server_custom_init.sh

if [[ $auto_update = "true" ]]; then
    log "Updating Valheim Dedicated Server..."
    ~/Steam/steamcmd.sh +login anonymous +app_update 896660 +quit
fi

if [[ $crossplay = "true" ]]; then
    crossplay_arg = "-crossplay"
fi

log "Initialising noip.com DynDNS..."
sudo noip2

pidfile=valheim.pid
log "Writing PID $$ to $pidfile..."
echo $$ > $pidfile

trap "handle_interrupt" SIGINT SIGTERM

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
log "Starting server PRESS CTRL-C to exit"
./valheim_server.x86_64 -name "$server_name" -port 2456 -world "$world_name" $crossplay_arg -password "$server_password" & serverpid=$!

log "Server-PID is $serverpid"

log "Waiting for interrupt signal..."
wait

log "Interrupting server..."
kill -SIGINT $serverpid
wait $serverpid

export LD_LIBRARY_PATH=$templdpath

if [[ $backup_enabled = "true" ]]; then
    perform_backup
fi

log "Deleting $pidfile"
rm $pidfile

log "Done"