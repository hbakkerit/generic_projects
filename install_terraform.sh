#!/usr/bin/env bash
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
intended_distro=\"Ubuntu\"
TERRAFORM_VERSION=0.11.5
TERRAFORM_ARCHITECTURE=amd64
TERRAFORM_HOME=/bin
TEMP_INSTALL_DIR=/tmp

# check if the distro is Ubuntu
if [[ ${distro} != ${intended_distro} ]]; then
  echo "This script should run on the Ubuntu distribution" 
  exit 1
fi

# check if user is root
if [[ ${EUID} -ne 0 ]]; then
  echo "This script must be run as root" 
  exit 1
fi

# install basic packages
echo "Updating packages..."
#apt-get update -y
echo "Installing basic packages..."
apt-get install -y wget unzip

# install terraform
wget -NP ${TEMP_INSTALL_DIR} https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip
unzip -o ${TEMP_INSTALL_DIR}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip -d ${TERRAFORM_HOME}
#export PATH=$PATH:${TERRAFORM_HOME}

# verify
echo""
terraform --version

# cleanup
rm -f ${TEMP_INSTALL_DIR}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip
