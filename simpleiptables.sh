#Very simple iptables script because syntax...
#run this as root, it will wipe your rules. be sure to save them afterwards
#!/bin/bash
read -p 'Type 1 to Start Fresh :: 2 to Insert ' choice
if [ $choice -eq 1 ]
then
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
fi

if [ $choice -eq 2 ]
then
while true;
do
	read -p 'tcp/udp: ' type
	read -p 'Port: ' port
	iptables -I INPUT 2 -p $type --dport $port -j ACCEPT
done
fi 
