#!/bin/bash

source $(dirname $0)/kuberone_common.sh

# Firewall
firewall_open_tcp_ports 10250 10255

# Configure kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Allow cotainers to acces host filesystem
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

# Disable Swap
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

# Fix container traffic being routed incorrectly
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Install software
yum update -y
yum install -y docker kubelet kubeadm kubectl kubernetes-cni

systemctl enable kubelet && systemctl start kubelet
systemctl enable docker && systemctl start docker

# Contexting
master_hostname=$1
master_ip_address=$2

hostnamectl --static set-hostname $master_hostname 
echo "$master_ip_address		$master_hostname" >> /etc/hosts
