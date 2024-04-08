usersList() {
  USER1="rws-integration-service,bucket-demonstracao-2;"
  USER2="rappi,bucket-demonstracao-2;"
<<<<<<< HEAD
=======
  USER3="teste,bucket-demonstracao-1;"
>>>>>>> parent of 057dbce (teste)

  userList=($USER1$USER2$USER3)

  echo "${userList[@]}"
}