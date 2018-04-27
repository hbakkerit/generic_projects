#!/usr/bin/env bash
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
intended_distro=\"Ubuntu\"
TEMP_INSTALL_DIR=/tmp

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Installing required packages..."
wget -NP ${TEMP_INSTALL_DIR} https://apt.puppetlabs.com/puppet5-release-xenial.deb && dpkg -i ${TEMP_INSTALL_DIR}/puppet5-release-xenial.deb 






rm -f ${TEMP_INSTALL_DIR}/puppet5-release-xenial.deb # cleanup
