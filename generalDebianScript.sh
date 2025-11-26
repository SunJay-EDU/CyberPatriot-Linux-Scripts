#!/bin/bash


echo "updating and upgrading..."

sudo apt-get update
sudo apt-get upgrade -y

echo "cleaning up unused things..."

sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y

echo "setting up firewall - UFW"

sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "blocking insecure ports via UFW"

sudo ufw deny 23
sudo ufw deny 515
sudo ufw deny 111
sudo ufw deny 1337
sudo ufw deny 2049
sudo ufw deny 7100

echo "setting up UFW logging"

sudo ufw logging on
sudo ufw logging high

echo "denying certain services. please be sure to comment out ones that are not needed"

sudo ufw deny ftp
sudo ufw deny http
sudo ufw deny telnet
sudo ufw deny smtp
sudo ufw deny printer
sudo ufw allow ssh

echo "securing critical files"

chown root:root /etc/securetty
chmod 0600 /etc/securetty
chmod 644 /etc/crontab
chmod 640 /etc/ftpusers
chmod 440 /etc/inetd.conf
chmod 440 /etc/xinted.conf
chmod 400 /etc/inetd.d
chmod 644 /etc/hosts.allow
chmod 440 /etc/sudoers
chmod 440 /etc/sudoers.d
chmod 600 /etc/shadow
chown root:root /etc/shadow
chmod 644 /etc/passwd
chown root:root /etc/passwd
chmod 644 /etc/group
chown root:root /etc/group
chmod 600 /etc/gshadow
chown root:root /etc/gshadow
chmod 700 /boot
chown root:root /etc/anacrontab
chmod 600 /etc/anacrontab
chown root:root /etc/crontab
chmod 600 /etc/crontab
chown root:root /etc/cron.hourly
chmod 600 /etc/cron.hourly
chown root:root /etc/cron.daily
chmod 600 /etc/cron.daily
chown root:root /etc/cron.weekly
chmod 600 /etc/cron.weekly
chown root:root /etc/cron.monthly
chmod 600 /etc/cron.monthly
chown root:root /etc/cron.d
chmod 600 /etc/cron.d


echo "locking root account..."

sudo passwd -l root

echo "setting up auditd..."

sudo apt-get install auditd -y
sudo auditctl -e 1
sudo systemctl enable auditd
sudo systemctl start auditd



echo "doing some networking things..."

sudo sysctl -w net.ipv4.tcp_syncookies=1
echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward
echo "nospoof on" | sudo tee -a /etc/host.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_forward = 0" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p


echo "getting rid of alias stuff"
unalias -a
