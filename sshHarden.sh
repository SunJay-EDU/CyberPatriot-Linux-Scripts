#!/bin/bash


sudo apt-get install -y --only-upgrade openssh-server
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/^#\?Protocol.*/Protocol 2/' /etc/ssh/sshd_config
systemctl reload sshd

sudo ufw allow ssh
