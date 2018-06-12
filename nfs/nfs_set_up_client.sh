#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi


#install dependencies
yum install nfs-utils nfs-utils-lib

read -p 'IP address of NFS server: ' serverip
read -p 'Mountpoint on server (example:/mnt): ' servermountpoint
read -p 'Local mountpoint (example: /mnt/nfs): ' localmountpoint

mkdir -p ${localmountpoint}
mount ${serverip}:${servermountpoint} ${localmountpoint}
