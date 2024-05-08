#!/bin/bash

# Function to download CSV files from S3
download_csv_files() {
    local origin_path="$1"

    if [[ "$origin_path" == s3://* ]]; then
        # Destination is S3 path

        # Define params for the function
        local bucket_and_path="${origin_path#s3://}"
        local bucket="${bucket_and_path%%/*}"
        local s3_folder_path="${bucket_and_path#"$bucket"}"

        echo "Downloading CSV files from S3..."
        aws s3 sync "s3://$bucket/$s3_folder_path" ./temp_files --exclude "*" --include "*.csv"
    else
        # Destination is local path
        echo "Copying CSV files from local path..."

        # Check if origin_path ends with a slash
        if [[ "${origin_path: -1}" != "/" ]]; then
            origin_path="$origin_path/"
        fi

        # Copy all CSV files from origin_path to ./temp_files
        cp -v "$origin_path"*.csv ./temp_files/
    fi
}

# Function to merge CSV files into a single file with new lines between files
merge_csv_files() {
    local output_file_name="$1"
    echo "Merging CSV files..."
    local first_file=true

    # Loop through downloaded CSV files
    for file in ./temp_files/*.csv; do
        if [ "$first_file" = true ]; then
            # If it's the first file, copy the entire file content to the final file
            cat "$file" > "$output_file_name"
            first_file=false
        else
            # Append all lines (excluding header) to the final file
            tail -n +2 "$file" >> "$output_file_name"
        fi
    done
}

# Function to move the final file to S3 or keep it locally
move_file_to_destination() {
    local destination_path="$1"
    local output_file_name

    if [[ "$destination_path" == *.csv ]]; then
        # User specified the name of the file in destination_path
        output_file_name="${destination_path##*/}"  # Get the file name part from the path
    else
        # Default output file name if not specified by the user
        output_file_name="merged_file.csv"
    fi

    echo "Moving final file to destination..."

    if [[ "$destination_path" == s3://* ]]; then
        # Destination is S3 path

        # Define params for the function
        local bucket_and_path="${destination_path#s3://}"
        local bucket="${bucket_and_path%%/*}"
        local s3_destination_path="${bucket_and_path#"$bucket"}"

        echo "Moving final file to S3 $bucket"
        aws s3 cp "./$output_file_name" "s3://$bucket$s3_destination_path/$output_file_name"
    else
        # Destination is local path
        mkdir -p "/$destination_path"
        echo "Moving final file to local ./$destination_path/$output_file_name"
        mv "./$output_file_name" "./$destination_path/$output_file_name"
    fi
}

# Function to clean up temporary file
cleanup_temp_files() {
    echo "Cleaning up temporary files..."
    rm -rf ./temp_files
}

main() {
    # Check if all required parameters are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <origin_path> <destination_path>"
        exit 1
    fi

    # set params
    origin_path="$1"
    destination_path="$2"

    # Execute functions with provided parameters
    download_csv_files "$origin_path"
    merge_csv_files "$output_file_name"
    move_file_to_destination "$output_file_name" "$destination_path"
    cleanup_temp_files

    echo "Process completed!"
}

main "$@"