#!/bin/bash

echo "Starting S3 sync from local"
sudo aws s3 sync /var/rws-sftp-teste s3://rws-sftp-teste
echo "Ended S3 sync from local"