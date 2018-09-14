#!/usr/bin/env bash

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Prerequisites: "
echo "- an existing terraform configuration repository (git), containing .tf terraform configuration files"
echo "- a Digital Ocean Personal Access Token"
echo ""
echo "Press any key to continue.."
read

# make all scripts executable
chmod 750 ./*.sh

# install terraform
./install_terraform.sh

# generate ssh key
./generate_ssh_key.sh

# configure terraform for digital ocean
./configure_terraform_for_digital_ocean.sh