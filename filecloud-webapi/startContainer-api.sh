docker ps -a --filter "name=filecloud_api_container" --format "{{.Names}}" | grep -w filecloud_api_container > /dev/null 2>&1 && \
(docker restart filecloud_api_container) || \
(docker run -v /home/wwwroot:/home/wwwroot -d -p 7963:7963 --name filecloud_api_container filecloud_api:latest)
