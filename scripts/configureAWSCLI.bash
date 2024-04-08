#!/bin/bash

usage() {
    echo "Usage: $0 <access_key> <secret_key> "
}

prepare_system() {

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

    echo "Performing system update and upgrade"

    ## update and upgrade the system
    sudo apt update && sudo apt -y upgrade
}

install_awscli() {
    echo "Installing awscli"

    ## install awscli
    sudo apt -y install awscli
}

store_aws_credentials() {
    
    echo "Configuring AWS credentials"

    ## insert the accesskey in the AWSCLI credentials file
    sudo aws configure set aws_access_key_id $1

    ## insert the secretkey in the AWSCLI credentials file
    sudo aws configure set aws_secret_access_key $2

}

show_configuration() {

    ## Print the end of configuration
    echo "AWS credentials saved .aws/credentials"
}

main () {

    ## If the user don't pass 2 arguments
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi

    access_key=$1
    secret_key=$2

    ## Update and upgrade the system
    prepare_system
    
    ## Intalls s3fs
    install_awscli

    ## Store the aws credentials in /etc/passwd-s3fs
    store_aws_credentials "$access_key" "$secret_key"

    ## Print the end of configuration
    show_configuration
}

main "$@"