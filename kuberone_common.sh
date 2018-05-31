#!/bin/bash

function firewall_open_tcp_ports {
	# pass ports as a list
	for i in "$@"; do
		iptables -A INPUT -m multiport -p tcp --dports $i -j ACCEPT
	done
	iptables-save
}