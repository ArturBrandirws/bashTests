createFiles() {
    # Create the amount of files.txt with different names
    for ((i=1; i<=$3; i++)); do
        sudo touch "$1/$2/file_$i.txt"
        echo "created file_$I.txt in $1/$2"
    done
}

main() {

    ## assign params
    mount_location=$1
    username=$2
    amount_files=$3

    createFiles "$1" "$2" "$3"
}

main "$@"