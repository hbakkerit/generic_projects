# awesome shebang
#!/usr/bin/env bash


# checks
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then echo "This script must be run in a bash shell of version 4.0 or higher"; exit 1; fi # checks whether the bash version used is 4.0 or higher
if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu


# collect user input
read -p 'fully qualified domain name: ' fqdn
echo ${fqdn}
