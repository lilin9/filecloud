export aspnetcore_environment=Development

if [ ! -d "/home/wwwroot" ]; then
    sudo mkdir /home/wwwroot/filecloud/Avatar
else
    sudo chmod -R 777 /home/wwwroot/filecloud
fi

if [ -f "./docker-compose.yml" ]; then
   sudo docker-compose up -d
fi
