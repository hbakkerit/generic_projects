#!/usr/bin/env bash
cd ~/.ssh
read -p 'filename of the key file: ' filename
ssh-keygen -o -a 100 -t ed25519 -f ${filename}
ssh-add ${filename}