if docker ps | grep -o dumbledore_app_1 ; then
  docker exec -it dumbledore_app_1 bash
else
  echo "run ./docker/start_app.sh first"
fi
