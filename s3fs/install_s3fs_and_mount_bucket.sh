#!/usr/bin/env bash
temp_install_dir='/src'
if [[ $EUID -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi

#install dependencies
yum install -y automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel

#prepare directories
mkdir ${temp_install_dir}
chown centos:centos /src

#compile and install s3fs
git clone https://github.com/s3fs-fuse/s3fs-fuse.git ${temp_install_dir}
cd ${temp_install_dir}
./autogen.sh
./configure
make
make install

#create password file for s3fs
read -p 'AMAZON AWS access key ID: ' accesskey
read -sp 'AMAZON AWS secret access key: ' secretaccesskey

echo ${accesskey}:${secretaccesskey} >  ~/.passwd-s3fs
chmod 600  ~/.passwd-s3fs

#create mount
read -p 'AMAZON AWS bucket name: ' bucketname
read -p 'Mount point: ' mountpoint
s3fs ${bucketname} ${mountpoint} -o passwd_file=~/.passwd-s3fs


