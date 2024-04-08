usersList() {
  USER1="rws-integration-service,bucket-demonstracao-2;"
  USER2="rappi,bucket-demonstracao-2;"

  userList=($USER1$USER2)

  echo "${userList[@]}"
}