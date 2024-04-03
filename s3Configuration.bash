#!/bin/bash

# Check if bucket name, access key, and secret key are provided as arguments
if [ $# -ne 4 ]; then
    echo "Usage: $0 <bucket_name> <access_key> <secret_key> <username>"
    exit 1
fi

# Perform system update and upgrade
echo "Performing system update and upgrade"
sudo apt update && sudo apt -y upgrade

# Assign parameters
bucket_name=$1
access_key=$2
secret_key=$3
username=$4

# Step 1: Installing s3fs
echo "installing s3fs"
sudo apt -y install s3fs

# Step 2: Creating directories
echo "Creating directories"
sudo mkdir -p /var/s3/$username

# Step 3: Editing shells
echo "Editing shells"
if ! grep -q "/bin/false" /etc/shells ; then
    echo "/bin/false doesn't exist"
    sudo bash -c 'echo "/bin/false" >> /etc/shells'
fi

# Step 4: Storing AWS accessKey
echo "Storing AWS accessKey"
if [ ! -f /etc/passwd-s3fs ]; then
    echo "$access_key:$secret_key" | sudo tee /etc/passwd-s3fs > /dev/null
    # Step 5: Adjusting permissions
    echo "Adjusting permissions"
    sudo chmod 600 /etc/passwd-s3fs
fi

# Step 6: Configuring S3 Bucket
echo "Configuring S3 Bucket"
sudo s3fs $bucket_name -o use_cache=/tmp -o allow_other -o mp_umask=022 -o multireq_max=5 -o nonempty /var/s3/$username

# Step 7: Automating s3fs to start with the machine
echo "Automating s3fs to start with the machine"
sudo bash -c "echo \"$bucket_name /var/s3/$username fuse.s3fs  _netdev,use_cache=/tmp,allow_other,mp_umask=022,multireq_max=5,nonempty,passwd_file=/etc/passwd-s3fs   0 0\" >> /etc/fstab"
