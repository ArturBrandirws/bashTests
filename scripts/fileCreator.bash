usage() {

    echo "Usage: $0 <MountLocation> <username> <amount_files>"
}

createFiles() {
   
    # Create the amount of files.txt with different names
    for ((index = 1; index <= $3; index++)); do

        ## create the file in the passed path
        sudo touch "$1/$2/upload/file_$index.txt"

        ## if the index is 100, 200, 300 ...
        if [$index % 100 == 0]; then
            
            ## print a feedback of the file's creation 
            echo "created file_$index.txt in $1/$2/upload"
        fi
    done
}

main() {

    ## if the number of params isn't equal to 3
    if [ $# -ne 3 ]; then
        usage
        exit 1
    fi

    ## assign params
    mount_location=$1
    username=$2
    amount_files=$3

    ## create the number of files passed in the path indicated
    createFiles "$1" "$2" "$3"
}

main "$@"