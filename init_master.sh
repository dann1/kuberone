#!/bin/bash

source $(dirname $0)/kuberone_common.sh

# Firewall
firewall_open_tcp_ports 6443 10252 10251 {2379..2380}

# Initialize cluster
kubeadmin init --pod-network-cidr=10.244.0.0/16 # HAcer un tail para guardar el join


# Install flannel CNI 
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml

# Load kubernetes config file
env_file=/etc/profile.d/k8s.sh
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> $env_file
chmod +x $env_file
. $env_file

# Remote kubectl
$master-ip=$1
echo -e "Run in the following in your workstation to remotely manage the kubernetes cluster \n\nscp root@$master ip:/etc/kubernetes/admin.conf . \nkubectl --kubeconfig ./admin.conf get nodes"