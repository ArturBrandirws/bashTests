usersList() {
  USER1="rws-integration-service,rws-sftp-test;"
  USER2="rappi,rws-sftp-test;"

  userList=($USER1$USER2)

  echo "${userList[@]}"
}