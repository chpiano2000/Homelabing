#!/usr/bin/env bash

# Distribute ssh key across nodes

SSH_KEY="$HOME/.ssh/id_rsa"
PASSWORD="$VAGRANT_PASSWORD"

for val in controller worker1 worker2; do 
	echo "-------------------- COPYING KEY TO ${val^^} NODE ------------------------------"
	sshpass -p $PASSWORD ssh-copy-id -i $SSH_KEY -o "StrictHostKeyChecking=no" -f vagrant@$val
done

