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

echo "turning on ufw"

sudo ufw enable

echo "securing critical files"

[ -f /etc/securetty ] && chmod 600 /etc/securetty && chown root:root /etc/securetty
chmod 644 /etc/crontab
chown root:root /etc/crontab
[ -f /etc/ftpusers ] && chmod 640 /etc/ftpusers
[ -f /etc/hosts.allow ] && chmod 644 /etc/hosts.allow
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

# Fix cron directories (must be 755)
for d in /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d; do
    [ -d "$d" ] && chmod 755 "$d" && chown root:root "$d"
done



echo "setting up auditd..."

sudo apt-get install auditd -y
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

echo "disabiling guest account"

if [ -f /etc/lightdm/lightdm.conf ]; then
    sed -i 's/^#\?allow-guest=.*/allow-guest=false/' /etc/lightdm/lightdm.conf
fi


echo "SUID Files. will be in root as a txt"
sudo sh -c "find / -perm -4000 -type f 2>/dev/null > /root/suid_files.txt"

echo "general script done. if you see this msg, then the script has not broke the system"

