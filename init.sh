#!/bin/bash
### VARS
ANSIBLE_PLAYBOOK="/usr/bin/ansible-playbook"
PIP="/usr/local/bin/pip"

### FUNCTIONS BEGIN
help(){
 echo "Wordpress monitoring."
 echo "This script will do for you:."
 echo "- create flavors"
 echo "- create host aggregates"
 echo "- configure properties"
 echo "- configure aggregate properties"
 echo "- add hypervisors to specific aggregates"
 echo "- create volume types"
 echo "- create volume QoS profiles"
 echo "- associate volumes to QoS profiles"
 echo
 echo "Syntax: openstack_configurator.sh [-h|v|r|d]"
 echo "options:"
 echo "h     Print this Help."
 echo "v     Verbose mode."
 echo "r     Basic run mode."
 echo "d     Only delete flavors."
 echo
}

verbose(){
  set -x
}
error_handler() {
 echo "Error: $1"
 ask_for_input
}

ask_for_input (){
  while true; do
    read -p "Last command failed. Do you want to continue? [y/n]" yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit 1;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}



${PIP} install ansible 2>&1 > /dev/null && echo "OK: Ansible installed successfully." || error_handler "Can't install Ansible."
${PIP} install openshift 2>&1 > /dev/null && echo "OK: Openshift installed successfully." || error_handler "Can't install Openshift."
#${ANSIBLE_PLAYBOOK} main-playbook.yml --ask-become-pass
${ANSIBLE_PLAYBOOK} main-playbook.yml 
