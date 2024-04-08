createFiles1() {
    # Create 10000 files.txt with different names
    for ((i=1; i<=10000; i++)); do
        touch "$1/$2/file_$i.txt"
        echo "created file_$I.txt in $1/$2"
    done
}

main() {

    ## assign params
    mount_location=$1
    username=$2

    createFiles1 "$1" "$2"
}

main "$@"