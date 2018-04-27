#!/usr/bin/env bash
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
intended_distro=\"Ubuntu\"
TEMP_INSTALL_DIR=/tmp

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Installing required packages..." && apt-add-repository -y ppa:ansible/ansible && apt-get update -y && apt-get install -y software-properties-common ansible

grep -q -F "APP=" /etc/environment || echo "APP=Ansible" >> /etc/environment # creating a tag
