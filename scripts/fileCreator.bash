#!/usr/bin/env bats

source ~/bashTests/scripts/users.bash

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
}

teardown() {
  if [ "$(dpkg-query -W -f='${Status}' openssh-server | grep -c "ok installed")" -eq 1 ]; then
    sudo apt-get remove -y openssh-server
  fi

  if grep -q grouptest /etc/group; then
    sudo groupdel grouptest
  fi

  if id testUser &>/dev/null; then
    sudo userdel testUser
  fi
}

@test "Install OpenSSH server" {
  source ~/bashTests/scripts/create_users.bash
  output=$(install_openssh_server | grep -o 'OpenSSH server installed$')
  assert_output 'OpenSSH server installed' "$output"
}

@test "Create group if not exists" {
  source ~/bashTests/scripts/create_users.bash
  output=$(configure_ssh_sftp "grouptest" "/var/grouptest" | grep -o 'group added')
  assert_output 'group added' "$output"
}

# Test creating users
@test "Create user if not exists" {
  source ~/bashTests/scripts/create_users.bash
  if grep -q grouptest /etc/group; then
    echo "grouptest already exist"
  else
    sudo groupadd grouptest
  fi
  output=$(create_user "testUser" "/var/grouptest" "grouptest" | grep -o 'User created')
  assert_output 'User created' "$output"
}

@test "Create user's folder" {
  source ~/bashTests/scripts/create_users.bash
  if grep -q grouptest /etc/group; then
    echo "grouptest already exist"
  else
    sudo groupadd grouptest
  fi
  output=$(create_user "testUser" "/var/grouptest" "grouptest" | grep -o 'upload folder created')
  assert_output 'upload folder created' "$output"
}

# Test storing public SSH keys
@test "Store public SSH key" {
  source ~/bashTests/scripts/create_users.bash
  if grep -q grouptest /etc/group; then
    echo "grouptest already exist"
  else
    sudo groupadd grouptest
  fi
  if id testUser &>/dev/null; then
    echo "testUser already exist"
  else
    sudo useradd testUser
  fi
  output=$(configure_ssh_key "grouptest" "testUser" | grep -o 'SFTP configured!')
  assert_output 'SFTP configured!' "$output"
}
