#!/bin/bash

source $(dirname $0)/kuberone_common.sh

# Firewall ver el argumento del multiport
firewall_open_tcp_ports {30000..32767}

# Join node to master 
kubeadmin_command=$1
exec $kubeadmin_command