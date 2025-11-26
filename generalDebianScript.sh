#!/bin/bash


echo "updating and upgrading..."

sudo apt update
sudo apt upgrade -y

echo "cleaning up unused things..."

sudo apt autoremove -y

echo "setting up firewall - UFW"

sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "securing critical files"

sudo chmod 644 /etc/passwd
sudo chmod 600 /etc/shadow
sudo chmod 600 /etc/gshadow
sudo chmod 644 /etc/group

echo "locking root account..."

sudo passwd -l root

echo "setting up auditd..."

sudo apt install auditd -y
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
