if docker ps | grep -o wrestling-stats_app_1 ; then
  docker exec -it wrestling-stats_app_1 bash
else
  echo "run ./docker/start_app.sh first"
fi
