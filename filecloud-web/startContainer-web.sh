docker ps -a --filter "name=filecloud_web_container" --format "{{.Names}}" | grep -w filecloud_web_container > /dev/null 2>&1 && \
(docker restart filecloud_web_container) || \
(docker run -d -p 8080:80 --name filecloud_web_container filecloud_web:latest)
