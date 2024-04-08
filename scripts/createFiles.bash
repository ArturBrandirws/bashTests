createFiles2() {
    # Create 10000 files.txt with different names
    for ((i=1; i<=10000; i++)); do
        touch "$1/$2/file_$i.txt"
    done
}

main() {

    ## assign params
    mount_location=$1
    username=$2

    createFiles "$1" "$2"
}

main "$@"