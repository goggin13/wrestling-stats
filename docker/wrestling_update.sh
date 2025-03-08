set -e option

echo "docker exec -it dumbledore_app_1 bundle exec rake wrestling:reset_schedule wrestling:rankings"
docker exec -it dumbledore_app_1 bundle exec rake wrestling:reset_schedule wrestling:rankings

