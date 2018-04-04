#!/usr/bin/env bash
TERRAFORM_HOME=/opt/terraform
TERRAFORM_CONFIG_SUBDIR=config

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Updating packages..." && apt-get update -y
echo "Installing basic packages..." && apt-get install -y git

read -p 'please input your Terraform configuration repository (git): ' TERRAFORM_CONFIG_REPO
read -p 'please input your Digital Ocean Personal Access Token: ' DO_PAT 
read -e -p 'please input the path of your public key file: ' -i "/${USER}/.ssh/id_ed25519.pub" PUB_KEY_FILE

### if Personal Access Token is not in environment file, append it
grep -q -F "DO_PAT=${DO_PAT}" /etc/environment || echo "DO_PAT=${DO_PAT}" >> /etc/environment

## collect pubkey finderprint
SSH_FINGERPRINT=$(ssh-keygen -E md5 -l -f ${PUB_KEY_FILE} | awk '{gsub("MD5:", "");print $2}')
### if fingerprint is not in environment file, append it
grep -q -F "SSH_FINGERPRINT=${SSH_FINGERPRINT}" /etc/environment || echo "SSH_FINGERPRINT=${SSH_FINGERPRINT}" >> /etc/environment

git clone ${TERRAFORM_CONFIG_REPO} ${TERRAFORM_HOME}/${TERRAFORM_CONFIG_SUBDIR}
cd ${TERRAFORM_HOME}/${TERRAFORM_CONFIG_SUBDIR} && terraform init
