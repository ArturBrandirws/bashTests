#!/bin/bash

usage() {
    echo "Usage: $0 <access_key> <secret_key> "
}

install_s3fs() {
    echo "Installing s3fs"

    ## install s3fs
    sudo apt -yqq install s3fs
}

store_aws_credentials() {
    echo "Storing AWS accessKey"

    ## if the file with aws credentials doesn't exist
    if [ ! -f /etc/passwd-s3fs ]; then

        ## Insert the credentials into /etc/passwd-s3fs
        echo "$1:$2" | sudo tee /etc/passwd-s3fs > /dev/null
    fi
}

adjust_permissions() {
    echo "Adjusting permissions"
    
    ## if the /etc/passwd-s3fs file isn't chmod 600
    if [ $(stat -c "%a" /etc/passwd-s3fs) -ne 600 ]; then

        sudo chmod 600 /etc/passwd-s3fs
    fi
}

show_configuration() {

    echo "AWS credentials saved in /etc/passwd-s3fs"
}

main () {

    ## If the user don't pass 2 arguments
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi

    access_key=$1
    secret_key=$2
    
    ## Intalls s3fs
    install_s3fs

    ## Store the aws credentials in /etc/passwd-s3fs
    store_aws_credentials "$access_key" "$secret_key"

    ## make the aws credentials file able to be readed
    adjust_permissions

    ## Print the end of configuration
    show_configuration
}

main "$@"