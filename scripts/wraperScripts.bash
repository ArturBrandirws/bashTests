main() {

    ## assign params
    access_key=$1
    secret_key=$2
    Bucket_Name=$3
    mount_location=$4
    group_user=$5
    username=$6

    setNewEc2 ""
}

main "$@"