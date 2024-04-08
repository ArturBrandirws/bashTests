usage() {
  echo "Usage: $0 <BucketName> <MountLocation> <group_user> <username>"
}

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
  chmod +x ./scripts/initial_setup.bash
  ./scripts/initial_setup.bash

  ## S3FS installation and setup
  chmod +x ./scripts/s3fs_config.bash
  ./scripts/s3fs_config.bash

  ## mount bucket
  chmod +x ./scripts/mount_s3fs_bucket.bash
  ./scripts/mount_s3fs_bucket.bash

  ## create user
  chmod +x ./scripts/create_users.bash
  ./scripts/create_users.bash
}

main() {
  validateVariables

  ## makes all ec2 configuration
  setNewEc2
}

main