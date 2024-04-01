#!/bin/bash

# Check if bucket name is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <bucket_name>"
    exit 1
fi

# Assign bucket name from argument
bucket_name=$1

# Step 1: Installing s3fs
sudo apt -y install s3fs

# Step 2: Creating directories
sudo mkdir -p /var/s3

# Step 3: Editing shells
sudo bash -c 'echo "/bin/false" >> /etc/shells'

# Step 4: Storing AWS accessKey
sudo bash -c 'echo "accessKey:secretKey" > /etc/passwd-s3fs'

# Step 5: Adjusting permissions
sudo chmod 600 /etc/passwd-s3fs

# Step 6: Configuring S3 Bucket
sudo s3fs $bucket_name -o use_cache=/tmp -o allow_other -o mp_umask=022 -o multireq_max=5 /var/s3

# Step 7: Automating s3fs to start with the machine
sudo bash -c 'echo "$bucket_name /var/s3 fuse.s3fs  _netdev,use_cache=/tmp,allow_other,mp_umask=022,multireq_max=5,passwd_file=/etc/passwd-s3fs   0 0" >> /etc/fstab'
