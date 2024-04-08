#!/bin/bash

# source the functions file
source ./scripts/users.bash

usage() {
    echo "Usage: $0 <bucket_name> <mount_location>"
}

create_directories() {
    echo "Creating directories"

    ## if the bucket directory exist
    if [ -d "$1" ]; then
        echo "$1 already exists"
    
    ## if doesn't exist
    else    

        ## create the directory
        mkdir -p "$1"
        echo "$1 created"
    fi
}

edit_shells() {
    echo "Editing shells"

    ## if the /etc/shells already contains "/bin/false"
    if grep -q "/bin/false" /etc/shells; then
        echo "/bin/false already exists"

    ## if the /etc/shells doesn't contains "/bin/false"
    else
        echo "/bin/false doesn't exist"

        ## insert "/bin/false" into /etc/shells
        bash -c 'echo "/bin/false" >> /etc/shells'
    fi
}

configure_s3_bucket() {
    echo "Configuring S3 Bucket"

    ## Mount the bucket into the folder passed
    s3fs "$1" -o use_cache=/tmp -o allow_other -o mp_umask=022 -o multireq_max=5,nonempty "$2"

}

automate_start_with_machine() {
    echo "Automating s3fs to start with the machine"

    ## Automate the mount when the machine reboot
    bash -c "echo \"$1 $2 fuse.s3fs _netdev,use_cache=/tmp,allow_other,mp_umask=022,multireq_max=5,passwd_file=/etc/passwd-s3fs 0 0\" >> /etc/fstab"
}

show_configuration() {

    echo "S3 bucket $bucket_name is mounted in $mount_location"
}

main() {
  ## Assing params
  user_list=$(usersList)
  echo "user_list is ${user_list[@]}"

  # Set the IFS variable to ;
  IFS=';'

  # Read the output into an array, splitting by ;
  parsedArray=($user_list)

  # Reset IFS to the default value
  unset IFS

  ##########

  # Set the IFS variable to ,
  IFS=','

  # Iterate over the parsedArray
  for element in "${parsedArray[@]}"; do
    # Parse the element by , and read into an array
    parsedElement=($element)

    # Get the first value
    user_name=${parsedElement[0]}
    bucket_name=${parsedElement[1]}

    # Print the first value
    echo "userName is $user_name"
    echo "bucket is $bucket_name"

    # Define mount location
    mount_location="/var/$bucket_name"

    ## create directories where the bucket will be mounted
    create_directories "$mount_location"

    ## Edit the shells to insert /bin/false
    edit_shells

    ## configure the s3 bucket in the mount location
    configure_s3_bucket "$bucket_name" "$mount_location"

    ## automate the bucket mount when the machine reboot
    automate_start_with_machine "$bucket_name" "$mount_location"

    ## Print the end of configuration
    show_configuration "$bucket_name" "$mount_location"
  done

  # Reset IFS to the default value
  unset IFS
}

main
