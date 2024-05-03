#!/bin/bash

# Define functions

# Function to download CSV files from S3
download_csv_files() {
    local bucket="$1"
    local folder_path="$2"
    echo "Downloading CSV files from S3..."
    aws s3 sync "s3://$bucket/$folder_path" ./temp_files --exclude "*" --include "*.csv"
}

# Function to merge CSV files into a single file with new lines between files
merge_csv_files() {
    local output_file_name="$1"
    echo "Merging CSV files..."
    local first_file=true

    # Loop through downloaded CSV files
    for file in ./temp_files/*.csv; do
        if [ "$first_file" = true ]; then
            # If it's the first file, copy the header to the final file
            head -n 1 "$file" > "$output_file_name"
            first_file=false
        else
            # Insert a blank line to separate files
            echo "" >> "$output_file_name"
        fi
        # Append all lines (excluding header) to the final file
        tail -n +2 "$file" >> "$output_file_name"
    done
}

# Function to move the final file to S3
move_file_to_s3() {
    local output_file_name="$1"
    local bucket="$2"
    local destination_path="$3"
    echo "Moving final file to S3..."
    aws s3 cp "./$output_file_name" "s3://$bucket/$destination_path/$output_file_name"
}

# Function to clean up temporary files
cleanup_temp_files() {
    echo "Cleaning up temporary files..."
    rm -rf ./temp_files
}

main() {
    # Check if all required parameters are provided
    if [ "$#" -ne 4 ]; then
        echo "Usage: $0 <bucket> <folder_path> <output_file_name> <destination_path>"
        exit 1
    fi

    # Parse command-line arguments
    bucket="$1"
    folder_path="$2"
    output_file_name="$3"
    destination_path="$4"

    # Execute functions with provided parameters
    download_csv_files "$bucket" "$folder_path"
    merge_csv_files "$output_file_name"
    move_file_to_s3 "$output_file_name" "$bucket" "$destination_path"
    cleanup_temp_files

    echo "Process completed!"
}

main "$@"
