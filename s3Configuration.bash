#!/bin/bash

# Check if bucket name, access key, and secret key are provided as arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <bucket_name> <access_key> <secret_key>"
    exit 1
fi

# Assign parameters
bucket_name=$1
access_key=$2
secret_key=$3

# Step 1: Installing s3fs
echo "Installing s3fs"
sudo apt -y install s3fs

# Step 2: Creating directories
echo "Creating directories"
sudo mkdir -p /var/s3

# Step 3: Editing shells
echo "Editing shells"
sudo bash -c 'echo "/bin/false" >> /etc/shells'

# Step 4: Storing AWS accessKey
echo "Storing AWS accessKey"
echo "$access_key:$secret_key" | sudo tee /etc/passwd-s3fs > /dev/null

# Step 5: Adjusting permissions
echo "Adjusting permissions"
sudo chmod 600 /etc/passwd-s3fs

# Step 6: Configuring S3 Bucket
echo "Configuring S3 Bucket"
sudo s3fs $bucket_name -o use_cache=/tmp -o allow_other -o mp_umask=022 -o multireq_max=5 /var/s3

# Step 7: Automating s3fs to start with the machine
echo "Automating s3fs to start with the machine"
sudo bash -c "echo \"$bucket_name /var/s3 fuse.s3fs  _netdev,use_cache=/tmp,allow_other,mp_umask=022,multireq_max=5,passwd_file=/etc/passwd-s3fs   0 0\" >> /etc/fstab"
