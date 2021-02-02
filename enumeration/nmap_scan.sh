#!/bin/bash


echo "SHITTY AF NMAP SCANNER V 1.0"

if [ $# != 1 ]; then
    echo "Usage: $1 <ip>"
    exit 1
fi

echo "Scanning $1, please wait..."
ports=$(nmap -p- --min-rate=1000 -T4 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

if [ $ports == "" ]; then
  echo "No ports open..."
else
  nmap -sC -sV -p$ports $1
fi
