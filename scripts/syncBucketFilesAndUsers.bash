#!/bin/bash

usage() {
    echo "Usage: $0 <BucketName> <MountLocation>"
}

sync_bucket() {

    
    sudo mkdir $2

    ## sync files from the specified bucket
    sudo aws s3 sync s3://$1 $2
}

create_users() {
    
    ## for every user file in the bucket sync
    for file in "$1"/*; do

        ## set the username as the filename
        username=$(basename "$file")

        ## create a sftp user for the bucket
        bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/userCreation.bash") "$1" "$2" "$username"
    done
}

show_configuration() {

    ## Print the configuration message
    echo "Synchronized with $1 bucket SFTP users and files"
}

main () {

    ## If the user don't pass 2 arguments
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi

    Bucket_Name=$1
    mount_location=$2

    ## Sync files with the bucket passed
    sync_bucket "$Bucket_Name" "$mount_location"

    ## create a sftp user for every file in the bucket sync
    create_users "$mount_location" "$Bucket_Name"

    ## Print the configuration message
    show_configuration "$Bucket_Name"
}

main "$@"