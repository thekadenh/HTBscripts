#!/bin/bash

function long_scan {
    echo "[INFO] Scanning $1, please wait..."
    ports=$(nmap -p- --min-rate=1000 -T4 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

    if [ $ports == "" ]; then
        echo "[ERR] No ports open..."
    else
        nmap -sC -sV -p$ports $1 -o nmap_scan.txt
    fi
};

function short_scan {
    echo "[INFO] Scanning ports only on $1, please wait..."
    nmap -p- --min-rate=1000 -T4 $1
};



echo "SHITTY AF NMAP SCANNER V 1.0"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <ip> [-s]"
    exit 1
fi


if [ $# == 2 ]; then
    if [ $2 != "-s" ]; then
        echo "[ERR] Unknown option $2. Only supported option is '-s'"
        exit 1
    else 
        short_scan $1
    fi
else 
    long_scan $1
fi

