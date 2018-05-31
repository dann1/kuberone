#!/bin/bash

node_out=$1

kubectl drain $node_out --delete-local-data --force --ignore-daemonsets
kubectl delete node $node_out