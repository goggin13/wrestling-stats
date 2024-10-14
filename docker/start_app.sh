rm -f tmp/pids/server.pid

PROCESS_COUNT=$(ps aux | grep docker | wc -l)

echo $PROCESS_COUNT

if [ $PROCESS_COUNT -lt 5 ]
then
	echo "Open Docker!"
	exit 1
else
	echo "Docker is running"
fi

until [ $PROCESS_COUNT -gt 10 ]; do
	sleep 1
	echo "...waiting for docker"
	PROCESS_COUNT=$(ps aux | grep docker | wc -l)
	echo "\tfound $PROCESS_COUNT processes"
done

sleep 10

docker-compose --project-name dumbledore up 
docker-compose rm -f
