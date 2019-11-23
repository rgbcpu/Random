#!/bin/bash

chmod 700 /root
unalias -a
echo "Making backup of sysctl.conf"
cp /etc/sysctl.conf /etc/sysctl.bk

echo "Baking up some better kernel policies for you. =)"
cat _src/sysctl >> /etc/sysctl.conf
sysctl -p

#disable zeroconf networking
echo "ZeroConf Disable"
echo "NOZEROCONF=yes" >> /etc/sysconfig/network

#prune idle users/// 5 minutes till a timeout
echo "Time to set timeout for baddie idle users... 5 Minutes"
echo "readonly TMOUT=300" >> /etc/profile.d/os-security.sh
echo "readonly HISTFILE" >> /etc/profile.d/os-security.sh
chmod +x /etc/profile.d/os-security.sh

echo "Cleaning /home/..."
sudo find /home -iname "*.mp3" -delete
sudo find /home -iname "*.jpg" -delete
sudo find /home -iname "*.png" -delete
sudo find /home -iname "*.mp4" -delete

echo "Since u lazy I do firewall"
yum install iptables-services
service iptables start
service iptables enable
iptables -F
iptables -A INPUT -m state --state ESTABLISHED, RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -P INPUT DROP
service ip6tables start
service ip6tables enable
ip6tables -F
ip6tables -P INPUT DROP
service iptables save
service ip6tables save


chkconfig xinetd off
chkconfig rexec off
chkconfig rsh off
chkconfig rlogin off
chkconfig ypbind off
chkconfig tftp off
chkconfig certmonger off
chkconfig cgconfig off
chkconfig cgred off
chkconfig cpuspeed off
chkconfig irqbalance on
chkconfig kdump off
chkconfig mdmonitor off
chkconfig messagebus off
chkconfig netconsole off
chkconfig ntpdate off
chkconfig oddjobd off
chkconfig portreserve off
chkconfig psacct on
chkconfig qpidd off
chkconfig quota_nld off
chkconfig rdisc off
chkconfig rhnsd off
chkconfig rhsmcertd off
chkconfig saslauthd off
chkconfig smartd off
chkconfig sysstat off
chkconfig atd off
chkconfig nfslock off
chkconfig named off
chkconfig dovecot off
chkconfig squid off
chkconfig snmpd off
chkconfig auditd on
cp /etc/audit/audit.rules /opt/rev
cat auditrules > /etc/audit/audit.rules
service auditd start
chkconfig --level 0123456 restorecond on
service restorecond restart
	
yum remove xinetd
yum remove tftp-server
yum remove telnet-server
yum remove rsh-server
yum remove telnet
yum remove rsh-server
yum remove rsh
yum remove ypbind
yum remove ypserv
yum remove bind
yum remove vsftpd
yum remove dovecot
yum remove squid
yum remove net-snmpd

# Configure Aide
#
if grep -q ^PRELINKING /etc/sysconfig/prelink
then
  sed -i 's/PRELINKING.*/PRELINKING=no/g' /etc/sysconfig/prelink
else
  echo -e "\n# Set PRELINKING=no per security requirements" >> /etc/sysconfig/prelink
  echo "PRELINKING=no" >> /etc/sysconfig/prelink
fi
/usr/sbin/prelink -ua
yum install aide -y && /usr/sbin/aide --init && cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz && /usr/sbin/aide --check &
echo "Updating cron..."
rm -f /etc/cron.allow
rm -f /etc/cron.deny
echo "Script is now finished... Check the log file for what suid files are found files.log in the same dir."
echo "Double check that selinux is enabled then reboot"
echo "Here are the SUID files" > files.log
find / -perm -4000 -print  >> files.log
echo "----------------------" >> files.log
echo "This is the SGID files" >> files.log
echo "______________________" >> files.log
find / -perm -2000 -print  >> files.log


