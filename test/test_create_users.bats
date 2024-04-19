#!/usr/bin/env bats

# Teardown function to clean up after each test
teardown() {
  # Remove any test users created during testing
  sudo userdel -r testuser &>/dev/null
  # Remove any test groups created during testing
  sudo groupdel testgroup &>/dev/null
}

# Test installing openssh server
@test "Install OpenSSH server" {
  run source your_script.sh
  run install_openssh_server
  [ "$status" -eq 0 ]
}

# Test creating groups
@test "Create group if not exists" {
  run source your_script.sh
  run configure_ssh_sftp "testgroup" "/var/testgroup"
  [ "$status" -eq 0 ]
}

# Test creating users
@test "Create user if not exists" {
  sudo groupadd testgroup
  run source your_script.sh
  run create_user "testuser" "/var/testgroup" "testgroup"
  [ "$status" -eq 0 ]
}

# Test creating folders
@test "Create user upload folder" {
  run source your_script.sh
  run create_user "testuser" "/var/testgroup" "testgroup"
  [ -d "/var/testgroup/testuser/upload" ]
}

# Test storing public SSH keys
@test "Store public SSH key" {
  run source your_script.sh
  run configure_ssh_key "/var/testgroup" "testuser"
  [ -f "/var/testgroup/testuser/.ssh/authorized_keys" ]
}