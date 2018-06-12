#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi


#install dependencies
yum install nfs-utils nfs-utils-lib


chkconfig nfs on 
service rpcbind start
service nfs start

read -p 'IP address/range to be served by NFS (example: 10.0.*.*): ' iprange

echo "/mnt           ${iprange}(rw,sync,no_root_squash,no_subtree_check,fsid=0)" >> /etc/exports
exportfs -a
