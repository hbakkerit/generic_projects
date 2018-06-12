# awesome shebang
#!/usr/bin/env bash


# check if user is root
if [[ $EUID -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi

# check if bash version is greater than 4 (useful for some commands)
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then echo "This script must be run in a bash shell of version 4.0 or higher"; exit 1; fi

# collect user input
read -p 'fully qualified domain name: ' fqdn
echo ${fqdn}
