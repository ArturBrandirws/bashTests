#!/bin/bash

# Check if bucket name, access key, secret key, and mount location are provided as arguments
if [ $# -ne 5 ]; then
    echo "Usage: $0 <bucket_name> <access_key> <secret_key> <mount_location>"
    exit 1
fi

# Assign parameters
bucket_name=$1
access_key=$2
secret_key=$3
mount_location=$4
group_user=$5
username=$6

# Preparing ubuntu
echo "Performing system update and upgrade"
sudo apt update && sudo apt -y upgrade

# Step 1: Installing s3fs
echo "Installing s3fs"
sudo apt -y install s3fs

# Step 2: Creating directories
echo "Creating directories"
sudo mkdir -p $mount_location

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
sudo s3fs $bucket_name -o use_cache=/tmp -o allow_other -o mp_umask=022 -o multireq_max=5 $mount_location

# Step 7: Automating s3fs to start with the machine
echo "Automating s3fs to start with the machine"
sudo bash -c "echo \"$bucket_name $mount_location fuse.s3fs  _netdev,use_cache=/tmp,allow_other,mp_umask=022,multireq_max=5,passwd_file=/etc/passwd-s3fs   0 0\" >> /etc/fstab"

# Step 1: Installing OpenSSH server
echo "Installing OpenSSH server"
sudo apt-get install -y openssh-server
echo "OpenSSH server installed"


# Step 2: Creating group and configuring
sudo groupadd $group_user
echo "group created"

# Step 3: Creating user and configuring

echo "creating user"
sudo useradd -m -d $mount_location/$username -g $group_user -s /bin/false $username
sudo passwd -d $username
sudo mkdir -p $mount_location/$username/upload
sudo chmod 755 $mount_location/$username
echo "user created"

# Step 4: Adjusting owners

echo "Adjusting owners"
sudo chown root:$group_user $mount_location/$username
sudo chown $username:$group_user $mount_location/$username/upload

# Step 5: Configuring SSH to SFTP

echo "Configuring SSH to SFTP"
sudo bash -c 'cat <<EOF >> /etc/ssh/sshd_config

KbdInteractiveAuthentication no
PasswordAuthentication yes
PermitRootLogin no

Match Group $group_user
       ChrootDirectory $mount_location/%u
       ForceCommand internal-sftp
       AllowTcpForwarding no
EOF'
echo "SFTP configuration finished"

# Step 6: Restarting SSH service
sudo systemctl restart sshd

# Step 7: Configuring SSH key
echo "Configuring SSH key"
sudo mkdir $mount_location/$username/.ssh
sudo wget -O $mount_location/$username/.ssh/authorized_keys https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/id_rsa.pub

echo "SFTP configured!"
