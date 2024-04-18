#!/bin/bash

usage() {
    echo "Usage: This script don't accept any param."
}

prepare_system() {

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

    echo "Performing system update and upgrade"

    ## update and upgrade the system
    sudo apt update && sudo apt -y upgrade

    echo "System update finished"
}

install_aws_cli() {
    echo "Installing AWS CLI"
    sudo su
    apt install -y unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws s3 sync s3://rws-sftp-config/scripts/ ../scripts/
    aws s3 sync s3://rws-sftp-config/ssh_public_keys/ ../ssh_public_keys/
    for file in $(find ../scripts -type f); do chmod +x $file; done
    ../scripts/main.bash
    echo "AWS CLI installed"

  # Parse array by end of line ; (for each user/bucket/password)
  IFS=';'
  user_list=$(aws secretsmanager get-secret-value --secret-id prod/sftp/server --query SecretString  --output text | tr -d '{}' | tr ',' ';' | tr -d '"' | tr ':' ',')
  parsed_user_list=($user_list)
  unset IFS
  ##########

  # Iterate for each user/bucket/password
  IFS=','
  for element in "${parsed_user_list[@]}"; do
    # Parse the element by , and read into an array
    parsed_element=($element)

    # Get the first value
    user_name=${parsed_element[0]}
    bucket_name=${parsed_element[1]}

    # Print the first value
    echo "user_name is $user_name"
    echo "bucket_name is $bucket_name"
     # Sync files from s3 on this bucket to this machine
    # echo "Starting S3 sync to local"
    sudo aws s3 sync s3://rws-sftp-teste/$user_name/upload/ /var/rws-sftp/$user_name/upload/
    # echo "Ended S3 sync to local"
  done
  unset IFS 
}

main () {
    ## Update and upgrade the system
    prepare_system
}

main