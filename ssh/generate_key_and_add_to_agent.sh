#!/usr/bin/env bash
cd ~/.ssh 
eval `ssh-agent -s` >/dev/null # starts ssh-agent process
read -p 'filename of the key file: ' filename
read -p 'name on the public key: ' name
ssh-keygen -o -a 100 -t ed25519 -f ${filename} -C ${name} # generates ed25519 key
chmod 400 ${filename}
ssh-add ${filename}
echo "Public key:"; cat ${filename}.pub # echo public key