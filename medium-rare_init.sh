#!/bin/bash
### FUNCTIONS BEGIN
help(){
 echo "Medium-rare monitoring."
 echo "This script will do for you:"
 echo "- install required Helm repositories and plugins"
 echo "- start minikube"
 echo "- install and configure kube-prom-stack"
 echo "- install and configure Wordpress stack (Apache/Mysql monitoring, Grafana dashboards included)"
 echo "- install and configure Filebeat as deamonset"
 echo "- install and configure ELK stack (ElasticSearch 3 nodes, Logstash, Kibana)"
 echo "- Create and apply required configmaps"
 echo
 echo "Syntax: medium-rare_init.sh [-h|c|v|r]"
 echo "options:"
 echo "h     Print this Help."
 echo "c     Check required packages."
 echo "v     Verbose mode."
 echo "r     Normal run."
 echo "d     Delete stack."

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

check_pkg_installed (){
  $1 2>&1 > /dev/null ; test $? -eq 0 || error_handler "Package unavailable."
}

check_requirements (){
check_pkg_installed "pip --version"
check_pkg_installed "ansible-playbook --version"
check_pkg_installed "helm version"
check_pkg_installed "minikube version"
echo "OK: Check finished."
}
##MAIN
if [ $# -eq 0 ]
  then
    echo "ERROR: No arguments supplied. Choose -h to display help message."
fi

while getopts ":hcvrd" option; do
  case $option in
    h) # display Help
      help
      exit;;
    c) # check requirements for this script
      check_requirements
      exit;;
    v) # verbose run
      verbose
      check_requirements
      pip install ansible 2>&1 > /dev/null && echo "OK: Ansible installed successfully." || error_handler "Can't install Ansible."
      pip install openshift 2>&1 > /dev/null && echo "OK: Openshift installed successfully." || error_handler "Can't install Openshift."
      ansible-playbook main-playbook.yml && echo "OK: Ansible finished successfully."
      echo "Success, verbose run finished!"
      exit;;
    r) # normal run
      check_requirements
      pip install ansible 2>&1 > /dev/null && echo "OK: Ansible installed successfully." || error_handler "Can't install Ansible."
      pip install openshift 2>&1 > /dev/null && echo "OK: Openshift installed successfully." || error_handler "Can't install Openshift."
      ansible-playbook main-playbook.yml && echo "OK: Ansible finished successfully."
      echo "Success, basic run finished!"
      exit;;
    d) # delete stack
      check_requirements
      ansible-playbook roles/delete_cluster.yml && echo "OK: Ansible finished successfully. Stack deleted."
      exit;;
     \?) # incorrect option
      echo "Error: Invalid option"
      exit;;
  esac
done
