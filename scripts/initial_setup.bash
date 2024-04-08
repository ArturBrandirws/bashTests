#!/bin/bash

usage() {
    echo "Usage: This script don't accept any param."
}

prepare_system() {

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

    ## edit /etc/needrestart/needrestart.conf to avoid kernel restart window
    sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

    echo "Performing system update and upgrade"

    ## update and upgrade the system
    echo "Starting update and upgrade apt"
    apt update && sudo apt -y upgrade
    echo "Ended update and upgrade apt"
}

install_awscli() {
    echo "Installing awscli"

    ## install awscli
    apt -y install awscli
    echo "Ended awscli"
}

show_configuration() {

    ## Print the end of configuration
    echo "System upgraded and AWSCLI installed"
}

main () {
    ## Update and upgrade the system
    prepare_system
    
    ## Intalls s3fs
    install_awscli

    ## Print the end of configuration
    show_configuration
}

main