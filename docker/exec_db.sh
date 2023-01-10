if docker ps | grep -o dumbledore_database_1 ; then
  docker exec -it dumbledore_database_1 bash
else
  echo "run ./docker/start_app.sh first"
fi
