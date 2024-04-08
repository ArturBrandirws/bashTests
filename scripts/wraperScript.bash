setNewEc2() {

    ## Configure AWSCLI
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/configureAWSCLI.bash")

    ## StoreAwsCredentials
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/storeAwsCredentials.bash")

    ## mount bucket
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/s3Configuration.bash") $1 $2

    ## create user
    bash <(wget -qO- "https://raw.githubusercontent.com/ArturBrandirws/bashTests/main/scripts/userCreation.bash") $2 $3 $4
}

main() {

    ## assign params
    Bucket_Name=$1
    mount_location=$2
    group_user=$3
    username=$4

    setNewEc2 "$1" "$2" "$3" "$4"
}

main "$@"