#!bin/bash

echo "fixing anon upload, anon enable, and chroot"
sudo sed -i '/^anon_upload_enable/ c\anon_upload_enable no' /etc/vsftpd.conf
sudo sed -i '/^anonymous_enable/ c\anonymous_enable=NO' /etc/vsftpd.conf
sudo sed -i '/^chroot_local_user/ c\chroot_local_user=YES' /etc/vsftpd.conf
sed -i 's/^#\?ssl_enable=.*/ssl_enable=YES/' /etc/vsftpd.conf
sed -i 's/^#\?allow_anon_ssl=.*/allow_anon_ssl=NO/' /etc/vsftpd.conf
sed -i 's/^#\?force_local_data_ssl=.*/force_local_data_ssl=YES/' /etc/vsftpd.conf
sed -i 's/^#\?force_local_logins_ssl=.*/force_local_logins_ssl=YES/' /etc/vsftpd.conf
sed -i 's/^#\?ssl_tlsv1=.*/ssl_tlsv1=YES/' /etc/vsftpd.conf
sed -i 's/^#\?ssl_sslv2=.*/ssl_sslv2=NO/' /etc/vsftpd.conf
sed -i 's/^#\?ssl_sslv3=.*/ssl_sslv3=NO/' /etc/vsftpd.conf

sudo service vsftpd restart
