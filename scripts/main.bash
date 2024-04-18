setNewEc2() {
  ## Setup machine
  /scripts/initial_setup.bash

  ## S3FS installation and setup
  /scripts/s3fs_config.bash

  ## mount bucket
  /scripts/mount_s3fs_bucket.bash

  ## Setup sftp and create user
  /scripts/create_users.bash

  # cron to execute sync
  # (crontab -l 2>/dev/null; echo "*/1 * * * * /scripts/s3_sync.sh") | crontab -
}

main() {
  ## makes all ec2 configuration
  setNewEc2
}

main