#!/bin/bash

usage() {
    echo "Usage: $0 <BucketName> <MountLocation>"
}

sync_bucket() {

    
    sudo mkdir $2

    ## sync files from the specified bucket
    sudo aws s3 sync s3://$1 $2
}

show_configuration() {

    ## Print the configuration message
    echo "Synchronized with $1 bucket files"
}

insert_group_config() {
    if [ -f "$2/group_config" ]; then
        sudo cat "$2/group_config" | sudo tee -a /etc/ssh/sshd_config > /dev/null
        echo "Group config inserted into sshd_config"
    else
        echo "group_config file not found in $2"
    fi
}

main () {

    ## If isn't passed 1 params
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi

    Bucket_Name=$1
    mount_location=$2

    ## Sync files with the bucket passed
    sync_bucket "$Bucket_Name" "$mount_location"

    insert_group_config "$mount_location"

    ## Print the configuration message
    show_configuration "$Bucket_Name"
}

main "$@"