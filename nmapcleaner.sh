#!/bin/bash
if [ -z "$1" ]; then
	echo "[*] Greppable NMAP Cleaner"
	echo "[*} Usage: $0 <greppable scan>"
	exit 0
fi

sed -i  '/Status:/d;s/\/\/\//\n/g;s/Ports:/\nPorts:\n*/g;s/Host:/\nHost:/g;s/,/*/g' $1
