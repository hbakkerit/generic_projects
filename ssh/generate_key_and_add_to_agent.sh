#!/usr/bin/env bash
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

cd ~/.ssh 
eval `ssh-agent -s` # starts ssh-agent process
read -p 'filename of the key file: ' filename
ssh-keygen -o -a 100 -t ed25519 -f ${filename} # generates ed25519 key
chmod 400 ${filename}
ssh-add ${filename}
echo "Public key:"
cat ${filename}.pub