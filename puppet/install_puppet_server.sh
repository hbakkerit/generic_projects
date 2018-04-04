#!/usr/bin/env bash
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
intended_distro=\"Ubuntu\"
TEMP_INSTALL_DIR=/tmp

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Installing required packages..."
wget -NP ${TEMP_INSTALL_DIR} https://apt.puppetlabs.com/puppet5-release-xenial.deb && dpkg -i ${TEMP_INSTALL_DIR}/puppet5-release-xenial.deb && apt-get update -y && apt-get install -y puppetserver

grep -q -F "APP=" /etc/environment || echo "APP=Puppet" >> /etc/environment # creating a tag

read -e -p 'please provide the maximum memory allocation pool (Xmx) for puppet: ' -i "512m" XMX
sed -i -e "s/-Xmx2g/-Xmx${XMX}/g" /etc/default/puppetserver # setting Xmx property
read -e -p 'please provide the initial memory allocation pool (Xms) for puppet: ' -i "512m" XMS
sed -i -e "s/-Xms2g/-Xms${XMS}/g" /etc/default/puppetserver # setting Xms property

echo "starting service (this may take some time)" && service puppetserver start
service puppetserver status # verification

rm -f ${TEMP_INSTALL_DIR}/puppet5-release-xenial.deb # cleanup
