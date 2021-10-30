#!/bin/bash

# Long scan, which does more to get more info out of the target
function long_scan {
    echo "[INFO] Scanning $TARGET, please wait..."
    ports=$(nmap -p- -T4 $TARGET | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

    if [  -z "$ports" ]; then
        echo "[ERR] No ports open..."
    else
        nmap -sC -sV -A -T4 -p$ports $1 -o nmap_scan.txt
    fi
};

# short scan, which tries to go as fast as possible
function short_scan {
    echo "[INFO] Scanning ports only on $TARGET, please wait..."
    nmap -sU -sS -sC -sV -A -p- -T4 $TARGET -o nmap_scan.txt
    #nmap -sC -sV -sU -A -p- -T4 $1 -o nmap_scan_udp.txt
};

# scans only for UDP ports
function udp_scan {
    echo "[INFO] Scanning for UDP ports only on $TARGET, please wait..."
    nmap -sU -sS -A $TARGET 
}

# prints help and exits
function print_help {
    echo "Usage: $0 <ip> [-slu]"
    exit 1
};






echo "SHITTY AF NMAP SCANNER V 1.2"
LONG_SCAN=false
SHORT_SCAN=false
UDP_SCAN=false

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -l|--long)
      LONG_SCAN=true
      shift # past argument
      ;;
    -s|--short)
      SHORT_SCAN=true
      shift # past argument
      ;;
    -u|--udp)
      UDP_SCAN=true
      shift # past argument
      ;;
    -i|--ip)
      TARGET="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      print_help
      # print_help exits
      ;;
    *)    # unknown option
      echo "[ERR] Unknown option $2. Use '-h' for arguments"
      exit 1
      ;;
  esac
done


if [ -z "$TARGET" ]; then
    echo "[ERR] No target provided. Use '-i'"
    exit 1
fi

if [ "$LONG_SCAN" = true ]; then
    long_scan 
elif [ "$SHORT_SCAN" = true ]; then
    short_scan
elif [ "$UDP_SCAN" = true ]; then
    udp_scan
else
    echo "[ERR] No scan type provided. Use '-h' for info"
    exit 1
fi