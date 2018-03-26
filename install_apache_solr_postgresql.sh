#!/usr/bin/env bash

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
yum install -y epel-release screen nmap tcpdump nmon wget lsof

## disable SElinux
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# install postgresql-server and postgresql-contrib
yum install -y \
https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-9.6.6-1PGDG.rhel7.x86_64.rpm \
https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-libs-9.6.6-1PGDG.rhel7.x86_64.rpm \
https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-server-9.6.6-1PGDG.rhel7.x86_64.rpm \
https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/postgresql96-contrib-9.6.6-1PGDG.rhel7.x86_64.rpm

## clean- and set rights data dir
rm -rf /var/db/*
chown postgres:postgres /var/db
chmod 700 /var/db
data_dir="'/var/db'"
cd /var/db

## initialize database and change configuration to custom directory
sudo -u postgres /usr/pgsql-9.6/bin/initdb -D /var/db
sed -i -e "s@PGDATA=/var/lib/pgsql/9.6/data@PGDATA=/var/db@g" /var/lib/pgsql/.bash_profile
sed -i -e "s@Environment=PGDATA=/var/lib/pgsql/9.6/data/@Environment=PGDATA=/var/db/@g" /usr/lib/systemd/system/postgresql-9.6.service

## enable start of service on boot and start service
systemctl enable postgresql-9.6.service
systemctl start postgresql-9.6.service
systemctl status postgresql-9.6.service


# install solr
## installing java (openjdk)
yum install -y java-1.8.0-openjdk.x86_64

### downloading and extracting solr 4.1.0
wget https://archive.apache.org/dist/lucene/solr/4.1.0/solr-4.1.0.tgz -P /tmp && \
tar zxf /tmp/solr-4.1.0.tgz -C /opt/

### downloading and extracting solr 4.10.1
wget https://archive.apache.org/dist/lucene/solr/4.10.1/solr-4.10.1.tgz -P /tmp && \
tar zxf /tmp/solr-4.10.1.tgz -C /opt

### opening firewall
firewall-cmd --zone=public --add-port=8983/tcp --permanent && \
firewall-cmd --zone=public --add-port=8984/tcp --permanent && \
firewall-cmd --reload

## create services for solr
### solr 4.1.0
cat <<EOT >> /etc/systemd/system/solr-4.1.0.service
[Unit]
Description=Solr 4.1.0

[Service]
Type=simple
WorkingDirectory=/opt/solr-4.1.0/example
ExecStart=/usr/bin/java -jar /opt/solr-4.1.0/example/start.jar
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

### solr 4.10.1
cat <<EOT >> /etc/systemd/system/solr-4.10.1.service
[Unit]
Description=Solr 4.10.1

[Service]
Type=simple
WorkingDirectory=/opt/solr-4.10.1/
ExecStart=/opt/solr-4.10.1/bin/solr -f -p 8984
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

## enable start of service on boot and start service
systemctl enable solr-4.1.0.service
systemctl start solr-4.1.0.service
systemctl status solr-4.1.0.service

systemctl enable solr-4.10.1.service
systemctl start solr-4.10.1.service
systemctl status solr-4.10.1.service

# cleanup
rm -rf /tmp/solr*
