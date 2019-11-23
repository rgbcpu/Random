#!/bin/bash
STATUS=1
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
while true;
do
	read -p 'tcp/udp: ' type
	read -p 'Port: ' port
	iptables -A INPUT -p $type --dport $port -j ACCEPT
done
iptables -P INPUT DROP
