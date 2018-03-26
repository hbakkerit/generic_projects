#!/usr/bin/env bash
RPM_PACKAGE="remi-release-7.4-1.el7.remi.noarch.rpm"

# check if user is root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 
  exit 1
fi

# install basic packages
yum clean all > /dev/null
echo "Updating packages..."
yum update -y
echo "Installing basic packages..."
yum install -y epel-release screen nmap tcpdump nmon wget

## disable SElinux
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# install and configure apache
echo "Installing Apache web server..."
yum install -y httpd-2.4.6-67.el7.centos

## open firewall ports for apache
echo "Opening firewall ports for Apache..."
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

## enable apache start at boot and start apache
systemctl start httpd
systemctl enable httpd

# install and enable php appropriate versions
echo "Installing PHP..."

## get repository and install it using rpm
wget http://rpms.remirepo.net/enterprise/7/safe/x86_64/$RPM_PACKAGE -P /tmp
rpm -ivh /tmp/$RPM_PACKAGE

## install php versions
yum install -y php71 php71-php-fpm php71-php-mbstring php71-php-mysqlnd php71-php-pgsql #maybe more packages needed
yum install -y php56 php56-php-fpm php56-php-mbstring php56-php-mysqlnd php56-php-pgsql #maybe more packages needed

## replace line in config file to assign correct port and process manager setting
sed -i -e 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9071/g' /etc/opt/remi/php71/php-fpm.d/www.conf
sed -i -e 's/pm = dynamic/pm = ondemand/g' /etc/opt/remi/php71/php-fpm.d/www.conf
sed -i -e 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9056/g' /etc/opt/remi/php56/php-fpm.d/www.conf
sed -i -e 's/pm = dynamic/pm = ondemand/g' /etc/opt/remi/php56/php-fpm.d/www.conf

## start and enable php-fpm for both php versions
systemctl start php71-php-fpm
systemctl enable php71-php-fpm
systemctl start php56-php-fpm
systemctl enable php56-php-fpm

# cleanup
rm -rf /tmp/$RPM_PACKAGE
