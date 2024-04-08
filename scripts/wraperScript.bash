setNewEc2() {

    ## Configure AWSCLI
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/configureAWSCLI.bash") $1 $2

    ## StoreAwsCredentials
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/storeAwsCredentials.bash") $1 $2

    ## mount bucket
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/s3Configuration.bash") $3 $4

    ## create user
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/userCreation.bash") $4 $5 $6
}

main() {

    ## assign params
    access_key=$1
    secret_key=$2
    Bucket_Name=$3
    mount_location=$4
    group_user=$5
    username=$6

    setNewEc2 "$1" "$2" "$3" "$4" "$5" "$6"
}

main "$@"