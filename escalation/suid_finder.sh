#!/bin/bash

echo "Shitty SUID/SGUID binary script V 1.0"

# look for SUID from root
echo "[INFO] Searching SUID binaries..."
find / -type f -perm 2000 2> /dev/null

echo "--------------------------------------------------------------------"

# look for SGUID from root
echo "[INFO] Searching SGUID binaries..."
find / -type f -perm 4000 2> /dev/null

echo "[INFO] Complete. Happy hunting :)"
