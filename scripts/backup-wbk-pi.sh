#!/bin/bash

set -xe

exec &> >(tee | logger -t pi-backup)

while ! mkdir /tmp/backup-pi; do
    echo "Waiting for the previous backup to be over"
    sleep 5
done

trap 'rmdir /tmp/backup-pi' EXIT

echo Starting backup. Moving the old backup.

ssh wbk@192.168.0.164 "mv /mnt/nas/wbk-pi/root.tar.gz{,.old}"

echo Now actually copying
sudo tar cvzf - / --one-file-system | ssh wbk@192.168.0.164 "cat > /mnt/nas/wbk-pi/root.tar.gz.wip" 
ssh wbk@192.168.0.164 "mv /mnt/nas/wbk-pi/root.tar.gz{.wip,}"

rmdir /tmp/backup-pi
