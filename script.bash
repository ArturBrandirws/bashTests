#!/bin/bash

# Check if username is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1

# Step 1: Installing OpenSSH server

echo "Installing OpenSSH server"
sudo apt-get install -y openssh-server
echo "OpenSSH server installed"


# Step 2: Creating group and configuring
sudo groupadd sftpusers
echo "group created"

# Step 3: Creating user and configuring

echo "creating user"
sudo useradd -m -d /var/s3/$username -g sftpusers -s /bin/false $username
sudo passwd -d $username
sudo mkdir -p /var/s3/$username/upload
sudo chmod 755 /var/s3/$username
echo "user created"

# Step 4: Adjusting owners

echo "Adjusting owners"
sudo chown root:sftpusers /var/s3/$username
sudo chown $username:sftpusers /var/s3/$username/upload

# Step 5: Configuring SSH to SFTP

echo "Configuring SSH to SFTP"
sudo bash -c 'cat <<EOF >> /etc/ssh/sshd_config

KbdInteractiveAuthentication no
PasswordAuthentication yes
PermitRootLogin no

Match Group sftpusers
       ChrootDirectory /var/s3/%u
       ForceCommand internal-sftp
       AllowTcpForwarding no
EOF'
echo "SFTP configuration finished"

# Step 6: Restarting SSH service
sudo systemctl restart sshd

# Step 7: Configuring SSH key
echo "Configuring SSH key"
sudo mkdir /var/s3/$username/.ssh
sudo wget -O /var/s3/$username/.ssh/authorized_keys https://raw.githubusercontent.com/your_username/your_public_key_repo/main/authorized_keys

echo "SFTP configured!"