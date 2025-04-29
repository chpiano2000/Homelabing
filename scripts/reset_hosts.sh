#!/usr/bin/env bash

for val in 192.168.56.11 192.168.56.12 192.168.56.13; do 
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$val"
done
