#!/usr/bin/env bash

# check if user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# check if bash version is greater than 4
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
   echo "This script must be run in a bash shell of version 4.0 or higher" 
   exit 1
fi

# collect user input
read -p 'fully qualified domain name: ' fqdn
read -p 'username: ' username
read -p 'file server name: ' fileserver
read -p 'share name: ' sharename
read -sp "enter password for $username: " password

echo ""
echo using the following details:
echo fqdn: ${fqdn^^} user: $username fileserver: $fileserver share: $sharename

# installing necessary packages noninteractively
apt-get install -y krb5-user keyutils >> /dev/null

# create keytab entry for user and keytab file to cache credentials
ktutil < <(echo -e "add_entry -password -p $username@${fqdn^^} -k 1 -e aes256-cts-hmac-sha1-96\n$password\nlist\nwrite_kt /etc/$username.keytab")

# requesting ticket using the credentials from the keytab file
kinit $username@${fqdn^^} -k -t /etc/$username.keytab

# mounting a share using cifs
mount -t cifs -o cruid=$USER,username=$username,domain=${fqdn^^},sec=krb5 //$fileserver.${fqdn^^}/$sharename /mnt/$sharename
