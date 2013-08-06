#!/bin/bash

mybackupname="backup-fullsys-$(date +%Y-%m-%d).tar.gz"

# Record start time by epoch second
start=$(date '+%s')

# List of excludes in a bash array, for easier reading.
excludes=(--exclude=/$mybackupname)
excludes+=(--exclude=/proc)
excludes+=(--exclude=/lost+found)
excludes+=(--exclude=/sys)
excludes+=(--exclude=/mnt)
excludes+=(--exclude=/media)
excludes+=(--exclude=/dev)

if ! tar -czf "$mybackupname" "${excludes[@]}" /; then
  status="tar failed"
elif ! mv "$mybackupname" backups/filesystem/ ; then
  status="mv failed"
else
  status="success: size=$(stat -c%s backups/filesystem/$mybackupname) duration=$((`date '+%s'` - $start))"
fi

# Log to system log; handle this using syslog(8).
logger -t backup "$status"

curl -T mybackupname http://www.softwareonrails.com
