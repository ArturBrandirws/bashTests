validateVariables() {
   if [[ -z "${AWS_S3_BUCKET_LIST}" ]]; then
    echo "No AWS_S3_BUCKET_LIST environment variable set. Exiting."
    exit 1
   else
    BUCKET_NAME="${AWS_S3_BUCKET_LIST}"
  fi
}

setNewEc2() {
  ## Configure machine and install basic software
  chmod +x ./bashTests/scripts/initial_setup.bash
  ./bashTests/scripts/initial_setup.bash

  ## S3FS installation and setup
  chmod +x ./bashTests/scripts/s3fs_config.bash
  ./bashTests/scripts/s3fs_config.bash

  ## mount bucket
  chmod +x ./bashTests/scripts/mount_s3fs_bucket.bash
  ./bashTests/scripts/mount_s3fs_bucket.bash

  ## create user
  chmod +x ./bashTests/scripts/create_users.bash
  ./bashTests/scripts/create_users.bash
}

main() {
  ##validateVariables

  ## makes all ec2 configuration
  setNewEc2
}

main